import React, { useState } from 'react';
import { View, Text, Image, TouchableOpacity, ScrollView, TextInput, Switch } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { BottomTabNavigator } from '../components/BottomTabNavigator';
import { ChatbotButton } from '../components/ChatbotButton';

export const ProfileScreen = () => {
  // Estados para la edición del nombre y preferencias
  const [isEditingName, setIsEditingName] = useState(false);
  const [userName, setUserName] = useState('Eduardo');
  const [notificationsEnabled, setNotificationsEnabled] = useState(true);

  // Componente reutilizable para los botones del menú
  const MenuOption = ({ icon, title, color = "#8ba0b2", isDanger = false, value = null }: any) => (
    <TouchableOpacity 
      activeOpacity={0.7}
      className="flex-row items-center justify-between py-4 border-b border-[#233045]"
    >
      <View className="flex-row items-center">
        <Ionicons name={icon} size={22} color={isDanger ? '#ef4444' : color} />
        <Text className={`text-base ml-4 ${isDanger ? 'text-red-500 font-semibold' : 'text-white'}`}>
          {title}
        </Text>
      </View>
      {value !== null ? (
        <Text className="text-[#8ba0b2] text-sm">{value}</Text>
      ) : (
        <Ionicons name="chevron-forward" size={20} color="#64748B" />
      )}
    </TouchableOpacity>
  );

  return (
    <SafeAreaView className="flex-1 bg-[#0b1221]" edges={['top', 'left', 'right']}>
      
      {/* Círculo decorativo de fondo */}
      <View className="absolute top-[-100] self-center w-[500px] h-[500px] bg-[#11203b] rounded-full -z-10" />

      <ScrollView showsVerticalScrollIndicator={false} className="flex-1">
        
        {/* SECCIÓN DE CABECERA: Avatar y Nombre */}
        <View className="items-center mt-10 mb-8 px-5">
          {/* Imagen de Perfil Editable */}
          <TouchableOpacity activeOpacity={0.8} className="relative mb-4">
            <View className="w-32 h-32 rounded-full border-4 border-[#0b1221] bg-[#162032] items-center justify-center overflow-hidden">
              <Ionicons name="person" size={64} color="#38BDF8" />
            </View>
            <View className="absolute bottom-0 right-2 bg-[#38BDF8] w-10 h-10 rounded-full items-center justify-center border-4 border-[#0b1221]">
              <Ionicons name="camera" size={16} color="#0b1221" />
            </View>
          </TouchableOpacity>

          {/* Nombre de Usuario Editable */}
          {isEditingName ? (
            <View className="flex-row items-center bg-[#162032] border border-[#38BDF8] rounded-xl px-4 py-2 mt-2 w-3/4">
              <TextInput 
                className="flex-1 text-white text-xl font-bold text-center"
                value={userName}
                onChangeText={setUserName}
                autoFocus
              />
              <TouchableOpacity onPress={() => setIsEditingName(false)} className="ml-2">
                <Ionicons name="checkmark-circle" size={24} color="#4ADE80" />
              </TouchableOpacity>
            </View>
          ) : (
            <TouchableOpacity 
              activeOpacity={0.7} 
              onPress={() => setIsEditingName(true)}
              className="flex-row items-center mt-2"
            >
              <Text className="text-white text-3xl font-extrabold tracking-wide">{userName}</Text>
              <Ionicons name="pencil" size={18} color="#8ba0b2" style={{ marginLeft: 8 }} />
            </TouchableOpacity>
          )}
        </View>

        {/* SECCIÓN DE MENÚ DE CONFIGURACIÓN */}
        <View className="px-5 pb-28">
          
          <Text className="text-[#8ba0b2] text-sm font-bold uppercase tracking-widest mb-2 ml-1">
            Configuración de Cuenta
          </Text>
          <View className="bg-[#162032] rounded-3xl px-5 py-2 border border-[#233045] mb-6 shadow-lg">
            <MenuOption icon="mail-outline" title="Correo Electrónico" value="eduardo@mail.com" />
            <MenuOption icon="lock-closed-outline" title="Cambiar Contraseña" />
            <MenuOption icon="card-outline" title="Métodos de Pago" />
            <MenuOption icon="location-outline" title="Direcciones de Envío" />
          </View>

          <Text className="text-[#8ba0b2] text-sm font-bold uppercase tracking-widest mb-2 ml-1">
            Preferencias y Soporte
          </Text>
          <View className="bg-[#162032] rounded-3xl px-5 py-2 border border-[#233045] mb-6 shadow-lg">
            {/* Toggle de Notificaciones */}
            <View className="flex-row items-center justify-between py-4 border-b border-[#233045]">
              <View className="flex-row items-center">
                <Ionicons name="notifications-outline" size={22} color="#8ba0b2" />
                <Text className="text-white text-base ml-4">Notificaciones Push</Text>
              </View>
              <Switch 
                value={notificationsEnabled}
                onValueChange={setNotificationsEnabled}
                trackColor={{ false: '#334155', true: '#38BDF8' }}
                thumbColor={'#ffffff'}
              />
            </View>
            <MenuOption icon="help-buoy-outline" title="Centro de Ayuda / FAQ" />
          </View>

          <Text className="text-red-500/80 text-sm font-bold uppercase tracking-widest mb-2 ml-1">
            Zona de Peligro
          </Text>
          <View className="bg-[#162032] rounded-3xl px-5 py-2 border border-[#233045] mb-6 shadow-lg">
            <MenuOption icon="log-out-outline" title="Cerrar Sesión" isDanger={true} />
            <MenuOption icon="trash-outline" title="Eliminar Cuenta" isDanger={true} />
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

export default ProfileScreen;