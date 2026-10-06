import { FastifyInstance } from 'fastify';
import { authController } from '../controllers/auth.controller.js';
import { API_ROUTES } from '../constants/routes.js';

export async function authRoutes(app: FastifyInstance) {
  app.post(API_ROUTES.AUTH.LOGIN, (req, rep) => authController.login(req, rep));
  app.get(
    API_ROUTES.AUTH.ME,
    { preHandler: [(app as any).authenticate] },
    (req, rep) => authController.getMe(req, rep)
  );
}
