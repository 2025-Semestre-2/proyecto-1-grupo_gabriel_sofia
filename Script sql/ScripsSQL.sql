CREATE DATABASE SistemaGestion;
USE SistemaGestion;

CREATE TABLE THospedaje
(
	IdTipoCatalogo INT IDENTITY(1,1)PRIMARY KEY,
	Nombre Varchar(50) UNIQUE NOT NULL
);

CREATE TABLE RedesSociales
(
	IdRedSocial INT PRIMARY KEY IDENTITY(1,1),
	Red Varchar(50) NOT NULL UNIQUE,
	URLRed Varchar(100)
);

CREATE TABLE Servicios
(
	IdServicio INT PRIMARY KEY IDENTITY(1,1),
	Servicios Varchar(50) NOT NULL UNIQUE
);

CREATE TABLE TipoCama
(
	IdTipoCama INT PRIMARY KEY IDENTITY(1,1),
	Tipos varchar(100) NOT NULL UNIQUE
);

CREATE TABLE TipoIdentificacion
(
	IdTipoIdentificacion INT PRIMARY KEY IDENTITY(1,1),
	Tipo VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE MetodoPago
(
	IdMetodo INT PRIMARY KEY IDENTITY(1,1),
	Metodos Varchar(50) NOT NULL UNIQUE
);

CREATE TABLE TipoActividad
(
	IdTipoActividad INT PRIMARY KEY IDENTITY(1,1),
	Tipo Varchar(50) NOT NULL UNIQUE,
	Descripcion VARCHAR(150)
);

CREATE TABLE Comodidades
(
	IdComodidades INT PRIMARY KEY IDENTITY(1,1),
	ListaComodidades Varchar(50) NOT NULL UNIQUE
);

CREATE TABLE Pais
(
	IdPais INT IDENTITY (1,1) PRIMARY KEY,
	Nombre VARCHAR(100)NOT NULL UNIQUE,
	CodigoTelefono VARCHAR(5)
);

CREATE TABLE Provincia 
(
    IdProvincia INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    IdPais INT NOT NULL FOREIGN KEY REFERENCES 
	    Pais(IdPais)
);

CREATE TABLE Canton 
(
    IdCanton INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    IdProvincia INT NOT NULL FOREIGN KEY REFERENCES 
	    Provincia(IdProvincia)
);

CREATE TABLE EstadoHabitacion (
	IdEstado INT IDENTITY(1,1) PRIMARY KEY,
	NombreEstado VARCHAR(15)NOT NULL UNIQUE
);

CREATE TABLE Hospedaje
(
	IdHospedaje INT IDENTITY (1,1) PRIMARY KEY,
	CedulaJuridica INT UNIQUE NOT NULL,
	Nombre varchar(50) NOT NULL,
	Tipo INT NOT NULL FOREIGN KEY REFERENCES 
		THospedaje(IdTipoCatalogo),
	Direccion varchar(250) NOT NULL,
	GPS varchar(100),
	Correo varchar(100) NOT NULL,
	URL varchar(100),
);

CREATE TABLE Cliente
(
	IdCliente INT IDENTITY(1,1)PRIMARY KEY,
	Nombre VARCHAR(50) NOT NULL,
	PApellido VARCHAR(50) NOT NULL,
	SApellido VARCHAR(50) NOT NULL,
	FNacimiento DATE NOT NULL,
	TipoId INT NOT NULL FOREIGN KEY REFERENCES
		TipoIdentificacion(IdTipoIdentificacion),
	IdPaisResidencia INT NOT NULL FOREIGN KEY REFERENCES
	    Pais(IdPais),
	IdProvincia INT FOREIGN KEY REFERENCES
	    Provincia(IdProvincia),
	IdCanton INT FOREIGN KEY REFERENCES
	    Canton(IdCanton),
	Direccion VARCHAR(250) NOT NULL,
	Correo VARCHAR(100) NOT NULL
);

CREATE TABLE TipoHabitacion
(
	IdTipo INT PRIMARY KEY IDENTITY (1,1),
	Nombre Varchar(50) NOT NULL,
	Descripcion Varchar(200),
	Precio INT NOT NULL CHECK (Precio>0),
	IdTipoCama INT NOT NULL FOREIGN KEY REFERENCES
		TipoCama(IdTipoCama),
	IdHospedaje INT NOT NULL FOREIGN KEY REFERENCES
		Hospedaje(IdHospedaje)
);

CREATE TABLE TipoHabitacionComodidad (
    IdTipoHabitacion INT NOT NULL,
    IdComodidad INT NOT NULL,
    PRIMARY KEY (IdTipoHabitacion, IdComodidad),
    FOREIGN KEY (IdTipoHabitacion) REFERENCES
	    TipoHabitacion(IdTipo),
    FOREIGN KEY (IdComodidad) REFERENCES 
	    Comodidades(IdComodidad)
);

CREATE TABLE TipoHabitacionFoto
(
	IdFoto INT IDENTITY(1,1) PRIMARY KEY,
	IdTipoHabitacion INT NOT NULL,
	URLFoto Varchar(150) NOT NULL,
	FOREIGN KEY(IdTipoHabitacion) REFERENCES 
	    TipoHabitacion(IdTipo)
);

CREATE TABLE HospedajeServicio
(
    IdHospedaje INT NOT NULL,
    IdServicio INT NOT NULL,
    PRIMARY KEY (IdHospedaje, IdServicio),
    FOREIGN KEY (IdHospedaje) REFERENCES 
	    Hospedaje(IdHospedaje),
    FOREIGN KEY (IdServicio) REFERENCES 
	    Servicios(IdServicio)
);

CREATE TABLE HospedajeRedSocial 
(
    IdHospedaje INT NOT NULL,
    IdRedSocial INT NOT NULL,
    UsuarioURL VARCHAR(255) NOT NULL,
    PRIMARY KEY (IdHospedaje, IdRedSocial),
    FOREIGN KEY (IdHospedaje) REFERENCES 
	    Hospedaje(IdHospedaje),
    FOREIGN KEY (IdRedSocial) REFERENCES 
	    RedesSociales(IdRedSocial)
);

CREATE TABLE HospedajeTelefono 
(
    IdTelefono INT IDENTITY(1,1) PRIMARY KEY,
    IdHospedaje INT NOT NULL,
    CodigoPais VARCHAR(5) NOT NULL DEFAULT '+506',
    Numero VARCHAR(20) NOT NULL,
    FOREIGN KEY (IdHospedaje) REFERENCES 
	    Hospedaje(IdHospedaje)
);

CREATE TABLE Habitacion
(
	IdHabitacion INT IDENTITY(1,1) PRIMARY KEY,
	NumeroHabitacion VARCHAR(10) NOT NULL UNIQUE,
	IdTipo INT FOREIGN KEY REFERENCES
		TipoHabitacion(IdTipo),
	IdEstado INT NOT NULL FOREIGN KEY REFERENCES 
	    EstadoHabitacion(IdEstado)
);

CREATE TABLE ClienteTelefono 
(
    IdTelefonoCliente INT IDENTITY(1,1) PRIMARY KEY,
    IdCliente INT NOT NULL FOREIGN KEY REFERENCES 
	    Cliente(IdCliente),
    CodigoPais VARCHAR(5) NOT NULL,
    Numero VARCHAR(20) NOT NULL
);

CREATE TABLE Reservacion
(
	IdReservacion INT IDENTITY (1,1) PRIMARY KEY,
	NumReservacion INT  UNIQUE NOT NULL,
	IdCliente INT NOT NULL FOREIGN KEY REFERENCES
		Cliente(IdCliente),
	IdHabitacion INT NOT NULL FOREIGN KEY REFERENCES
		Habitacion(IdHabitacion),
	FechaHoraIngreso DATETIME NOT NULL,
	CantidadPersonas INT NOT NULL CHECK (CantidadPersonas>0),
	Vehiculo BIT NOT NULL DEFAULT 0,
	FechaSalida DATE NOT NULL
);

CREATE TABLE Factura
(	
	IdFactura INT IDENTITY(1,1) PRIMARY KEY,
	NumFactura VARCHAR(15) UNIQUE NOT NULL,
	FechaHora DATETIME NOT NULL DEFAULT GETDATE(),
	NumeroReserva INT FOREIGN KEY REFERENCES
		Reservacion(NumReservacion),
	CargoHabitacion INT,
	NumNoches INT NOT NULL,
	ImporteTotal INT NOT NULL,
	MetodoPago INT NOT NULL FOREIGN KEY REFERENCES
		MetodoPago(IdMetodo)
);

CREATE TABLE ActividadRecreacion
(
	IdActividadRecreacion INT IDENTITY(1,1)PRIMARY KEY,
	CedulaJuridica INT PRIMARY KEY,
	Nombre VARCHAR(50) NOT NULL,
	Correo VARCHAR(100) NOT NULL,
	NombreContacto Varchar(50) NOT NULL, 
	Direccion VARCHAR(250),
	Descripcion VARCHAR(250),
	Precio INT NOT NULL
);

CREATE TABLE ActividadTelefono 
(
    IdTelefono INT IDENTITY(1,1) PRIMARY KEY,
    IdActividadRecreacion INT NOT NULL,
    CodigoPais VARCHAR(5) NOT NULL DEFAULT '+506',
    Numero VARCHAR(20) NOT NULL,
    FOREIGN KEY (IdActividadRecreacion) REFERENCES 
	    ActividadRecreacion(IdActividadRecreacion)
);

CREATE TABLE ActividadRecreacionTipo 
(
    IdActividadRecreacion INT NOT NULL,
    IdTipoActividad INT NOT NULL,
    Precio DECIMAL(10,2),
    PRIMARY KEY (IdActividadRecreacion, IdTipoActividad),
    FOREIGN KEY (IdActividadRecreacion) REFERENCES 
	    ActividadRecreacion(IdActividadRecreacion),
    FOREIGN KEY (IdTipoActividad) REFERENCES 
	    TipoActividad(IdTipoActividad)
);


