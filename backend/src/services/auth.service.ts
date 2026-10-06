import { userRepository } from '../repositories/user.repository.js';
import { AuthException, NotFoundException } from '../errors/app.exception.js';
import { STRINGS } from '../constants/strings.js';
import { LoginInput } from '../schemas/auth.schema.js';

export class AuthService {
  async authenticateUser(input: LoginInput) {
    const user = await userRepository.findByNim(input.nim);
    if (!user || user.password !== input.password) {
      throw new AuthException(STRINGS.AUTH.INVALID_CREDENTIALS);
    }

    return {
      id: user.id,
      nim: user.nim,
      nama: user.nama,
      role: user.role,
    };
  }

  async getCurrentUserProfile(userId: string) {
    const user = await userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException(STRINGS.AUTH.USER_NOT_FOUND);
    }

    return {
      id: user.id,
      nim: user.nim,
      nama: user.nama,
      role: user.role,
      createdAt: user.createdAt,
    };
  }
}

export const authService = new AuthService();
