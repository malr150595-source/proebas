import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useRouter, usePathname } from 'expo-router';

// Se añadió 'Catálogo' y se actualizaron los íconos de Inicio
const NAV_ITEMS = [
  {
    name: 'Inicio',
    route: '/home', // Ruta apuntando a HomeScreen
    activeIcon: 'home',
    inactiveIcon: 'home-outline',
  },
  {
    name: 'Catálogo',
    route: '/products', // Ruta apuntando a ProductsPanelScreen
    activeIcon: 'grid',
    inactiveIcon: 'grid-outline',
  },
  {
    name: 'Carrito',
    route: '/cart',
    activeIcon: 'cart',
    inactiveIcon: 'cart-outline',
  },
  {
    name: 'Compras',
    route: '/orders',
    activeIcon: 'cube',
    inactiveIcon: 'cube-outline',
  },
  {
    name: 'Perfil',
    route: '/profile',
    activeIcon: 'person',
    inactiveIcon: 'person-outline',
  },
];

export const BottomTabNavigator = () => {
  const router = useRouter();
  const pathname = usePathname();

  return (
    <View className="flex-row justify-between items-center bg-[#0F172A] py-3 px-2 border-t border-slate-800/80">
      {NAV_ITEMS.map((item) => {
        const isActive = pathname === item.route;

        return (
          <TouchableOpacity
            key={item.route}
            onPress={() => router.push(item.route as any)}
            className="items-center flex-1"
            activeOpacity={0.7}
          >
            <Ionicons
              name={(isActive ? item.activeIcon : item.inactiveIcon) as any}
              size={22} // Reducimos un poco el tamaño para que quepan 5 botones cómodamente
              color={isActive ? '#38BDF8' : '#64748B'}
            />
            <Text
              className={`text-[10px] mt-1 ${
                isActive ? 'text-[#38BDF8] font-semibold' : 'text-slate-500'
              }`}
            >
              {item.name}
            </Text>
          </TouchableOpacity>
        );
      })}
    </View>
  );
};

export default BottomTabNavigator;