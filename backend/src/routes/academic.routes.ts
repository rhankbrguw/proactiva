import { FastifyInstance } from 'fastify';
import { academicController } from '../controllers/academic.controller.js';
import { API_ROUTES } from '../constants/routes.js';

export async function academicRoutes(app: FastifyInstance) {
  const authPreHandler = { preHandler: [(app as any).authenticate] };

  app.get(API_ROUTES.ACADEMIC.COURSES, authPreHandler, (req, rep) => academicController.getCourses(req, rep));
  app.get(API_ROUTES.ACADEMIC.SCHEDULES, authPreHandler, (req, rep) => academicController.getSchedules(req, rep));
  app.get(API_ROUTES.ACADEMIC.ASSIGNMENTS, authPreHandler, (req, rep) => academicController.getAssignments(req, rep));
  app.get(API_ROUTES.ACADEMIC.ATTENDANCE, authPreHandler, (req, rep) => academicController.getAttendance(req, rep));
  app.get(API_ROUTES.ACADEMIC.PAYMENTS, authPreHandler, (req, rep) => academicController.getPayments(req, rep));
  app.get(API_ROUTES.ACADEMIC.ANNOUNCEMENTS, (req, rep) => academicController.getAnnouncements(req, rep));
  app.post(API_ROUTES.ACADEMIC.ANNOUNCEMENTS, (req, rep) => academicController.createAnnouncement(req, rep));
}
