# 01_BACKEND_ARCHITECTURE

**Versión:** 1.0  
**Estado:** Verificado  
**Última actualización:** 2026-07-18  
**Fuente:** Auditoría del código fuente del Backend

---

# Objetivo

Este documento describe la arquitectura del Backend del proyecto **Proyecto App Móvil E-Commerce**.

Toda la información documentada aquí proviene exclusivamente del código fuente y representa la arquitectura oficial del sistema.

---

# Arquitectura General

El Backend se encuentra desarrollado utilizando **ASP.NET Core (.NET 10)** siguiendo una arquitectura por capas (Layered Architecture) con separación clara de responsabilidades.

La solución está dividida en proyectos independientes.

```
BackEnd/

Application/

Domain/

Infrastructure/

Presentation (BackEnd Ecommerce App)
```

Cada proyecto tiene una responsabilidad específica.

---

# Estructura de la Solución

## Presentation (API)

Proyecto:

```
BackEnd Ecommerce App
```

Responsabilidades:

- Exponer la API REST.
- Configurar JWT.
- Configurar CORS.
- Configurar Swagger.
- Configurar Scalar.
- Registrar la inyección de dependencias.
- Configurar el pipeline HTTP.
- Exponer Controllers.

Archivos importantes:

- Program.cs
- appsettings.json
- Controllers/

---

## Application

Responsabilidad:

Contiene la lógica de aplicación del sistema.

Actualmente contiene:

```
Application/

DTOs/

Interface/

Services/
```

### DTOs

Contiene los objetos utilizados para la comunicación entre la API y el dominio.

### Interface

Define los contratos utilizados por la aplicación.

Principalmente:

- Repositories
- Servicios

### Services

Implementa la lógica de negocio de cada módulo.

---

## Domain

Responsabilidad:

Representa el núcleo del negocio.

Contiene exclusivamente entidades del dominio.

Entidades identificadas durante la auditoría:

- User
- UserAddress
- Product
- ProductVariable
- ProductVariableType
- ProductImage
- ProductIdentificator
- Category
- SubCategory
- Segment
- Provider
- Mark
- Cart
- CartDetail
- PaymentOrder
- PaymentOrderDetail
- PaymentMethodType
- UserPaymentMethod
- Stock
- StockMovement
- StockMovementDetail
- StockMovementType
- Role
- Permission
- UserRole
- RolePermissionMatrix
- Status

El proyecto Domain no contiene lógica relacionada con la infraestructura.

---

## Infrastructure

Responsabilidad:

Implementar el acceso a datos y los servicios de infraestructura.

Actualmente contiene:

```
Infrastructure/

Db/

Repository/
```

### Db

Contiene la conexión con la base de datos.

Durante la auditoría se confirmó el uso de:

- SQL Server
- DBConectionFactory

### Repository

Implementa todos los contratos definidos dentro de Application.

Cada repositorio encapsula el acceso a los datos.

---

# Patrón Arquitectónico

Durante la auditoría se confirmó el uso de los siguientes patrones.

## Layered Architecture

Separación por capas.

Presentation

↓

Application

↓

Infrastructure

↓

Database

---

## Repository Pattern

Cada módulo implementa un repositorio independiente.

Ejemplos:

- ProductsRepository
- CategoriesRepository
- UsersRepository
- RolesRepository
- StocksRepository

---

## Dependency Injection

Toda la aplicación utiliza la inyección de dependencias nativa de ASP.NET Core.

Los servicios son registrados desde Program.cs.

---

## Service Layer

La lógica de negocio se implementa mediante Services independientes.

Cada módulo posee su propio servicio.

---

## DTO Pattern

La comunicación entre API y Cliente se realiza mediante DTOs.

Las entidades del dominio no son expuestas directamente.

---

# Seguridad

La autenticación utiliza:

- JWT Bearer Authentication

Configuración identificada:

- SecretKey
- Issuer
- Audience
- Expiration

La configuración se obtiene desde:

```
appsettings.json
```

---

# Base de Datos

Motor identificado:

SQL Server

Cadena de conexión:

```
DB_ECOMMERCE
```

La conexión es administrada mediante:

```
DBConectionFactory
```

---

# Documentación de API

El proyecto incorpora dos herramientas oficiales.

## Swagger

Documentación REST.

## Scalar

Referencia moderna para exploración de la API.

---

# Organización Funcional

El Backend se encuentra dividido por módulos funcionales.

Módulos identificados:

- Usuarios
- Autenticación
- Categorías
- Subcategorías
- Segmentos
- Productos
- Marcas
- Proveedores
- Variables de Producto
- Imágenes
- Inventario
- Carrito
- Métodos de Pago
- Órdenes
- Kardex
- Roles
- Permisos

Cada módulo mantiene su propia separación entre:

- Repository
- Service
- DTOs

---

# Flujo de una Solicitud

El flujo general de una petición es el siguiente:

```
Cliente (React Native)

↓

Controller

↓

Application Service

↓

Repository

↓

SQL Server

↓

Repository

↓

Service

↓

Controller

↓

Cliente
```

---

# Principios Arquitectónicos

El proyecto sigue los siguientes principios:

- Separación de responsabilidades.
- Bajo acoplamiento.
- Alta cohesión.
- Inyección de dependencias.
- Modularidad.
- Reutilización de código.
- Escalabilidad.

---

# Conclusiones

La arquitectura actual proporciona una base sólida para el desarrollo del Frontend.

Toda nueva funcionalidad deberá respetar esta separación de capas.

El Frontend únicamente interactuará con la API expuesta por la capa Presentation.

Nunca deberá depender de detalles internos de Application, Infrastructure o Domain.