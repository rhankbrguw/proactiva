import { prisma } from '../lib/prisma.js';

export class AcademicRepository {
  async findEnrollmentsByUserId(userId: string) {
    return prisma.enrollment.findMany({
      where: { userId },
      include: {
        course: {
          include: { schedules: true },
        },
      },
    });
  }

  async findSchedulesByCourseIds(courseIds: string[]) {
    return prisma.schedule.findMany({
      where: { courseId: { in: courseIds } },
      include: { course: true },
    });
  }

  async findAssignmentsByCourseIds(courseIds: string[]) {
    return prisma.assignment.findMany({
      where: { courseId: { in: courseIds } },
      include: { course: true },
      orderBy: { deadline: 'asc' },
    });
  }

  async findAttendanceByUserId(userId: string) {
    return prisma.enrollment.findMany({
      where: { userId },
      include: {
        course: {
          include: {
            attendances: {
              where: { userId },
              orderBy: { tanggal: 'desc' },
            },
          },
        },
      },
    });
  }

  async findPaymentsByUserId(userId: string) {
    return prisma.payment.findMany({
      where: { userId },
      orderBy: { jatuhTempo: 'asc' },
    });
  }

  async findAllAnnouncements() {
    return prisma.announcement.findMany({
      orderBy: { tanggalTerbit: 'desc' },
    });
  }

  async createAnnouncement(judul: string, isiTeks: string) {
    return prisma.announcement.create({
      data: {
        judul,
        isiTeks,
        source: 'MANUAL',
      },
    });
  }
}

export const academicRepository = new AcademicRepository();
