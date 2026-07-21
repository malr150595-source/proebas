import React, { useState } from 'react';
import { View, Text, Image, ScrollView, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router'; // 1. Importamos el router
import { BottomTabNavigator } from '../components/BottomTabNavigator';
import { ChatbotButton } from '../components/ChatbotButton';

// Datos de prueba configurados para que el cálculo inicial coincida con la imagen
const INITIAL_CART = [
  {
    id: '1',
    title: 'Chaqueta de Cuero Premium',
    price: 189.99,
    quantity: 1,
    image: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500&auto=format&fit=crop&q=60',
  },
  {
    id: '2',
    title: 'Zapatillas Running Deportivas',
    price: 125.50,
    quantity: 1,
    image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop&q=60',
  }
];

export const CartScreen = () => {
  const [cartItems, setCartItems] = useState(INITIAL_CART);
  const router = useRouter(); // 2. Inicializamos el router

  // Funciones para modificar la cantidad
  const updateQuantity = (id: string, delta: number) => {
    setCartItems((prevItems) => 
      prevItems.map(item => {
        if (item.id === id) {
          const newQuantity = Math.max(1, item.quantity + delta); // Mínimo 1
          return { ...item, quantity: newQuantity };
        }
        return item;
      })
    );
  };

  const removeItem = (id: string) => {
    setCartItems(prevItems => prevItems.filter(item => item.id !== id));
  };

  // Cálculos dinámicos
  const subtotal = cartItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  const discount = 25.00; // Descuento fijo según la imagen
  const taxableAmount = Math.max(0, subtotal - discount);
  const tax = taxableAmount * 0.15; // Asumiendo un 15% de IVA
  const total = taxableAmount + tax;

  return (
    <SafeAreaView className="flex-1 bg-[#0b1221]" edges={['top', 'left', 'right']}>
      
      {/* Cabecera */}
      <View className="px-5 pt-4 pb-4 border-b border-[#1d293e]">
        <Text className="text-white text-3xl font-extrabold tracking-wide">
          🛒 Tu Carrito
        </Text>
        <Text className="text-[#8ba0b2] text-sm mt-1">
          Resumen de artículos listos para facturar
        </Text>
      </View>

      <ScrollView showsVerticalScrollIndicator={false} className="flex-1 px-5 pt-4">
        
       {/* LISTA DE PRODUCTOS EN EL CARRITO */}
        <View className="space-y-4 mb-8">
          {cartItems.map((item) => (
            <View key={item.id} className="bg-[#162032] border border-[#233045] rounded-2xl p-4 shadow-lg relative">
              
              {/* Contenedor Fila para Imagen y Detalles */}
              <View className="flex-row items-center">
                
                {/* Imagen del Producto */}
                <Image 
                  source={{ uri: item.image }} 
                  className="w-20 h-20 rounded-xl bg-[#0b1221]"
                  resizeMode="cover"
                />
                
                {/* Detalles del Producto */}
                <View className="flex-1 ml-4">
                  {/* pr-8 evita que el título choque con el basurero */}
                  <Text className="text-white font-bold text-base pr-8" numberOfLines={1}>
                    {item.title}
                  </Text>
                  <Text className="text-[#8ba0b2] text-xs mt-1">
                    Precio unitario: ${item.price.toFixed(2)}
                  </Text>

                  {/* Controles de Cantidad y Subtotal del Ítem */}
                  <View className="flex-row justify-between items-end mt-3">
                    <Text className="text-[#2CB1F6] font-bold text-lg">
                      ${(item.price * item.quantity).toFixed(2)}
                    </Text>
                    
                    <View className="flex-row items-center bg-[#0b1221] rounded-lg border border-[#233045]">
                      <TouchableOpacity 
                        onPress={() => updateQuantity(item.id, -1)}
                        className="py-1.5 px-3"
                      >
                        <Ionicons name="remove" size={16} color="#8ba0b2" />
                      </TouchableOpacity>
                      <Text className="text-white font-bold px-2">{item.quantity}</Text>
                      <TouchableOpacity 
                        onPress={() => updateQuantity(item.id, 1)}
                        className="py-1.5 px-3"
                      >
                        <Ionicons name="add" size={16} color="#8ba0b2" />
                      </TouchableOpacity>
                    </View>
                  </View>
                </View>
              </View>

              {/* Botón Eliminar - Reposicionado */}
              <TouchableOpacity 
                className="absolute top-4 right-4 z-10"
                onPress={() => removeItem(item.id)}
              >
                <Ionicons name="trash-outline" size={20} color="#ef4444" />
              </TouchableOpacity>
            </View>
          ))}
        </View>

        {/* TARJETA DE RESUMEN DE ORDEN (Basada en la imagen) */}
        <View className="relative mb-28">
          {/* Círculo decorativo púrpura de fondo simulando el efecto de la imagen */}
          <View className="absolute top-10 right-0 w-48 h-48 bg-[#6b21a8]/40 rounded-full blur-3xl" />
          
          <View className="bg-[#162032]/95 border border-[#233045] rounded-3xl p-6 overflow-hidden">
            <Text className="text-white text-xl font-bold mb-6">Resumen de Orden</Text>

            {/* Subtotal */}
            <View className="flex-row justify-between mb-4">
              <Text className="text-[#8ba0b2] text-base">Subtotal</Text>
              <Text className="text-white text-base font-semibold">${subtotal.toFixed(2)}</Text>
            </View>

            {/* Descuento */}
            <View className="flex-row justify-between mb-4">
              <Text className="text-[#8ba0b2] text-base">Descuento</Text>
              <Text className="text-[#4ADE80] text-base font-semibold">-${discount.toFixed(2)}</Text>
            </View>

            {/* Impuesto */}
            <View className="flex-row justify-between mb-6">
              <Text className="text-[#8ba0b2] text-base">Impuesto (IVA/TAX)</Text>
              <Text className="text-white text-base font-semibold">${tax.toFixed(2)}</Text>
            </View>

            {/* Divisor */}
            <View className="h-[1px] bg-[#233045] mb-6" />

            {/* Total Final */}
            <View className="flex-row justify-between items-center mb-8">
              <Text className="text-white text-lg font-bold">Total Final</Text>
              <Text className="text-[#2CB1F6] text-3xl font-extrabold">${total.toFixed(2)}</Text>
            </View>

            {/* Botón de Pago */}
            <TouchableOpacity 
              activeOpacity={0.8}
              onPress={() => router.push('/checkout')} // 3. Agregamos la navegación aquí
              className="w-full bg-[#3B82F6] py-4 rounded-2xl items-center shadow-lg shadow-blue-500/30"
            >
              <Text className="text-white text-lg font-bold tracking-wide">
                Proceder al Pago
              </Text>
            </TouchableOpacity>
          </View>
        </View>

      </ScrollView>
      

      {/* BOTON DEL CHATBOT */}
      <ChatbotButton/>

      {/* TABS DE NAVEGACIÓN INFERIOR */}
      <BottomTabNavigator />

    </SafeAreaView>
  );
};

export default CartScreen;