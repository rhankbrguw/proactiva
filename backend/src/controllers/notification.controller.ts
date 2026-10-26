import { FastifyReply, FastifyRequest } from 'fastify';
import { notificationService } from '../services/notification.service.js';
import { queryNotificationsSchema, registerFcmTokenSchema } from '../schemas/notification.schema.js';
import { validateSchema } from '../schemas/auth.schema.js';
import { buildSuccessResponse } from '../utils/response.js';
import { STRINGS } from '../constants/strings.js';

export class NotificationController {
  async getNotifications(request: FastifyRequest, reply: FastifyReply) {
    const userId = (request as any).user.id;
    const filters = validateSchema(queryNotificationsSchema, request.query);
    const notifications = await notificationService.getStudentNotifications(userId, filters);
    return reply.send(buildSuccessResponse(notifications));
  }

  async getStatistics(request: FastifyRequest, reply: FastifyReply) {
    const userId = (request as any).user.id;
    const stats = await notificationService.getNotificationStatistics(userId);
    return reply.send(buildSuccessResponse(stats));
  }

  async registerFcmToken(request: FastifyRequest, reply: FastifyReply) {
    const userId = (request as any).user.id;
    const input = validateSchema(registerFcmTokenSchema, request.body);
    await notificationService.registerDeviceToken(userId, input.fcmToken);
    return reply.send(buildSuccessResponse({ registered: true }, STRINGS.NOTIFICATIONS.FCM_REGISTERED));
  }
}

export const notificationController = new NotificationController();
