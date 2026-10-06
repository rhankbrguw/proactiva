import { FastifyInstance } from 'fastify';
import { notificationController } from '../controllers/notification.controller.js';
import { API_ROUTES } from '../constants/routes.js';

export async function notificationRoutes(app: FastifyInstance) {
  const authPreHandler = { preHandler: [(app as any).authenticate] };

  app.get(
    API_ROUTES.NOTIFICATIONS.LIST,
    authPreHandler,
    (req, rep) => notificationController.getNotifications(req, rep)
  );

  app.get(
    API_ROUTES.NOTIFICATIONS.STATS,
    authPreHandler,
    (req, rep) => notificationController.getStatistics(req, rep)
  );

  app.post(
    API_ROUTES.NOTIFICATIONS.FCM_TOKEN,
    authPreHandler,
    (req, rep) => notificationController.registerFcmToken(req, rep)
  );
}
