// @ts-nocheck
import React, { useState } from 'react';
import { View, Text, FlatList, TouchableOpacity } from 'react-native';
import { SafeAreaView} from 'react-native'
import { ProductCard } from '../components/ProductCard';
import { Product } from '../../domain/entities/Product';

// Datos estáticos (Mock) para validar el diseño antes de conectar con el Use Case / API
const MOCK_PRODUCTS: Product[] = [
  { id: 1, name: 'Zapatillas Deportivas', description: 'Talla 42', price: 1200.50, categoryName: 'Calzado', statusId: 1 },
  { id: 2, name: 'Auriculares Inalámbricos', description: 'Bluetooth 5.0', price: 850.00, categoryName: 'Electrónica', statusId: 1 },
  { id: 3, name: 'Camiseta de Algodón', description: 'Talla M, Color Azul', price: 350.00, categoryName: 'Ropa', statusId: 1 },
];

export const ProductsPanelScreen = () => {
  const [products, setProducts] = useState<Product[]>(MOCK_PRODUCTS);

  const handleEdit = (product: Product) => {
    console.log('Editar producto:', product.id);
    // Aquí invocaremos al router para ir al formulario de edición
  };

  const handleDelete = (id: number) => {
    console.log('Eliminar producto:', id);
    // Aquí conectaremos el caso de uso de eliminación
  };

  const handleAddProduct = () => {
    console.log('Navegar a crear producto');
  };

  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      {/* Header del Panel */}
      <View className="px-5 py-4 bg-white shadow-sm flex-row justify-between items-center z-10">
        <Text className="text-2xl font-extrabold text-gray-800">Panel de Productos</Text>
      </View>

      {/* Lista de Productos */}
      <FlatList
        data={products}
        keyExtractor={(item) => item.id.toString()}
        renderItem={({ item }) => (
          <ProductCard 
            product={item} 
            onEdit={handleEdit} 
            onDelete={handleDelete} 
          />
        )}
        contentContainerStyle={{ padding: 20, paddingBottom: 100 }}
        showsVerticalScrollIndicator={false}
      />

      {/* Botón Flotante para Agregar Producto (FAB) */}
      <TouchableOpacity 
        className="absolute bottom-6 right-6 w-14 h-14 bg-indigo-600 rounded-full items-center justify-center shadow-lg elevation-5"
        onPress={handleAddProduct}
        activeOpacity={0.8}
      >
        <Text className="text-white text-3xl font-light mb-1">+</Text>
      </TouchableOpacity>
    </SafeAreaView>
  );
};