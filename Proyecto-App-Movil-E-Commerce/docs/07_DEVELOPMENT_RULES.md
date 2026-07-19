# 07_DEVELOPMENT_RULES

**Versión:** 1.0  
**Estado:** Aprobado  
**Última actualización:** 2026-07-18

---

# Objetivo

Este documento define las reglas oficiales para el desarrollo del proyecto **Proyecto App Móvil E-Commerce**.

Todo desarrollo futuro deberá respetar estas reglas para mantener una arquitectura consistente, escalable y fácil de mantener.

---

# 1. Fuente de Verdad

La única fuente de verdad del sistema será el Backend.

El Frontend nunca deberá asumir comportamientos que no existan en la API.

Si existe una diferencia entre el diseño y el Backend, prevalece el Backend.

---

# 2. Arquitectura

Se mantendrá la arquitectura actual del proyecto.

Backend

Presentation

↓

Application

↓

Infrastructure

↓

Domain

Frontend

Presentation

↓

Infrastructure

↓

Domain

Toda nueva funcionalidad deberá respetar esta separación.

---

# 3. Desarrollo del Frontend

Antes de crear una pantalla se deberá:

1. Revisar el endpoint correspondiente.
2. Revisar el DTO utilizado.
3. Revisar el flujo de negocio.
4. Confirmar los permisos necesarios.
5. Confirmar el diseño aprobado.

Solo entonces podrá comenzar el desarrollo.

---

# 4. Consumo de API

Toda comunicación con el Backend deberá realizarse desde la capa Infrastructure.

Está prohibido realizar llamadas HTTP directamente desde:

- Screens
- Components
- Hooks

---

# 5. Servicios

Cada módulo tendrá un servicio independiente.

Ejemplo:

services/

AuthService

ProductService

CartService

OrderService

UserService

Nunca mezclar responsabilidades.

---

# 6. Tipado

Todo dato recibido desde la API deberá tener un tipo TypeScript.

Está prohibido utilizar:

- any
- object
- datos sin tipar

Los tipos deberán representar exactamente los DTOs del Backend.

---

# 7. Componentes

Los componentes deberán ser reutilizables.

Un componente no debe contener lógica de negocio.

Los componentes solamente renderizan información.

---

# 8. Pantallas

Las pantallas coordinan el flujo de la interfaz.

No contienen lógica de acceso a datos.

No realizan llamadas HTTP.

---

# 9. Hooks

Los Hooks encapsulan comportamiento reutilizable.

Ejemplos:

- autenticación
- paginación
- búsqueda
- almacenamiento local

---

# 10. Estado Global

Toda información compartida deberá centralizarse.

Ejemplos:

- Usuario autenticado
- Token JWT
- Carrito
- Tema
- Configuración

---

# 11. Manejo de Errores

Todos los errores deberán manejarse de forma centralizada.

Nunca mostrar errores técnicos al usuario.

Siempre registrar errores en consola durante desarrollo.

---

# 12. Navegación

Toda navegación estará centralizada.

No crear rutas duplicadas.

No utilizar navegación manual fuera del sistema definido.

---

# 13. Estilos

Los estilos deberán ser reutilizables.

No utilizar colores escritos directamente dentro de componentes.

Todos los colores vivirán en:

theme/

---

# 14. Recursos

Las imágenes deberán almacenarse en:

assets/

Nunca utilizar rutas absolutas.

---

# 15. Backend

Está prohibido modificar el Backend para adaptarlo al Frontend.

Si una funcionalidad requiere cambios en la API:

1. Documentar la necesidad.
2. Evaluar el impacto.
3. Aprobar el cambio.

---

# 16. Documentación

Toda modificación importante deberá reflejarse en la carpeta docs.

La documentación forma parte del proyecto.

---

# 17. Flujo de Trabajo

El desarrollo seguirá siempre el siguiente orden:

1. Analizar Backend.
2. Analizar Diseño.
3. Documentar.
4. Implementar.
5. Probar.
6. Documentar cambios.

Nunca comenzar implementando directamente.

---

# 18. Convenciones de Nombres

Componentes:

PascalCase

Ejemplo:

ProductCard.tsx

Hooks:

camelCase iniciando con use

Ejemplo:

useAuth.ts

Servicios:

PascalCase

Ejemplo:

ProductService.ts

Interfaces:

Prefijo I

Ejemplo:

IProduct.ts

---

# 19. Calidad

Todo nuevo código deberá cumplir:

- Responsabilidad única.
- Código legible.
- Sin duplicación.
- Tipado fuerte.
- Fácil de probar.
- Fácil de mantener.

---

# 20. Reglas para trabajar con IA

Antes de generar código, la IA deberá:

1. Revisar la documentación de la carpeta docs.
2. Confirmar el comportamiento en el Backend.
3. No inventar endpoints.
4. No inventar DTOs.
5. No modificar la arquitectura.
6. Respetar las decisiones documentadas.
7. Explicar cambios estructurales antes de implementarlos.

Estas reglas aplican a cualquier asistente de IA utilizado en el proyecto.

---

# Conclusión

El objetivo de estas reglas no es limitar el desarrollo, sino garantizar que el proyecto mantenga una arquitectura consistente y que el Frontend evolucione de forma alineada con el Backend y la documentación oficial.