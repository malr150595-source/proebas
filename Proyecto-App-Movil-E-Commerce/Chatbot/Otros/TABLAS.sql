CREATE DATABASE [DB_ECOMMERCEAGENT]
GO

USE [DB_ECOMMERCEAGENT]
GO

CREATE TABLE ReglasChatbot (
    ReglaID INT PRIMARY KEY IDENTITY(1,1),
    NombreRegla VARCHAR(100) NOT NULL,
    AccionDinamica BIT NOT NULL,     
    AccionPython VARCHAR(100) NULL,
    Activo BIT
);
Go

CREATE TABLE PalabrasClaveRegla (
    PalabraClaveID INT PRIMARY KEY IDENTITY(1,1),
    ReglaID INT NOT NULL REFERENCES ReglasChatbot(ReglaID),
    PalabraClave VARCHAR(100) NOT NULL,
	Activo BIT
);
Go

CREATE TABLE PlantillasRespuesta (
    PlantillaID INT IDENTITY(1,1) PRIMARY KEY,
    ReglaID INT NOT NULL REFERENCES ReglasChatbot(ReglaID),
    TextoRespuesta NVARCHAR(MAX) NOT NULL, -- La frase exacta que dirá el bot
    Activo BIT
);

CREATE TABLE HistorialConversaciones
(
	ConversacionID BIGINT IDENTITY(1,1) PRIMARY KEY,
	UsuarioID VARCHAR(100) NOT NULL,
	FechaInicio DATETIME NOT NULL,
	FechaFin DATETIME NULL,
	Activo BIT
);
Go

CREATE TABLE HistorialMensajes (
    MensajeID BIGINT IDENTITY(1,1) PRIMARY KEY,
	ConversacionID BIGINT REFERENCES HistorialConversaciones (ConversacionID) NOT NULL,
    ChatBot BIT NOT NULL,        
    Texto VARCHAR(1000) NOT NULL,
    FechaHora DATETIME NOT NULL,
    ReglaActivadaID INT REFERENCES ReglasChatbot(ReglaID),    
    metadata Nvarchar(Max) 
);
Go

CREATE TABLE [dbo].[BotSinonimos] (
    [SinonimoID] INT IDENTITY(1,1) PRIMARY KEY,
    [PalabraUsuario] VARCHAR(100) NOT NULL,
    [PalabraCatalogo] VARCHAR(100) NOT NULL,
    [Activo] BIT DEFAULT 1
);
GO

CREATE TABLE dbo.StopWordsCarrito (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Palabra NVARCHAR(100) NOT NULL UNIQUE,
        Activo BIT NOT NULL DEFAULT 1,
        FechaCreacion DATETIME NOT NULL DEFAULT GETDATE()
    );

CREATE TABLE [dbo].[StopWordsBuscar] (
        [StopWordID] INT IDENTITY(1,1) PRIMARY KEY,
        [Palabra] VARCHAR(100) NOT NULL UNIQUE,
        [Activo] BIT NOT NULL DEFAULT 1
    );

CREATE TABLE dbo.StopWords (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Palabra NVARCHAR(100) NOT NULL UNIQUE,
        Activo BIT NOT NULL DEFAULT 1,
        FechaCreacion DATETIME NOT NULL DEFAULT GETDATE()
    );