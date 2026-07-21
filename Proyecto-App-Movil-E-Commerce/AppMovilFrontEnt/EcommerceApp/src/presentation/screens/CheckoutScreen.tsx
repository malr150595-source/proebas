import React, { useState } from 'react';
import { View, Text, TextInput, ScrollView, TouchableOpacity, KeyboardAvoidingView, Platform } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';

export const CheckoutScreen = () => {
  const router = useRouter();

  // Estados para el formulario (Simulación)
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [address, setAddress] = useState('');
  const [cardNumber, setCardNumber] = useState('');
  const [expiry, setExpiry] = useState('');
  const [cvc, setCvc] = useState('');

  // Total simulado proveniente del carrito
  const total = 334.06; 

  return (
    <SafeAreaView className="flex-1 bg-[#0b1221]" edges={['top', 'left', 'right']}>
      
      {/* Cabecera con Botón de Regresar */}
      <View className="px-5 pt-4 pb-4 border-b border-[#1d293e] flex-row items-center">
        <TouchableOpacity 
          onPress={() => router.back()}
          className="mr-4 bg-[#162032] p-2 rounded-xl border border-[#233045]"
        >
          <Ionicons name="chevron-back" size={24} color="#8ba0b2" />
        </TouchableOpacity>
        <View>
          <Text className="text-white text-2xl font-extrabold tracking-wide">Checkout</Text>
          <Text className="text-[#8ba0b2] text-xs mt-1">Completa tu orden segura</Text>
        </View>
      </View>

      <KeyboardAvoidingView 
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        className="flex-1"
      >
        <ScrollView showsVerticalScrollIndicator={false} className="flex-1 px-5 pt-6 pb-10">
          
          {/* SECCIÓN 1: Resumen Breve */}
          <View className="bg-[#162032] border border-[#233045] rounded-2xl p-4 mb-6 flex-row justify-between items-center shadow-lg">
            <View>
              <Text className="text-[#8ba0b2] text-sm mb-1">Total a Pagar</Text>
              <Text className="text-white text-2xl font-bold">${total.toFixed(2)}</Text>
            </View>
            <Ionicons name="cart" size={32} color="#38BDF8" />
          </View>

          {/* SECCIÓN 2: Datos Personales y Envío */}
          <Text className="text-white text-lg font-bold mb-4 flex-row items-center">
            <Ionicons name="person-circle-outline" size={20} color="#38BDF8" /> Información de Envío
          </Text>
          <View className="space-y-4 mb-8">
            <View className="bg-[#0b1221] border border-[#233045] rounded-xl px-4 py-1 flex-row items-center">
              <Ionicons name="person-outline" size={18} color="#8ba0b2" />
              <TextInput 
                className="flex-1 ml-3 text-white text-base py-3"
                placeholder="Nombre Completo"
                placeholderTextColor="#64748B"
                value={name}
                onChangeText={setName}
              />
            </View>
            <View className="bg-[#0b1221] border border-[#233045] rounded-xl px-4 py-1 flex-row items-center">
              <Ionicons name="mail-outline" size={18} color="#8ba0b2" />
              <TextInput 
                className="flex-1 ml-3 text-white text-base py-3"
                placeholder="Correo Electrónico"
                placeholderTextColor="#64748B"
                keyboardType="email-address"
                autoCapitalize="none"
                value={email}
                onChangeText={setEmail}
              />
            </View>
            <View className="bg-[#0b1221] border border-[#233045] rounded-xl px-4 py-1 flex-row items-center">
              <Ionicons name="location-outline" size={18} color="#8ba0b2" />
              <TextInput 
                className="flex-1 ml-3 text-white text-base py-3"
                placeholder="Dirección de Envío"
                placeholderTextColor="#64748B"
                value={address}
                onChangeText={setAddress}
              />
            </View>
          </View>

          {/* SECCIÓN 3: Método de Pago (Estilo Stripe) */}
          <View className="flex-row items-center justify-between mb-4">
            <Text className="text-white text-lg font-bold">
              <Ionicons name="card-outline" size={20} color="#4ADE80" /> Detalles de Pago
            </Text>
            <Ionicons name="lock-closed" size={16} color="#4ADE80" />
          </View>
          
          <View className="bg-[#162032] border border-[#233045] rounded-2xl p-4 mb-10 shadow-lg">
            {/* Número de Tarjeta */}
            <View className="bg-[#0b1221] border border-[#233045] rounded-xl px-4 py-1 flex-row items-center mb-4">
              <Ionicons name="card" size={18} color="#8ba0b2" />
              <TextInput 
                className="flex-1 ml-3 text-white text-base py-3 tracking-widest"
                placeholder="0000 0000 0000 0000"
                placeholderTextColor="#64748B"
                keyboardType="numeric"
                maxLength={19}
                value={cardNumber}
                onChangeText={setCardNumber}
              />
            </View>

            {/* Fila: Expiración y CVC */}
            <View className="flex-row space-x-4">
              <View className="flex-1 bg-[#0b1221] border border-[#233045] rounded-xl px-4 py-1 flex-row items-center mr-2">
                <Ionicons name="calendar-outline" size={18} color="#8ba0b2" />
                <TextInput 
                  className="flex-1 ml-3 text-white text-base py-3"
                  placeholder="MM/AA"
                  placeholderTextColor="#64748B"
                  keyboardType="numeric"
                  maxLength={5}
                  value={expiry}
                  onChangeText={setExpiry}
                />
              </View>
              <View className="flex-1 bg-[#0b1221] border border-[#233045] rounded-xl px-4 py-1 flex-row items-center ml-2">
                <Ionicons name="shield-checkmark-outline" size={18} color="#8ba0b2" />
                <TextInput 
                  className="flex-1 ml-3 text-white text-base py-3"
                  placeholder="CVC"
                  placeholderTextColor="#64748B"
                  keyboardType="numeric"
                  maxLength={4}
                  secureTextEntry
                  value={cvc}
                  onChangeText={setCvc}
                />
              </View>
            </View>
          </View>

          {/* Botón de Confirmación */}
          <TouchableOpacity 
            activeOpacity={0.8}
            className="w-full bg-[#4ADE80] py-4 rounded-2xl items-center shadow-lg shadow-green-500/30 mb-12"
          >
            <Text className="text-[#0b1221] text-lg font-extrabold tracking-wide flex-row items-center">
              <Ionicons name="lock-closed" size={18} color="#0b1221" /> Pagar ${total.toFixed(2)}
            </Text>
          </TouchableOpacity>

        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
};

export default CheckoutScreen;