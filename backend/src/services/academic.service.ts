import { academicRepository } from '../repositories/academic.repository.js';
import { proactiveQueue } from '../queue/proactive.queue.js';
import { NUMBERS } from '../constants/numbers.js';
import { CreateAnnouncementInput } from '../schemas/academic.schema.js';

export class AcademicService {
  async getStudentCourses(userId: string) {
    const enrollments = await academicRepository.findEnrollmentsByUserId(userId);
    return enrollments.map((e) => ({
      ...e.course,
      semester: e.semester,
    }));
  }

  async getStudentSchedules(userId: string) {
    const enrollments = await academicRepository.findEnrollmentsByUserId(userId);
    const courseIds = enrollments.map((e) => e.courseId);
    return academicRepository.findSchedulesByCourseIds(courseIds);
  }

  async getStudentAssignments(userId: string) {
    const enrollments = await academicRepository.findEnrollmentsByUserId(userId);
    const courseIds = enrollments.map((e) => e.courseId);
    return academicRepository.findAssignmentsByCourseIds(courseIds);
  }

  async getStudentAttendanceSummary(userId: string) {
    const enrollments = await academicRepository.findAttendanceByUserId(userId);

    return enrollments.map((e) => {
      const attendances = e.course.attendances;
      const latest = attendances[0];
      const totalAbsen = latest?.totalAbsenRunning || 0;
      const warningLevel =
        totalAbsen >= NUMBERS.ABSENCE_CRITICAL_LEVEL
          ? 'CRITICAL'
          : totalAbsen === NUMBERS.ABSENCE_WARNING_LEVEL
            ? 'WARNING'
            : 'SAFE';

      return {
        courseId: e.course.id,
        kodeMatkul: e.course.kodeMatkul,
        namaMatkul: e.course.namaMatkul,
        sks: e.course.sks,
        dosen: e.course.dosen,
        totalAbsen,
        maxAllowedAbsen: NUMBERS.MAX_ABSENCE_THRESHOLD,
        warningLevel,
        history: attendances,
      };
    });
  }

  async getStudentPayments(userId: string) {
    return academicRepository.findPaymentsByUserId(userId);
  }

  async getAnnouncements() {
    return academicRepository.findAllAnnouncements();
  }

  async postAnnouncement(input: CreateAnnouncementInput) {
    const announcement = await academicRepository.createAnnouncement(input.judul, input.isiTeks);
    await proactiveQueue.add('PROCESS_ANNOUNCEMENT', {
      announcementId: announcement.id,
    });
    return announcement;
  }
}

export const academicService = new AcademicService();
