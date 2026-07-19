import { AuthResponse, LoginData } from '../../domain/entities/Auth';
import { AuthRepository } from '../../domain/repositories/AuthRepository';
import { ecommerceApi } from './ecommerceApi';
import * as SecureStore from 'expo-secure-store';

export class AuthApiRepository implements AuthRepository {
  
  async login(data: LoginData): Promise<AuthResponse> {
    try {
      // Llamamos a tu endpoint exacto
      const response = await ecommerceApi.post('/Auth/login', data);
      
      const token = response.data.token;
      
      // Guardamos el token en el dispositivo
      if (token) {
        await SecureStore.setItemAsync('jwt_token', token);
      }

      return { token };
    } catch (error: any) {
      // Manejo de errores que vienen desde tu C# (ej. 401 Credenciales inválidas)
      const errorMsg = error.response?.data?.control?.messaje || 'Error al conectar con el servidor';
      throw new Error(errorMsg);
    }
  }

  async logout(): Promise<void> {
    await SecureStore.deleteItemAsync('jwt_token');
  }
}