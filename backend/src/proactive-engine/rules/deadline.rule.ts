import { NotificationPriority, NotificationSource } from '@prisma/client';
import { prisma } from '../../lib/prisma.js';
import { ProactiveNotificationPayload, AssignmentCollisionItem } from '../types.js';
import { prioritizeCollidingDeadlines } from '../llm/deadline-prioritizer.js';
import { NUMBERS } from '../../constants/numbers.js';

export async function evaluateAssignmentDeadlines(userId: string): Promise<ProactiveNotificationPayload[]> {
  const notifications: ProactiveNotificationPayload[] = [];

  const enrollments = await prisma.enrollment.findMany({
    where: { userId },
    select: { courseId: true },
  });

  const courseIds = enrollments.map((e) => e.courseId);
  const now = new Date();
  const upcomingWindow = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000);

  const assignments = await prisma.assignment.findMany({
    where: {
      courseId: { in: courseIds },
      deadline: { gte: now, lte: upcomingWindow },
    },
    include: { course: true },
    orderBy: { deadline: 'asc' },
  });

  if (assignments.length === 0) return notifications;

  // Collision detection window
  const nearAssignments = assignments.filter((a) => {
    const diffHours = (new Date(a.deadline).getTime() - now.getTime()) / (1000 * 60 * 60);
    return diffHours <= NUMBERS.COLLISION_WINDOW_HOURS;
  });

  if (nearAssignments.length >= NUMBERS.COLLISION_MIN_COUNT) {
    const collisionPayloads: AssignmentCollisionItem[] = nearAssignments.map((a) => ({
      id: a.id,
      judul: a.judul,
      namaMatkul: a.course.namaMatkul,
      deadline: a.deadline.toISOString(),
      jenis: a.jenis,
      deskripsi: a.deskripsi,
    }));

    const { results, source } = await prioritizeCollidingDeadlines(collisionPayloads);
    const rankingText = results
      .map((r) => {
        const item = nearAssignments.find((a) => a.id === r.assignmentId);
        return `• [Rank ${r.priorityRank}] ${item?.course.namaMatkul}: ${item?.judul}\n  💡 Alasan: ${r.reason}`;
      })
      .join('\n\n');

    notifications.push({
      userId,
      eventId: nearAssignments.map((a) => a.id).join(','),
      tipe: 'DEADLINE_COLLISION_PRIORITY',
      prioritas: NotificationPriority.URGENT,
      source: source === 'LLM' ? NotificationSource.LLM : NotificationSource.RULE,
      judul: `⚡ Rekomendasi Prioritas: ${nearAssignments.length} Tenggat Bertabrakan`,
      pesan: `Terdeteksi ${nearAssignments.length} tugas/kuis dengan tenggat berdekatan dalam 3 hari ke depan:\n\n${rankingText}`,
      payload: {
        totalColliding: nearAssignments.length,
        prioritization: results,
        sourceType: source,
        rule: 'HYBRID_LLM_COLLISION_PRIORITIZATION',
      },
    });

    return notifications;
  }

  // Routine Single Reminders
  for (const a of assignments) {
    const diffHours = (new Date(a.deadline).getTime() - now.getTime()) / (1000 * 60 * 60);
    const diffDays = Math.ceil(diffHours / 24);

    if (diffHours <= NUMBERS.DEADLINE_URGENT_HOURS) {
      notifications.push({
        userId,
        eventId: a.id,
        tipe: 'ASSIGNMENT_REMINDER',
        prioritas: NotificationPriority.HIGH,
        source: NotificationSource.RULE,
        judul: `⏰ Tenggat Besok/Hari Ini: ${a.judul}`,
        pesan: `${a.jenis} mata kuliah ${a.course.namaMatkul} "${a.judul}" harus dikumpulkan sebelum ${new Date(a.deadline).toLocaleString('id-ID')}.`,
        payload: { assignmentId: a.id, diffHours, courseName: a.course.namaMatkul, rule: 'RULE_DEADLINE_H1' },
      });
    } else if (diffDays <= NUMBERS.DEADLINE_WARNING_DAYS) {
      notifications.push({
        userId,
        eventId: a.id,
        tipe: 'ASSIGNMENT_REMINDER',
        prioritas: NotificationPriority.MEDIUM,
        source: NotificationSource.RULE,
        judul: `📌 Pengingat Tenggat (H-3): ${a.judul}`,
        pesan: `${a.jenis} mata kuliah ${a.course.namaMatkul} "${a.judul}" jatuh tempo pada ${new Date(a.deadline).toLocaleString('id-ID')}.`,
        payload: { assignmentId: a.id, diffDays, courseName: a.course.namaMatkul, rule: 'RULE_DEADLINE_H3' },
      });
    }
  }

  return notifications;
}
