import React, { useState } from 'react';
import { View, Text, KeyboardAvoidingView, Platform, Alert } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context'; 
import { Ionicons } from '@expo/vector-icons';
import { Link, useRouter } from 'expo-router'; 
import { CustomInput } from '../components/CustomInput';
import { PrimaryButton } from '../components/PrimaryButton';

export const LoginScreen = () => {
  const router = useRouter(); 
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const handleLogin = async () => {
    if (!username || !password) {
      Alert.alert('Datos incompletos', 'Por favor ingresa tu usuario y contraseña.');
      return;
    }

    setIsLoading(true);
    try {
      // Simulación de espera de red (1.5 segundos)
      await new Promise(resolve => setTimeout(resolve, 1500)); 

      // CREDENCIALES DE PRUEBA (Simulación local)
      const USER_TEST = "admin@test.com";
      const PASS_TEST = "Admin123!";

      // CORRECCIÓN: Limpieza rigurosa de espacios y conversión a minúsculas
      const cleanUsername = username.trim().toLowerCase();
      const cleanPassword = password.trim();

      if (cleanUsername === USER_TEST && cleanPassword === PASS_TEST) {
        console.log('Login simulado con éxito');
        
        // CORRECCIÓN: Ruta exacta sin paréntesis vinculada a tu products.tsx
        router.replace('/home'); 
      } else {
        // Mensaje de error detallado por si hay fallas en la escritura
        Alert.alert(
          'Credenciales incorrectas', 
          'Para la prueba usa exactamente:\nUsuario: admin@test.com\nContraseña: Admin123!'
        );
      }

    } catch (error: any) {
      Alert.alert('Error', error.message || 'Error al iniciar sesión');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <SafeAreaView className="flex-1 bg-[#0b1221]">
      <KeyboardAvoidingView 
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        className="flex-1 justify-center items-center px-6"
      >
        <View className="w-full bg-[#162032]/80 border border-[#233045] rounded-3xl p-8 py-12">
          
          {/* Cabecera / Logo */}
          <View className="items-center mb-10">
            <View className="mb-4">
              <Ionicons name="shield-checkmark-outline" size={48} color="#2CB1F6" />
            </View>
            <Text className="text-white text-3xl font-bold mb-2">Ecommerce</Text>
            <Text className="text-[#8ba0b2] text-sm text-center">
              Ingresa al Sistema de Comercio Seguro
            </Text>
          </View>

          {/* Formulario usando Componentes Reutilizables */}
          <View>
            <CustomInput
              iconName="person-outline"
              placeholder="Nombre de usuario o correo"
              value={username}
              onChangeText={setUsername}
              autoCapitalize="none"
              editable={!isLoading}
            />

            <CustomInput
              iconName="lock-closed-outline"
              placeholder="Contraseña"
              value={password}
              onChangeText={setPassword}
              isPassword={true}
              showPassword={showPassword}
              onTogglePassword={() => setShowPassword(!showPassword)}
              editable={!isLoading}
            />

            <View className="mt-4">
              <PrimaryButton
                title="Iniciar Sesión"
                iconName="arrow-forward"
                onPress={handleLogin}
                isLoading={isLoading}
              />
            </View>
            
            {/* Enlace para ir al Registro */}
            <View className="mt-8 flex-row justify-center">
              <Text className="text-[#8ba0b2]">¿No tienes cuenta? </Text>
              <Link href="/register" className="text-[#2CB1F6] font-bold">
                Regístrate aquí
              </Link>
            </View>
            
          </View>

        </View>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
};