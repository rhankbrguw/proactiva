import { FastifyReply, FastifyRequest } from 'fastify';
import { authService } from '../services/auth.service.js';
import { loginInputSchema, validateSchema } from '../schemas/auth.schema.js';
import { buildSuccessResponse } from '../utils/response.js';
import { STRINGS } from '../constants/strings.js';

export class AuthController {
  async login(request: FastifyRequest, reply: FastifyReply) {
    const input = validateSchema(loginInputSchema, request.body);
    const user = await authService.authenticateUser(input);

    const token = (request.server as any).jwt.sign({
      id: user.id,
      nim: user.nim,
      nama: user.nama,
      role: user.role,
    });

    const responseData = { user, token };
    return reply.send(buildSuccessResponse(responseData, STRINGS.AUTH.LOGIN_SUCCESS));
  }

  async getMe(request: FastifyRequest, reply: FastifyReply) {
    const userPayload = (request as any).user;
    const profile = await authService.getCurrentUserProfile(userPayload.id);
    return reply.send(buildSuccessResponse(profile));
  }
}

export const authController = new AuthController();
