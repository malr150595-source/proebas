import React, { useState } from 'react';
import { View, Text, KeyboardAvoidingView, Platform, Alert, ScrollView } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context'; 
import { Ionicons } from '@expo/vector-icons';
import { Link, useRouter } from 'expo-router';
import { CustomInput } from '../components/CustomInput';
import { PrimaryButton } from '../components/PrimaryButton';

export const RegisterScreen = () => {
  const router = useRouter();
  
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  // Estados de validación en tiempo real para la contraseña
  const hasMinLength = password.length >= 8 && password.length <= 32;
  const hasUpperCase = /[A-Z]/.test(password);
  const hasLowerCase = /[a-z]/.test(password);
  const hasNumberAndSpecial = /\d/.test(password) && /[@$!%*?&.]/.test(password);

  const isPasswordValid = hasMinLength && hasUpperCase && hasLowerCase && hasNumberAndSpecial;

  const handleRegister = async () => {
    if (!name || !email || !password || !confirmPassword) {
      Alert.alert('Datos incompletos', 'Por favor llena todos los campos.');
      return;
    }

    // Doble verificación al enviar, usando los estados en tiempo real
    if (!isPasswordValid) {
      Alert.alert("Contraseña inválida", "Asegúrate de que la contraseña cumpla con todos los requisitos en verde.");
      return;
    }

    if (password !== confirmPassword) {
      Alert.alert('Error', 'Las contraseñas no coinciden.');
      return;
    }

    setIsLoading(true);
    try {
      await new Promise(resolve => setTimeout(resolve, 1500)); 
      Alert.alert('¡Éxito!', 'Cuenta creada correctamente.');
      router.replace('/'); 
    } catch (error: any) {
      Alert.alert('Error', error.message || 'Error al registrar');
    } finally {
      setIsLoading(false);
    }
  };

  // Componente de ayuda para renderizar cada requisito de la contraseña
  const RequirementItem = ({ text, isValid }: { text: string; isValid: boolean }) => (
    <View className="flex-row items-center space-x-2 mt-1">
      <Ionicons 
        name={isValid ? "checkmark-circle" : "close-circle"} 
        size={16} 
        color={isValid ? "#4ADE80" : "#F87171"} 
      />
      <Text style={{ color: isValid ? '#4ADE80' : '#9ca3af' }} className="text-xs">
        {text}
      </Text>
    </View>
  );

  return (
    <SafeAreaView className="flex-1 bg-[#0b1221]">
      <KeyboardAvoidingView 
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        className="flex-1 justify-center px-6"
      >
        <ScrollView 
          showsVerticalScrollIndicator={false} 
          contentContainerStyle={{ flexGrow: 1, justifyContent: 'center', paddingVertical: 20 }}
        >
          <View className="w-full bg-[#162032]/80 border border-[#233045] rounded-3xl p-8 py-10">
            
            <View className="items-center mb-8">
              <View className="mb-4">
                <Ionicons name="person-add-outline" size={48} color="#2CB1F6" />
              </View>
              <Text className="text-white text-3xl font-bold mb-2">Crear Cuenta</Text>
              <Text className="text-[#8ba0b2] text-sm text-center">
                Únete a nuestro Ecommerce Seguro
              </Text>
            </View>

            <View>
              <CustomInput
                iconName="person-outline"
                placeholder="Nombre completo"
                value={name}
                onChangeText={(text) => {
                  const filteredText = text.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ ]/g, '');
                  setName(filteredText);
                }}
                autoCapitalize="words"
                editable={!isLoading}
              />

              <CustomInput
                iconName="mail-outline"
                placeholder="Correo electrónico"
                value={email}
                onChangeText={setEmail}
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

              {/* Indicadores visuales en tiempo real para la contraseña */}
              {password.length > 0 && (
                <View className="bg-[#0b1221]/50 border border-[#233045] p-3 rounded-xl mb-4 space-y-1">
                  <Text className="text-white text-xs font-semibold mb-1">Requisitos de contraseña:</Text>
                  <RequirementItem text="Entre 8 y 32 caracteres" isValid={hasMinLength} />
                  <RequirementItem text="Al menos una letra mayúscula" isValid={hasUpperCase} />
                  <RequirementItem text="Al menos una letra minúscula" isValid={hasLowerCase} />
                  <RequirementItem text="Al menos un número y un carácter especial (@$!%*?&.)" isValid={hasNumberAndSpecial} />
                </View>
              )}

              <CustomInput
                iconName="shield-checkmark-outline"
                placeholder="Confirmar contraseña"
                value={confirmPassword}
                onChangeText={setConfirmPassword}
                isPassword={true}
                showPassword={showConfirmPassword}
                onTogglePassword={() => setShowConfirmPassword(!showConfirmPassword)}
                editable={!isLoading}
              />

              <View className="mt-4">
                <PrimaryButton
                  title="Registrarse"
                  iconName="checkmark-circle-outline"
                  onPress={handleRegister}
                  isLoading={isLoading}
                />
              </View>
              
              <View className="mt-8 flex-row justify-center">
                <Text className="text-[#8ba0b2]">¿Ya tienes una cuenta? </Text>
                <Link href="/" className="text-[#2CB1F6] font-bold">
                  Inicia sesión
                </Link>
              </View>
              
            </View>
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
};