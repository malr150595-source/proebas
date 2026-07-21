import React, { useState } from 'react';
import { View, Text, Image, ScrollView, TouchableOpacity, TextInput } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { BottomTabNavigator } from '../components/BottomTabNavigator';
import { ChatbotButton } from '../components/ChatbotButton';

// Datos de prueba extendidos para ver bien la cuadrícula
const PRODUCTS = [
  { id: '1', category: 'Ropa', title: 'Chaqueta de Cuero', price: '$189.99', image: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500&auto=format&fit=crop&q=60' },
  { id: '2', category: 'Calzado', title: 'Zapatillas Running', price: '$129.99', image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop&q=60' },
  { id: '3', category: 'Accesorios', title: 'Reloj Minimalista', price: '$89.50', image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=60' },
  { id: '4', category: 'Accesorios', title: 'Gafas de Sol Clásicas', price: '$45.00', image: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500&auto=format&fit=crop&q=60' },
  { id: '5', category: 'Ropa', title: 'Camiseta Básica', price: '$19.99', image: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&auto=format&fit=crop&q=60' },
  { id: '6', category: 'Calzado', title: 'Botas Urbanas', price: '$150.00', image: 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=500&auto=format&fit=crop&q=60' },
];

const CATEGORIES = ['Todos', 'Ropa', 'Calzado', 'Accesorios'];

export const ProductsPanelScreen = () => {
  const [activeCategory, setActiveCategory] = useState('Todos');
  const [searchQuery, setSearchQuery] = useState('');

  // Lógica de filtrado
  const filteredProducts = PRODUCTS.filter(product => {
    const matchesCategory = activeCategory === 'Todos' || product.category === activeCategory;
    const matchesSearch = product.title.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesCategory && matchesSearch;
  });

  return (
    <SafeAreaView className="flex-1 bg-[#0b1221]" edges={['top', 'left', 'right']}>
      
      {/* Cabecera del Catálogo */}
      <View className="px-5 pt-4 pb-2">
        <Text className="text-white text-3xl font-extrabold tracking-wide">Catálogo</Text>
        <Text className="text-[#8ba0b2] text-sm mt-1">Encuentra todo lo que necesitas</Text>
      </View>

      {/* Barra de Búsqueda */}
      <View className="px-5 my-4">
        <View className="flex-row items-center bg-[#162032] border border-[#233045] rounded-2xl px-4 py-3">
          <Ionicons name="search" size={20} color="#8ba0b2" />
          <TextInput 
            className="flex-1 ml-3 text-white text-base"
            placeholder="Buscar productos..."
            placeholderTextColor="#8ba0b2"
            value={searchQuery}
            onChangeText={setSearchQuery}
          />
          {searchQuery.length > 0 && (
            <TouchableOpacity onPress={() => setSearchQuery('')}>
              <Ionicons name="close-circle" size={20} color="#8ba0b2" />
            </TouchableOpacity>
          )}
        </View>
      </View>

      {/* Filtros de Categorías (Scroll Horizontal) */}
      <View className="pl-5 mb-6">
        <ScrollView horizontal showsHorizontalScrollIndicator={false}>
          {CATEGORIES.map((category) => (
            <TouchableOpacity 
              key={category}
              onPress={() => setActiveCategory(category)}
              className={`mr-3 px-5 py-2 rounded-full border ${
                activeCategory === category 
                  ? 'bg-[#2CB1F6] border-[#2CB1F6]' 
                  : 'bg-[#162032] border-[#233045]'
              }`}
            >
              <Text className={`font-semibold ${
                activeCategory === category ? 'text-[#0b1221]' : 'text-[#8ba0b2]'
              }`}>
                {category}
              </Text>
            </TouchableOpacity>
          ))}
        </ScrollView>
      </View>

      {/* Grid de Productos (2 columnas) */}
      <ScrollView showsVerticalScrollIndicator={false} className="flex-1 px-5">
        <View className="flex-row flex-wrap justify-between pb-24">
          {filteredProducts.map((product) => (
            <TouchableOpacity 
              key={product.id} 
              activeOpacity={0.9}
              className="w-[48%] bg-[#162032] border border-[#233045] rounded-2xl overflow-hidden mb-4"
            >
              {/* Imagen pequeña del producto */}
              <View className="h-40 w-full bg-black/10">
                <Image 
                  source={{ uri: product.image }} 
                  resizeMode="cover"
                  className="w-full h-full"
                />
              </View>

              {/* Detalles (Título y Precio) */}
              <View className="p-3">
                <Text className="text-[#2CB1F6] text-[10px] font-bold uppercase mb-1">
                  {product.category}
                </Text>
                <Text className="text-white text-sm font-bold mb-2" numberOfLines={2}>
                  {product.title}
                </Text>
                <View className="flex-row justify-between items-center mt-1">
                  <Text className="text-white text-base font-extrabold">
                    {product.price}
                  </Text>
                  <View className="bg-[#2CB1F6]/20 p-1.5 rounded-lg">
                    <Ionicons name="add" size={16} color="#2CB1F6" />
                  </View>
                </View>
              </View>
            </TouchableOpacity>
          ))}
          
          {/* Mensaje de estado vacío si la búsqueda no coincide */}
          {filteredProducts.length === 0 && (
            <View className="flex-1 items-center justify-center py-10 w-full">
              <Ionicons name="search-outline" size={48} color="#233045" />
              <Text className="text-[#8ba0b2] mt-4 text-center">No se encontraron productos para tu búsqueda.</Text>
            </View>
          )}
        </View>
      </ScrollView>

      {/* BOTON DEL CHATBOT */}
      <ChatbotButton/>

      {/* TABS DE NAVEGACIÓN INFERIOR COMPONENTIZADAS */}
      <BottomTabNavigator />

    </SafeAreaView>
  );
};

export default ProductsPanelScreen;