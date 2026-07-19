// @ts-nocheck
import axios from 'axios';
import * as SecureStore from 'expo-secure-store';

export const ecommerceApi = axios.create({
  // Ajusta la IP según uses Emulador o Dispositivo Físico
  baseURL: 'http://10.0.2.2:5256/api', 
  headers: {
    'Content-Type': 'application/json',
  },
});

// INTERCEPTOR: Se ejecuta automáticamente ANTES de que la petición salga hacia .NET
ecommerceApi.interceptors.request.use(
  async (config) => {
    const token = await SecureStore.getItemAsync('jwt_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);