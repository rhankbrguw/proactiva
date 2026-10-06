import { FastifyInstance } from 'fastify';
import { simulationController } from '../controllers/simulation.controller.js';
import { API_ROUTES } from '../constants/routes.js';

export async function simulationRoutes(app: FastifyInstance) {
  app.post(API_ROUTES.SIMULATION.RUN_CYCLE, (req, rep) => simulationController.runCycle(req, rep));
  app.post(API_ROUTES.SIMULATION.COLLISION, (req, rep) => simulationController.triggerCollision(req, rep));
  app.post(API_ROUTES.SIMULATION.ATTENDANCE_RISK, (req, rep) => simulationController.triggerAttendanceRisk(req, rep));
  app.post(API_ROUTES.SIMULATION.URGENT_PAYMENT, (req, rep) => simulationController.triggerUrgentPayment(req, rep));
}
