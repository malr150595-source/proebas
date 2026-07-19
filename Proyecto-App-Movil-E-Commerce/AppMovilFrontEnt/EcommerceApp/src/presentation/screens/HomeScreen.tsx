import React from 'react';
import { View, Text, Image, ScrollView, TouchableOpacity, Dimensions } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';

const { width } = Dimensions.get('window');

// Datos de prueba simulados basados en tu diseño
const PRODUCTS = [
  {
    id: '1',
    category: 'ROPA',
    title: 'Chaqueta de Cuero Premium',
    description: 'Corte moderno con acabados estilizados de alta costura.',
    price: '$189.99',
    image: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3', 
  },
  {
    id: '2',
    category: 'CALZADO',
    title: 'Zapatillas Running Deportivas',
    description: 'Amortiguación superior y ligereza para tus entrenamientos diarios.',
    price: '$129.99',
    image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3', 
  }
];

export const HomeScreen = () => {
  return (
    // Agregamos un View contenedor con estilo plano para que NativeWind pinte el fondo correctamente
    <View className="flex-1 bg-[#0b1221]">
      <SafeAreaView className="flex-1" edges={['top', 'left', 'right']}>
        
        {/* Círculos decorativos de fondo abstractos similares a la imagen */}
        <View className="absolute top-[-50] right-[-50] w-64 h-64 rounded-full bg-[#1e295d]/30 -z-10" />
        <View className="absolute bottom-[200] left-[-100] w-72 h-72 rounded-full bg-[#114b5f]/20 -z-10" />

        {/* CONTENIDO PRINCIPAL SCROLLABLE */}
        <ScrollView showsVerticalScrollIndicator={false} className="flex-1 px-5">
          
          {/* Cabecera del Ecommerce */}
          <View className="flex-row items-center mt-6 mb-1">
            <View className="bg-[#2CB1F6]/10 p-2 rounded-xl mr-3 flex-row space-x-1 items-center">
              <Ionicons name="bag-handle" size={28} color="#4ADE80" />
            </View>
            <Text className="text-white text-3xl font-extrabold tracking-wide">Ecommerce</Text>
          </View>
          <Text className="text-[#8ba0b2] text-base font-medium mb-6">
            Colección exclusiva inspirada en tus gustos
          </Text>

          {/* LISTADO DE PRODUCTOS */}
          <View className="space-y-6 pb-32">
            {PRODUCTS.map((product) => (
              <View 
                key={product.id} 
                className="w-full bg-[#162032]/90 border border-[#233045] rounded-[32px] overflow-hidden shadow-2xl mb-6"
              >
                {/* Imagen del Producto */}
                <View className="h-64 w-full relative bg-black/10">
                  <Image 
                    source={{ uri: product.image }} 
                    resizeMode="cover" // CORRECCIÓN: Se pasa como prop nativa, no en el className
                    className="w-full h-full"
                  />
                </View>

                {/* Detalles del Producto */}
                <View className="p-6">
                  <Text className="text-[#2CB1F6] text-xs font-bold tracking-widest uppercase mb-1">
                    {product.category}
                  </Text>
                  <Text className="text-white text-2xl font-bold mb-2">
                    {product.title}
                  </Text>
                  <Text className="text-[#8ba0b2] text-sm leading-relaxed mb-6">
                    {product.description}
                  </Text>

                  {/* Fila Inferior: Precio y Botón */}
                  <View className="flex-row justify-between items-center">
                    <Text className="text-white text-3xl font-extrabold">
                      {product.price}
                    </Text>
                    
                    <TouchableOpacity 
                      activeOpacity={0.8}
                      className="bg-[#2a374e] border border-[#3b4c68] px-7 py-3 rounded-2xl"
                    >
                      <Text className="text-white font-bold text-base">Añadir</Text>
                    </TouchableOpacity>
                  </View>
                </View>
              </View>
            ))}
          </View>

        </ScrollView>

        {/* BOTÓN FLOTANTE DEL BOT / ASISTENTE */}
        <TouchableOpacity 
          activeOpacity={0.8}
          className="absolute bottom-24 right-6 bg-[#2CB1F6] w-14 h-14 rounded-full justify-center items-center shadow-lg shadow-[#2CB1F6]/50 z-50"
        >
          <Ionicons name="hardware-chip" size={26} color="#0b1221" />
        </TouchableOpacity>

        {/* TABS DE NAVEGACIÓN INFERIOR (Simuladas en el componente por ahora) */}
        <View className="absolute bottom-0 left-0 right-0 h-20 bg-[#0e1726] border-t border-[#1d293e] flex-row justify-around items-center px-4 z-50">
          
          <TouchableOpacity className="items-center justify-center">
            <Ionicons name="shirt-outline" size={24} color="#2CB1F6" />
            <Text className="text-[#2CB1F6] text-xs mt-1 font-medium">Inicio</Text>
          </TouchableOpacity>

          <TouchableOpacity className="items-center justify-center">
            <Ionicons name="cart-outline" size={24} color="#586e85" />
            <Text className="text-[#586e85] text-xs mt-1 font-medium">Carrito</Text>
          </TouchableOpacity>

          <TouchableOpacity className="items-center justify-center">
            <Ionicons name="cube-outline" size={24} color="#586e85" />
            <Text className="text-[#586e85] text-xs mt-1 font-medium">Compras</Text>
          </TouchableOpacity>

          <TouchableOpacity className="items-center justify-center">
            <Ionicons name="person-outline" size={24} color="#586e85" />
            <Text className="text-[#586e85] text-xs mt-1 font-medium">Perfil</Text>
          </TouchableOpacity>

        </View>

      </SafeAreaView>
    </View>
  );
};