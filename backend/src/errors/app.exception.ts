import { ERROR_CODES, ErrorCode } from '../constants/errors.js';

export class AppException extends Error {
  public readonly statusCode: number;
  public readonly code: ErrorCode;
  public readonly errors: Record<string, string[]> | null;

  constructor(
    message: string,
    statusCode = 500,
    code: ErrorCode = ERROR_CODES.INTERNAL_ERROR,
    errors: Record<string, string[]> | null = null
  ) {
    super(message);
    this.name = this.constructor.name;
    this.statusCode = statusCode;
    this.code = code;
    this.errors = errors;
    Error.captureStackTrace(this, this.constructor);
  }
}

export class ValidationException extends AppException {
  constructor(message: string, errors: Record<string, string[]> | null = null) {
    super(message, 422, ERROR_CODES.VALIDATION_ERROR, errors);
  }
}

export class AuthException extends AppException {
  constructor(message: string) {
    super(message, 401, ERROR_CODES.UNAUTHENTICATED);
  }
}

export class ForbiddenException extends AppException {
  constructor(message: string) {
    super(message, 403, ERROR_CODES.UNAUTHORIZED);
  }
}

export class NotFoundException extends AppException {
  constructor(message: string) {
    super(message, 404, ERROR_CODES.NOT_FOUND);
  }
}

export class ConflictException extends AppException {
  constructor(message: string) {
    super(message, 409, ERROR_CODES.CONFLICT);
  }
}

export class InternalException extends AppException {
  constructor(message: string) {
    super(message, 500, ERROR_CODES.INTERNAL_ERROR);
  }
}
