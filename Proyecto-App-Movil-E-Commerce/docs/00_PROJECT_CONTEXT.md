# 00_PROJECT_CONTEXT

> Documento maestro del proyecto.
>
> Este archivo sirve como referencia principal para cualquier desarrollador o IA que participe en el proyecto.
>
> Ninguna decisión técnica debe contradecir la información documentada aquí.

---

# 1. Información General

## Nombre del proyecto

Proyecto App Móvil E-Commerce

## Estado

En desarrollo.

Actualmente el Backend se encuentra implementado y funcional.

El Frontend será desarrollado utilizando la arquitectura existente del proyecto.

---

# 2. Objetivo

Construir una aplicación móvil de comercio electrónico utilizando React Native + Expo que consuma la API desarrollada en ASP.NET Core.

El Frontend debe respetar completamente la lógica del Backend.

No se modificarán contratos de la API para adaptarlos al Frontend.

Siempre será el Frontend quien se adapte al Backend.

---

# 3. Tecnologías

## Backend

- ASP.NET Core
- C#
- Arquitectura por capas
- DTOs
- Repositories
- JWT (pendiente de documentar)
- Base de datos (pendiente de documentar)

## Frontend

- React Native
- Expo
- TypeScript
- Expo Router

---

# 4. Arquitectura del Repositorio

Proyecto-App-Movil-E-Commerce/

BackEnd/

AppMovilFrontEnt/

docs/

---

# 5. Arquitectura General

Actualmente el proyecto mantiene una separación entre Backend y Frontend.

El Frontend consume la API mediante una capa de Infrastructure.

La lógica del negocio permanece en Domain.

La interfaz se implementa dentro de Presentation.

La arquitectura seguirá el principio de separación de responsabilidades.

---

# 6. Objetivos del Desarrollo

Durante el desarrollo se seguirá el siguiente orden:

1. Documentación del proyecto.
2. Auditoría del Backend.
3. Documentación de la API.
4. Documentación de autenticación.
5. Documentación de Base de Datos.
6. Planificación del Frontend.
7. Desarrollo del Frontend.
8. Optimización.
9. Pruebas.

No se alterará este orden salvo decisión explícita.

---

# 7. Fuente de Verdad

La única fuente de verdad será:

1. Código del Backend.
2. Base de datos.
3. Documentación generada en la carpeta docs.
4. Diseños aprobados del Frontend.

Nunca se asumirán comportamientos que no existan en el código.

---

# 8. Convenciones

Todo nuevo desarrollo deberá cumplir:

- TypeScript.
- Componentes reutilizables.
- Código limpio.
- Responsabilidad única.
- Tipado fuerte.
- Sin duplicación de lógica.
- Mantener la arquitectura existente.

---

# 9. Estado Actual

## Backend

Pendiente de auditoría.

## API

Pendiente de documentación.

## Base de datos

Pendiente de documentación.

## Autenticación

Pendiente de documentación.

## Frontend

En desarrollo.

---

# 10. Documentación

Este documento pertenece a una serie de documentación técnica.

Los siguientes documentos serán creados progresivamente:

01_BACKEND_ARCHITECTURE.md

02_DATABASE.md

03_API_REFERENCE.md

04_AUTHENTICATION.md

05_FRONTEND_PLAN.md

06_UI_REFERENCE.md

07_DEVELOPMENT_RULES.md

08_PROGRESS.md

09_TODO.md

---

# 11. Regla Principal del Proyecto

Antes de implementar cualquier funcionalidad nueva:

1. Revisar la documentación existente.
2. Confirmar el comportamiento en el Backend.
3. Actualizar la documentación si es necesario.
4. Implementar la funcionalidad.
5. Registrar el avance en la documentación correspondiente.

La documentación siempre tendrá prioridad sobre las implementaciones nuevas.
