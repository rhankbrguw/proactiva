import { Notification, NotificationPriority, NotificationSource, Prisma } from '@prisma/client';
import { prisma } from '../lib/prisma.js';
import { NUMBERS } from '../constants/numbers.js';

export class NotificationRepository {
  async findByUserId(
    userId: string,
    filters?: { source?: NotificationSource; prioritas?: NotificationPriority; tipe?: string }
  ): Promise<Notification[]> {
    const where: Prisma.NotificationWhereInput = { userId };
    if (filters?.source) where.source = filters.source;
    if (filters?.prioritas) where.prioritas = filters.prioritas;
    if (filters?.tipe) where.tipe = filters.tipe;

    return prisma.notification.findMany({
      where,
      orderBy: { createdAt: 'desc' },
      take: NUMBERS.MAX_NOTIFICATION_QUERY_LIMIT,
    });
  }

  async countByUserIdAndSource(userId: string, source: NotificationSource): Promise<number> {
    return prisma.notification.count({ where: { userId, source } });
  }

  async countByUserIdAndPriority(userId: string, prioritas: NotificationPriority): Promise<number> {
    return prisma.notification.count({ where: { userId, prioritas } });
  }

  async countTotalByUserId(userId: string): Promise<number> {
    return prisma.notification.count({ where: { userId } });
  }

  async findRecentByEventAndType(userId: string, eventId: string, tipe: string, sinceDate: Date) {
    return prisma.notification.findFirst({
      where: {
        userId,
        eventId,
        tipe,
        createdAt: { gte: sinceDate },
      },
    });
  }

  async create(data: Prisma.NotificationCreateInput): Promise<Notification> {
    return prisma.notification.create({ data });
  }
}

export const notificationRepository = new NotificationRepository();
