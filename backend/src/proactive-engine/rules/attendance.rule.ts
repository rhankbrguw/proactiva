import { NotificationPriority, NotificationSource } from '@prisma/client';
import { prisma } from '../../lib/prisma.js';
import { ProactiveNotificationPayload } from '../types.js';
import { NUMBERS } from '../../constants/numbers.js';

export async function evaluateAttendanceRules(userId: string): Promise<ProactiveNotificationPayload[]> {
  const notifications: ProactiveNotificationPayload[] = [];

  const enrollments = await prisma.enrollment.findMany({
    where: { userId },
    include: { course: true },
  });

  for (const enr of enrollments) {
    const latestAttendance = await prisma.attendance.findFirst({
      where: { userId, courseId: enr.courseId },
      orderBy: { tanggal: 'desc' },
    });

    if (!latestAttendance) continue;

    const totalAbsen = latestAttendance.totalAbsenRunning;
    const courseName = enr.course.namaMatkul;

    if (totalAbsen >= NUMBERS.ABSENCE_CRITICAL_LEVEL) {
      notifications.push({
        userId,
        eventId: latestAttendance.id,
        tipe: 'ATTENDANCE_WARNING',
        prioritas: NotificationPriority.URGENT,
        source: NotificationSource.RULE,
        judul: `⚠️ Peringatan Kritis Presensi: ${courseName}`,
        pesan: `Anda telah tercatat ${totalAbsen} kali tidak hadir pada mata kuliah ${courseName}. Batas maksimal ketidakhadiran adalah ${NUMBERS.MAX_ABSENCE_THRESHOLD} kali (ambang kehadiran 75%). Satu kali absen lagi berisiko menggugurkan syarat mengikuti Ujian Akhir Semester (UAS).`,
        payload: {
          courseId: enr.courseId,
          courseName,
          totalAbsen,
          maxAllowedAbsen: NUMBERS.MAX_ABSENCE_THRESHOLD,
          rule: 'RULE_ATTENDANCE_CRITICAL_THRESHOLD',
        },
      });
    } else if (totalAbsen === NUMBERS.ABSENCE_WARNING_LEVEL) {
      notifications.push({
        userId,
        eventId: latestAttendance.id,
        tipe: 'ATTENDANCE_WARNING',
        prioritas: NotificationPriority.HIGH,
        source: NotificationSource.RULE,
        judul: `⚠️ Peringatan Presensi: ${courseName}`,
        pesan: `Anda telah tercatat ${totalAbsen} kali tidak hadir pada mata kuliah ${courseName}. Sisa toleransi ketidakhadiran Anda adalah ${NUMBERS.MAX_ABSENCE_THRESHOLD - totalAbsen} kali sebelum kehilangan hak ujian.`,
        payload: {
          courseId: enr.courseId,
          courseName,
          totalAbsen,
          maxAllowedAbsen: NUMBERS.MAX_ABSENCE_THRESHOLD,
          rule: 'RULE_ATTENDANCE_WARNING_STAGE_1',
        },
      });
    }
  }

  return notifications;
}
