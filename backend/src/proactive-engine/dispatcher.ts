import { NotificationStatus } from '@prisma/client';
import { prisma } from '../lib/prisma.js';
import { ProactiveNotificationPayload } from './types.js';
import { NUMBERS } from '../constants/numbers.js';

export async function dispatchProactiveNotification(payload: ProactiveNotificationPayload) {
  // Idempotency check: Don't send the exact same notification type for the same event within 24 hours
  if (payload.eventId) {
    const existing = await prisma.notification.findFirst({
      where: {
        userId: payload.userId,
        eventId: payload.eventId,
        tipe: payload.tipe,
        createdAt: {
          gte: new Date(Date.now() - NUMBERS.IDEMPOTENCY_HOURS * 60 * 60 * 1000),
        },
      },
    });

    if (existing) {
      return existing;
    }
  }

  // Persist notification
  return prisma.notification.create({
    data: {
      userId: payload.userId,
      eventId: payload.eventId,
      tipe: payload.tipe,
      prioritas: payload.prioritas,
      source: payload.source,
      judul: payload.judul,
      pesan: payload.pesan,
      payload: payload.payload ?? {},
      status: NotificationStatus.SENT,
      sentAt: new Date(),
    },
  });
}
