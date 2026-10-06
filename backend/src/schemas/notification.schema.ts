import { z } from 'zod';
import { NotificationPriority, NotificationSource } from '@prisma/client';

export const registerFcmTokenSchema = z.object({
  fcmToken: z.string().min(10, 'FCM Token tidak valid'),
});

export const queryNotificationsSchema = z.object({
  source: z.nativeEnum(NotificationSource).optional(),
  prioritas: z.nativeEnum(NotificationPriority).optional(),
  tipe: z.string().optional(),
});

export type RegisterFcmTokenInput = z.infer<typeof registerFcmTokenSchema>;
export type QueryNotificationsInput = z.infer<typeof queryNotificationsSchema>;
