/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}", // <--- Esto asegura que lea toda la carpeta src
  ],
  // ESTA ES LA LÍNEA MÁGICA QUE FALTABA 👇
  presets: [require("nativewind/preset")],
  theme: {
    extend: {},
  },
  plugins: [],
}