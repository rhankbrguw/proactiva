import { Role, User } from '@prisma/client';
import { prisma } from '../lib/prisma.js';

export class UserRepository {
  async findByNim(nim: string): Promise<User | null> {
    return prisma.user.findUnique({
      where: { nim },
    });
  }

  async findById(id: string): Promise<User | null> {
    return prisma.user.findUnique({
      where: { id },
    });
  }

  async findStudents(): Promise<User[]> {
    return prisma.user.findMany({
      where: { role: Role.MAHASISWA },
    });
  }

  async updateFcmToken(id: string, fcmToken: string): Promise<User> {
    return prisma.user.update({
      where: { id },
      data: { fcmToken },
    });
  }
}

export const userRepository = new UserRepository();
