import { AuthResponse, LoginData } from '../entities/Auth';

export interface AuthRepository {
  login(data: LoginData): Promise<AuthResponse>;
  logout(): Promise<void>;
}