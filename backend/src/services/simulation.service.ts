import { AssignmentType, AttendanceStatus, PaymentStatus } from '@prisma/client';
import { prisma } from '../lib/prisma.js';
import { userRepository } from '../repositories/user.repository.js';
import { runGlobalProactiveCycle, runProactiveCycleForUser } from '../proactive-engine/evaluator.js';
import { NotFoundException } from '../errors/app.exception.js';
import { STRINGS } from '../constants/strings.js';

export class SimulationService {
  async triggerGlobalCycle() {
    return runGlobalProactiveCycle();
  }

  async triggerDeadlineCollision() {
    const student = (await userRepository.findStudents())[0];
    if (!student) throw new NotFoundException(STRINGS.AUTH.USER_NOT_FOUND);

    const courses = await prisma.course.findMany({ take: 3 });
    const now = new Date();

    await prisma.assignment.createMany({
      data: [
        {
          courseId: courses[0]?.id || '1',
          judul: '[SIMULASI] Tugas Besar Jaringan Syaraf Tiruan (CNN & PyTorch)',
          deskripsi: 'Latih model klasifikasi gambar dengan dataset CIFAR-10, capai akurasi minimum 85%.',
          deadline: new Date(now.getTime() + 24 * 60 * 60 * 1000),
          jenis: AssignmentType.TUGAS,
        },
        {
          courseId: courses[1]?.id || '2',
          judul: '[SIMULASI] Kuis Bab 5: Design Patterns & SOLID Principles',
          deskripsi: 'Kuis pilihan ganda 25 soal di LMS dengan timer 45 menit.',
          deadline: new Date(now.getTime() + 28 * 60 * 60 * 1000),
          jenis: AssignmentType.KUIS,
        },
        {
          courseId: courses[2]?.id || '3',
          judul: '[SIMULASI] Submission Source Code & Demo API Backend',
          deskripsi: 'Deploy REST API ke server cloud dan submit link repository GitHub.',
          deadline: new Date(now.getTime() + 32 * 60 * 60 * 1000),
          jenis: AssignmentType.TUGAS,
        },
      ],
    });

    return runProactiveCycleForUser(student.id);
  }

  async triggerAttendanceRisk() {
    const student = (await userRepository.findStudents())[0];
    if (!student) throw new NotFoundException(STRINGS.AUTH.USER_NOT_FOUND);

    const course = await prisma.course.findFirst();
    if (!course) throw new NotFoundException('Course not found');

    await prisma.attendance.create({
      data: {
        userId: student.id,
        courseId: course.id,
        status: AttendanceStatus.ABSEN,
        totalAbsenRunning: 3,
        tanggal: new Date(),
      },
    });

    return runProactiveCycleForUser(student.id);
  }

  async triggerUrgentPayment() {
    const student = (await userRepository.findStudents())[0];
    if (!student) throw new NotFoundException(STRINGS.AUTH.USER_NOT_FOUND);

    const tomorrow = new Date(Date.now() + 24 * 60 * 60 * 1000);
    await prisma.payment.create({
      data: {
        userId: student.id,
        jenis: 'Biaya Praktikum Laboratorium Komputer',
        nominal: 850000,
        jatuhTempo: tomorrow,
        status: PaymentStatus.BELUM_LUNAS,
      },
    });

    return runProactiveCycleForUser(student.id);
  }
}

export const simulationService = new SimulationService();
