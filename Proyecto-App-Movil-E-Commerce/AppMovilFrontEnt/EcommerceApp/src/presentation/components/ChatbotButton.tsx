import React from 'react';
import { TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';

export const ChatbotButton = () => {
  const router = useRouter();

  return (
    <TouchableOpacity 
      activeOpacity={0.8}
      onPress={() => router.push('/chat')}
      className="absolute bottom-20 right-5 bg-[#38BDF8] w-14 h-14 rounded-full justify-center items-center shadow-lg shadow-sky-500/50 z-50"
    >
      <Ionicons name="hardware-chip-outline" size={26} color="#090D16" />
    </TouchableOpacity>
  );
};