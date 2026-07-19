import { LoginData, AuthResponse } from '../entities/Auth';
import { AuthRepository } from '../repositories/AuthRepository';

export class LoginUserUseCase {
  constructor(private authRepository: AuthRepository) {}

  async execute(data: LoginData): Promise<AuthResponse> {
    if (!data.userName || !data.userPassword) {
      throw new Error('El usuario y contraseña son obligatorios.');
    }
    return await this.authRepository.login(data);
  }
}