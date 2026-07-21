import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, KeyboardAvoidingView, Platform, ScrollView } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';

// Mensaje inicial por defecto (como en la imagen)
const INITIAL_CHAT = [
  { 
    id: '1', 
    text: '¡Hola! Soy tu asistente de Ecommerce. 🤖 ¿En qué puedo ayudarte hoy?', 
    isBot: true 
  }
];

export const ChatbotScreen = () => {
  const router = useRouter();
  const [message, setMessage] = useState('');
  const [chat, setChat] = useState(INITIAL_CHAT);

  // Función para simular el envío de un mensaje
  const handleSend = () => {
    if (message.trim().length === 0) return;
    
    // Agregamos el mensaje del usuario al chat
    setChat([...chat, { id: Date.now().toString(), text: message, isBot: false }]);
    setMessage('');
    
    // Aquí a futuro conectarías con la API de tu Chatbot real
  };

  return (
    <SafeAreaView className="flex-1 bg-[#0b1221]" edges={['top', 'bottom']}>
      
      {/* Círculo decorativo de fondo (mitad izquierda) */}
      <View className="absolute top-[40%] left-[-100] w-[250px] h-[250px] bg-[#162740]/80 rounded-full -z-10" />

      {/* Cabecera (Header) */}
      <View className="px-5 py-4 border-b border-[#1d293e] flex-row justify-between items-center bg-[#0b1221]/90 z-10">
        <View className="flex-row items-center">
          <Ionicons name="chatbubble-ellipses-outline" size={24} color="#38BDF8" />
          <Text className="text-white text-xl font-bold ml-3 tracking-wide">
            Asistente Virtual
          </Text>
        </View>
        <TouchableOpacity onPress={() => router.back()} className="p-1">
          <Ionicons name="close" size={28} color="#ffffff" />
        </TouchableOpacity>
      </View>

      {/* Área de Mensajes */}
      <ScrollView 
        className="flex-1 px-5 pt-6" 
        showsVerticalScrollIndicator={false}
      >
        {chat.map((msg) => (
          <View 
            key={msg.id} 
            className={`mb-5 max-w-[85%] ${msg.isBot ? 'self-start' : 'self-end'}`}
          >
            <View 
              className={`p-4 rounded-2xl ${
                msg.isBot 
                  ? 'bg-[#162032] border border-[#233045] rounded-tl-sm shadow-sm' 
                  : 'bg-[#38BDF8] rounded-tr-sm shadow-md'
              }`}
            >
              <Text 
                className={`${
                  msg.isBot ? 'text-white' : 'text-[#0b1221] font-medium'
                } text-base leading-6`}
              >
                {msg.text}
              </Text>
            </View>
          </View>
        ))}
      </ScrollView>

      {/* Área de Input (Protegida por KeyboardAvoidingView) */}
      <KeyboardAvoidingView 
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        keyboardVerticalOffset={Platform.OS === 'ios' ? 10 : 0}
      >
        <View className="px-5 py-4 border-t border-[#1d293e] flex-row items-center bg-[#0b1221]">
          {/* Input de texto */}
          <View className="flex-1 bg-[#162032] border border-[#233045] rounded-full px-5 py-1 flex-row items-center h-14 shadow-inner">
            <TextInput
              className="flex-1 text-white text-base"
              placeholder="Escribe un mensaje..."
              placeholderTextColor="#64748B"
              value={message}
              onChangeText={setMessage}
              onSubmitEditing={handleSend}
            />
          </View>
          
          {/* Botón de Enviar */}
          <TouchableOpacity
            onPress={handleSend}
            activeOpacity={0.8}
            className="ml-3 w-14 h-14 bg-[#38BDF8] rounded-full justify-center items-center shadow-lg shadow-sky-500/30"
          >
            {/* Margen izquierdo al icono para centrarlo visualmente por la forma del avión */}
            <Ionicons name="send" size={20} color="#0b1221" style={{ marginLeft: 4 }} />
          </TouchableOpacity>
        </View>
      </KeyboardAvoidingView>
      
    </SafeAreaView>
  );
};

export default ChatbotScreen;