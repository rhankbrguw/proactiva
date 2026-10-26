import { FastifyReply, FastifyRequest } from 'fastify';
import { academicService } from '../services/academic.service.js';
import { createAnnouncementSchema } from '../schemas/academic.schema.js';
import { validateSchema } from '../schemas/auth.schema.js';
import { buildSuccessResponse } from '../utils/response.js';
import { STRINGS } from '../constants/strings.js';

export class AcademicController {
  async getCourses(request: FastifyRequest, reply: FastifyReply) {
    const userId = (request as any).user.id;
    const courses = await academicService.getStudentCourses(userId);
    return reply.send(buildSuccessResponse(courses));
  }

  async getSchedules(request: FastifyRequest, reply: FastifyReply) {
    const userId = (request as any).user.id;
    const schedules = await academicService.getStudentSchedules(userId);
    return reply.send(buildSuccessResponse(schedules));
  }

  async getAssignments(request: FastifyRequest, reply: FastifyReply) {
    const userId = (request as any).user.id;
    const assignments = await academicService.getStudentAssignments(userId);
    return reply.send(buildSuccessResponse(assignments));
  }

  async getAttendance(request: FastifyRequest, reply: FastifyReply) {
    const userId = (request as any).user.id;
    const attendance = await academicService.getStudentAttendanceSummary(userId);
    return reply.send(buildSuccessResponse(attendance));
  }

  async getPayments(request: FastifyRequest, reply: FastifyReply) {
    const userId = (request as any).user.id;
    const payments = await academicService.getStudentPayments(userId);
    return reply.send(buildSuccessResponse(payments));
  }

  async getAnnouncements(_request: FastifyRequest, reply: FastifyReply) {
    const announcements = await academicService.getAnnouncements();
    return reply.send(buildSuccessResponse(announcements));
  }

  async createAnnouncement(request: FastifyRequest, reply: FastifyReply) {
    const input = validateSchema(createAnnouncementSchema, request.body);
    const announcement = await academicService.postAnnouncement(input);
    return reply.status(201).send(buildSuccessResponse(announcement, STRINGS.ACADEMIC.ANNOUNCEMENT_CREATED));
  }
}

export const academicController = new AcademicController();
