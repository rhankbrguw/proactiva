import { FastifyError, FastifyReply, FastifyRequest } from 'fastify';
import { AppException } from './app.exception.js';
import { ERROR_CODES } from '../constants/errors.js';
import { ApiErrorEnvelope } from '../utils/response.js';

export function handleGlobalError(
  error: FastifyError | AppException | Error,
  request: FastifyRequest,
  reply: FastifyReply
) {
  const timestamp = new Date().toISOString();

  if (error instanceof AppException) {
    const envelope: ApiErrorEnvelope = {
      success: false,
      code: error.code,
      message: error.message,
      errors: error.errors,
      meta: { timestamp },
    };
    return reply.status(error.statusCode).send(envelope);
  }

  request.log.error(error);

  const fallbackEnvelope: ApiErrorEnvelope = {
    success: false,
    code: ERROR_CODES.INTERNAL_ERROR,
    message: 'Terjadi kesalahan pada sistem server.',
    errors: null,
    meta: { timestamp },
  };

  return reply.status(500).send(fallbackEnvelope);
}
