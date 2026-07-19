import { useState } from 'react';
import { useRouter } from 'expo-router'; // Asumiendo que usas expo-router
import { LoginUserUseCase } from '../../domain/use-cases/LoginUser';
import { AuthApiRepository } from '../../infraestructure/api/AuthApiRepository';

export const useAuth = () => {
  const [userName, setUserName] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);
  
  const router = useRouter();

  const handleLogin = async () => {
    setErrorMsg(null);
    setIsLoading(true);

    try {
      // Inyección manual de dependencias
      const repository = new AuthApiRepository();
      const loginUseCase = new LoginUserUseCase(repository);

      // Ejecutamos el caso de uso
      await loginUseCase.execute({ userName, userPassword: password });
      
      // Si llegamos aquí, el token se guardó y la API respondió 200.
      // Redirigimos al panel de productos
      router.replace('/products'); // Cambia la ruta según tu configuración de expo-router

    } catch (error: any) {
      setErrorMsg(error.message || 'Credenciales inválidas.');
    } finally {
      setIsLoading(false);
    }
  };

  return {
    userName,
    setUserName,
    password,
    setPassword,
    isLoading,
    errorMsg,
    handleLogin
  };
};