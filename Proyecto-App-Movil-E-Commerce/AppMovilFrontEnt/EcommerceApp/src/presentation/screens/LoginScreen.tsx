// @ts-nocheck
import React from 'react';
import { View, Text, TextInput, TouchableOpacity, ActivityIndicator, Image } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useAuth } from '../hooks/useAuth';

export const LoginScreen = () => {
  const {
    userName,
    setUserName,
    password,
    setPassword,
    isLoading,
    errorMsg,
    handleLogin
  } = useAuth();

  return (
    <SafeAreaView className="flex-1 bg-gray-900 justify-center px-6">
      <View className="items-center mb-10">
        {/* Placeholder para tu Logo */}
        <View className="w-24 h-24 bg-gray-800 rounded-full items-center justify-center mb-4 border border-gray-700">
           <Text className="text-blue-500 font-bold text-3xl">E-C</Text>
        </View>
        <Text className="text-white text-3xl font-extrabold tracking-tight">Bienvenido</Text>
        <Text className="text-gray-400 mt-2 text-sm">Inicia sesión en tu cuenta para continuar</Text>
      </View>

      <View className="w-full">
        {/* Input Usuario */}
        <View className="mb-4">
          <Text className="text-gray-300 font-medium mb-2 ml-1">Usuario o Correo</Text>
          <TextInput
            className="w-full bg-gray-800 text-white px-4 py-4 rounded-xl border border-gray-700 focus:border-blue-500"
            placeholder="Ej. Eduardo o eduardo@mail.com"
            placeholderTextColor="#9ca3af"
            value={userName}
            onChangeText={setUserName}
            autoCapitalize="none"
            editable={!isLoading}
          />
        </View>

        {/* Input Contraseña */}
        <View className="mb-6">
          <Text className="text-gray-300 font-medium mb-2 ml-1">Contraseña</Text>
          <TextInput
            className="w-full bg-gray-800 text-white px-4 py-4 rounded-xl border border-gray-700 focus:border-blue-500"
            placeholder="********"
            placeholderTextColor="#9ca3af"
            secureTextEntry
            value={password}
            onChangeText={setPassword}
            editable={!isLoading}
          />
        </View>

        {/* Mensaje de Error */}
        {errorMsg && (
          <Text className="text-red-400 text-center mb-4 font-medium">
            {errorMsg}
          </Text>
        )}

        {/* Botón Principal Azul */}
        <TouchableOpacity
          className={`w-full py-4 rounded-xl items-center flex-row justify-center ${isLoading ? 'bg-blue-800' : 'bg-blue-600'}`}
          onPress={handleLogin}
          disabled={isLoading}
          activeOpacity={0.8}
        >
          {isLoading ? (
            <ActivityIndicator color="#ffffff" size="small" className="mr-2" />
          ) : null}
          <Text className="text-white font-bold text-lg">
            {isLoading ? 'Verificando...' : 'Iniciar Sesión'}
          </Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};