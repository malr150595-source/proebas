import React from 'react';
import { View, TextInput, TouchableOpacity, TextInputProps } from 'react-native';
import { Ionicons } from '@expo/vector-icons';

interface CustomInputProps extends TextInputProps {
  iconName: keyof typeof Ionicons.glyphMap;
  isPassword?: boolean;
  showPassword?: boolean;
  onTogglePassword?: () => void;
}

export const CustomInput = ({ 
  iconName, 
  isPassword = false, 
  showPassword = false, 
  onTogglePassword, 
  ...props 
}: CustomInputProps) => {
  return (
    <View className="flex-row items-center bg-[#1a2639] border border-[#2a3a50] rounded-xl px-4 h-14 mb-4">
      <Ionicons name={iconName} size={20} color="#8ba0b2" />
      <TextInput
        className="flex-1 text-white ml-3"
        placeholderTextColor="#8ba0b2"
        secureTextEntry={isPassword && !showPassword}
        {...props}
      />
      {isPassword && (
        <TouchableOpacity onPress={onTogglePassword} disabled={props.editable === false}>
          <Ionicons 
            name={showPassword ? "eye-off-outline" : "eye-outline"} 
            size={20} 
            color="#8ba0b2" 
          />
        </TouchableOpacity>
      )}
    </View>
  );
};