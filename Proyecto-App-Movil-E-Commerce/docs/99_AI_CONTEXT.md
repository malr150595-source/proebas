# 99_AI_CONTEXT

**Versión:** 1.0  
**Estado:** Activo  
**Última actualización:** 2026-07-18

---

# Objetivo

Este documento está dirigido exclusivamente a asistentes de Inteligencia Artificial (ChatGPT, Claude, Gemini, Copilot, Cursor, Windsurf u otros).

Su propósito es proporcionar el contexto suficiente para comprender el proyecto antes de generar código o proponer cambios.

Este documento complementa la documentación técnica ubicada en la carpeta `docs`.

---

# Antes de generar código

Toda IA deberá seguir este orden obligatorio:

1. Leer `00_PROJECT_CONTEXT.md`
2. Leer `01_BACKEND_ARCHITECTURE.md`
3. Leer `07_DEVELOPMENT_RULES.md`
4. Leer este documento (`99_AI_CONTEXT.md`)
5. Leer cualquier documento específico del módulo que vaya a modificar (por ejemplo `03_API_REFERENCE.md` o `05_FRONTEND_PLAN.md`).

No generar código sin haber revisado la documentación correspondiente.

---

# Descripción del Proyecto

Proyecto de aplicación móvil de comercio electrónico desarrollado con una arquitectura desacoplada.

La solución está dividida en dos partes principales:

- Backend (ASP.NET Core / C#)
- Frontend (React Native + Expo + TypeScript)

El Backend es la fuente de verdad del sistema.

El Frontend debe adaptarse al Backend, nunca al contrario.

---

# Arquitectura del Repositorio

```text
Proyecto-App-Movil-E-Commerce/

├── BackEnd/
│
├── AppMovilFrontEnt/
│
├── Diseño/
│
├── docs/
│
└── Chatbot/
```

---

# Backend

El Backend utiliza una arquitectura por capas.

```text
Presentation

↓

Application

↓

Infrastructure

↓

Domain
```

## Presentation

Contiene:

- Controllers
- Program.cs
- Configuración
- Swagger
- JWT
- Scalar

## Application

Contiene:

- DTOs
- Interfaces
- Services

## Infrastructure

Contiene:

- Repositories
- Db
- Implementaciones de acceso a datos

## Domain

Contiene las entidades del negocio.

---

# Frontend

El Frontend está desarrollado con:

- React Native
- Expo
- TypeScript
- Expo Router

Su arquitectura seguirá el mismo principio de separación de responsabilidades que el Backend.

---

# Fuente de Verdad

La prioridad de la información es:

1. Código del Backend
2. Documentación en `docs`
3. Diseños aprobados
4. Código del Frontend

Si existe una contradicción entre el Frontend y el Backend, prevalece el Backend.

---

# Principios del Proyecto

Toda propuesta debe respetar:

- Arquitectura existente.
- Tipado fuerte.
- Componentes reutilizables.
- Separación de responsabilidades.
- Código limpio.
- Escalabilidad.

No modificar la arquitectura sin documentar la decisión.

---

# Reglas para generar código

Antes de escribir código, verificar:

- ¿Existe el endpoint?
- ¿Existe el DTO?
- ¿Existe el permiso requerido?
- ¿Existe un componente reutilizable?
- ¿Existe una regla documentada que ya resuelva el problema?

Si alguna respuesta es "No", detenerse y documentar la situación antes de implementar.

---

# Qué está prohibido

No inventar:

- Endpoints.
- DTOs.
- Campos de respuesta.
- Roles.
- Permisos.
- Relaciones de base de datos.
- Lógica de negocio.

Toda información debe provenir del código o de la documentación.

---

# Flujo de Desarrollo

Todo cambio deberá seguir este orden:

1. Analizar.
2. Documentar.
3. Diseñar.
4. Implementar.
5. Validar.
6. Actualizar la documentación.

Nunca implementar primero y documentar después.

---

# Estructura esperada del Frontend

```text
src/

app/
domain/
infrastructure/
presentation/
services/
hooks/
theme/
types/
utils/
store/
assets/
```

Esta estructura podrá evolucionar únicamente si existe una decisión documentada.

---

# Uso de las imágenes de Diseño

Las imágenes ubicadas en la carpeta `Diseño/` son una referencia visual.

No representan necesariamente el comportamiento funcional.

Antes de implementar una pantalla:

1. Analizar el diseño.
2. Identificar los componentes reutilizables.
3. Verificar los datos disponibles en la API.
4. Adaptar el diseño al comportamiento real del Backend.

---

# Objetivo Principal

Construir un Frontend profesional, escalable y mantenible que respete completamente la arquitectura y la lógica del Backend.

Toda decisión técnica debe priorizar la consistencia del sistema sobre la velocidad de implementación.