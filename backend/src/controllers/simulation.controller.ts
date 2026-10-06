import { FastifyReply, FastifyRequest } from 'fastify';
import { simulationService } from '../services/simulation.service.js';
import { buildSuccessResponse } from '../utils/response.js';
import { STRINGS } from '../constants/strings.js';

export class SimulationController {
  async runCycle(_request: FastifyRequest, reply: FastifyReply) {
    const results = await simulationService.triggerGlobalCycle();
    return reply.send(buildSuccessResponse(results, STRINGS.SIMULATION.CYCLE_SUCCESS));
  }

  async triggerCollision(_request: FastifyRequest, reply: FastifyReply) {
    const results = await simulationService.triggerDeadlineCollision();
    return reply.send(buildSuccessResponse(results, STRINGS.SIMULATION.COLLISION_TRIGGERED));
  }

  async triggerAttendanceRisk(_request: FastifyRequest, reply: FastifyReply) {
    const results = await simulationService.triggerAttendanceRisk();
    return reply.send(buildSuccessResponse(results, STRINGS.SIMULATION.ATTENDANCE_TRIGGERED));
  }

  async triggerUrgentPayment(_request: FastifyRequest, reply: FastifyReply) {
    const results = await simulationService.triggerUrgentPayment();
    return reply.send(buildSuccessResponse(results, STRINGS.SIMULATION.PAYMENT_TRIGGERED));
  }
}

export const simulationController = new SimulationController();
