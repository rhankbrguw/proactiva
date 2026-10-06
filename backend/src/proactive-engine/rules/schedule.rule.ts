import { NotificationPriority, NotificationSource } from '@prisma/client';
import { prisma } from '../../lib/prisma.js';
import { ProactiveNotificationPayload } from '../types.js';

const DAYS_MAP: Record<number, string> = {
  0: 'Minggu',
  1: 'Senin',
  2: 'Selasa',
  3: 'Rabu',
  4: 'Kamis',
  5: 'Jumat',
  6: 'Sabtu',
};

export async function evaluateScheduleRules(userId: string): Promise<ProactiveNotificationPayload[]> {
  const notifications: ProactiveNotificationPayload[] = [];

  const now = new Date();
  const currentDayName = DAYS_MAP[now.getDay()];

  // Get enrolled courses
  const enrollments = await prisma.enrollment.findMany({
    where: { userId },
    include: {
      course: {
        include: {
          schedules: {
            where: { hari: currentDayName },
          },
        },
      },
    },
  });

  for (const enr of enrollments) {
    for (const sch of enr.course.schedules) {
      notifications.push({
        userId,
        eventId: sch.id,
        tipe: 'SCHEDULE_ALERT',
        prioritas: NotificationPriority.MEDIUM,
        source: NotificationSource.RULE,
        judul: `📚 Jadwal Kuliah Hari Ini: ${enr.course.namaMatkul}`,
        pesan: `Mata kuliah ${enr.course.namaMatkul} (${enr.course.sks} SKS) dijadwalkan hari ini pukul ${sch.jamMulai} - ${sch.jamSelesai} WIB di ${sch.ruang}. Dosen pengampu: ${enr.course.dosen}.`,
        payload: {
          courseId: enr.courseId,
          courseName: enr.course.namaMatkul,
          ruang: sch.ruang,
          jamMulai: sch.jamMulai,
          jamSelesai: sch.jamSelesai,
          rule: 'RULE_SCHEDULE_TODAY',
        },
      });
    }
  }

  return notifications;
}
