import React from 'react';
import { TouchableOpacity, Text, ActivityIndicator, TouchableOpacityProps } from 'react-native';
import { Ionicons } from '@expo/vector-icons';

interface PrimaryButtonProps extends TouchableOpacityProps {
  title: string;
  isLoading?: boolean;
  iconName?: keyof typeof Ionicons.glyphMap;
}

export const PrimaryButton = ({ title, isLoading, iconName, disabled, ...props }: PrimaryButtonProps) => {
  const isDisabled = disabled || isLoading;

  return (
    <TouchableOpacity 
      disabled={isDisabled}
      className={`flex-row items-center justify-center rounded-xl h-14 ${isDisabled ? 'bg-[#2CB1F6]/70' : 'bg-[#2CB1F6]'}`}
      {...props}
    >
      {isLoading ? (
        <ActivityIndicator color="#0b1221" />
      ) : (
        <>
          <Text className="text-[#0b1221] text-base font-bold mr-2">
            {title}
          </Text>
          {iconName && <Ionicons name={iconName} size={20} color="#0b1221" />}
        </>
      )}
    </TouchableOpacity>
  );
};