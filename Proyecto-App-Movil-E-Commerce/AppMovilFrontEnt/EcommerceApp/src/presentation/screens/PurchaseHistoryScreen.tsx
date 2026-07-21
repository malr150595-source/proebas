import React from 'react';
import { View, Text, TouchableOpacity, ScrollView } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { BottomTabNavigator } from '../components/BottomTabNavigator'; // Importamos el componente de navegación
import { ChatbotButton } from '../components/ChatbotButton';

export const PurchaseHistoryScreen = () => {
  return (
    <SafeAreaView className="flex-1 bg-[#090D16]">
      {/* Contenido Principal Centrado */}
      <View className="flex-1 justify-center items-center px-6">
        {/* Icono Principal de Caja/Despacho */}
        <View className="mb-4">
          <Ionicons name="cube-outline" size={80} color="#38BDF8" />
        </View>

        {/* Título */}
        <Text className="text-white text-3xl font-bold tracking-wide text-center">
          Mis Compras
        </Text>

        {/* Subtítulo */}
        <Text className="text-slate-400 text-base mt-2 text-center font-normal">
          Historial de órdenes y despachos.
        </Text>
      </View>

      {/* BOTON DEL CHATBOT */}
      <ChatbotButton/>

      {/* TABS DE NAVEGACIÓN INFERIOR COMPONENTIZADAS */}
      <BottomTabNavigator />
      
    </SafeAreaView>
  );
};

export default PurchaseHistoryScreen;