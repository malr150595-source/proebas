// @ts-nocheck
import React from 'react';
import { View, Text, Image, TouchableOpacity } from 'react-native';
import { Product } from '../../domain/entities/Product';

interface ProductCardProps {
  product: Product;
  onEdit?: (product: Product) => void;
  onDelete?: (id: number) => void;
}

export const ProductCard = ({ product, onEdit, onDelete }: ProductCardProps) => {
  return (
    <View className="bg-white p-4 mb-4 rounded-xl shadow-sm border border-gray-100 flex-row items-center">
      {/* Imagen del Producto (Placeholder) */}
      <View className="w-20 h-20 bg-gray-200 rounded-lg mr-4">
        {product.imagenUrl ? (
          <Image 
            source={{ uri: product.imagenUrl }} 
            className="w-full h-full rounded-lg" 
            resizeMode="cover" 
          />
        ) : (
          <View className="flex-1 items-center justify-center">
            <Text className="text-gray-400 text-xs">Sin foto</Text>
          </View>
        )}
      </View>

      {/* Información del Producto */}
      <View className="flex-1">
        <Text className="text-sm text-gray-500 font-medium">{product.categoryName}</Text>
        <Text className="text-lg font-bold text-gray-900" numberOfLines={1}>
          {product.name}
        </Text>
        <Text className="text-green-600 font-bold text-base mt-1">
          C$ {product.price.toFixed(2)}
        </Text>
      </View>

      {/* Acciones del Panel */}
      <View className="flex-col justify-between h-full ml-2">
        <TouchableOpacity 
          className="bg-blue-500 px-3 py-2 rounded-md mb-2"
          onPress={() => onEdit && onEdit(product)}
        >
          <Text className="text-white text-xs font-bold text-center">Editar</Text>
        </TouchableOpacity>
        <TouchableOpacity 
          className="bg-red-500 px-3 py-2 rounded-md"
          onPress={() => onDelete && onDelete(product.id)}
        >
          <Text className="text-white text-xs font-bold text-center">Borrar</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};