CREATE DATABASE SistemaGestion;
USE SistemaGestiones;
CREATE TABLE THospedaje
(
	IdTipoCatalogo INT IDENTITY(1,1)PRIMARY KEY,
	Nombre Varchar(50) UNIQUE NOT NULL
);

CREATE TABLE RedesSociales
(
	IdRedSocial INT PRIMARY KEY IDENTITY(1,1),
	Red Varchar(50) NOT NULL,
	URLRed Varchar(50)
);

CREATE TABLE Servicios
(
	IdServicio INT PRIMARY KEY IDENTITY(1,1),
	Servicios Varchar(50) NOT NULL
);

CREATE TABLE Hospedaje
(
	CedulaJuridica INT PRIMARY KEY,
	Nombre varchar(50) NOT NULL,
	Tipo INT NOT NULL FOREIGN KEY REFERENCES 
		THospedaje(IdTipoCatalogo),
	Direccion varchar(250) NOT NULL,
	GPS varchar(100),
	Telefono INT,
	Correo varchar(100) NOT NULL,
	URL varchar(100),
	Redes INT FOREIGN KEY REFERENCES
		RedesSociales(IdRedSocial),
	Servicios INT FOREIGN KEY REFERENCES
		Servicios(IdServicio)
);

CREATE TABLE TipoCama
(
	IdTipoCama INT PRIMARY KEY IDENTITY(1,1),
	Tipos varchar(100)
);
CREATE TABLE Comodidades
(
	IdComodidades INT PRIMARY KEY IDENTITY(1,1),
	ListaComodidades Varchar(50) NOT NULL
);

CREATE TABLE TipoHabitacion
(
	IdTipo INT PRIMARY KEY,
	Nombre Varchar(50) NOT NULL,
	Descripcion Varchar(100),
	Fotos Varchar(100),
	Comodidades INT FOREIGN KEY REFERENCES
		Comodidades(IdComodidades),
	Precio INT NOT NULL,
	IdTipoCama INT NOT NULL FOREIGN KEY REFERENCES
		TipoCama(IdTipoCama)
);

CREATE TABLE Habitacion
(
	IdHabitacion INT PRIMARY KEY,
	IdTipo INT FOREIGN KEY REFERENCES
		TipoHabitacion(IdTipo),
	Estado INT NOT NULL
);

CREATE TABLE TipoIdentificacion
(
	IdTipoIdentificacion INT PRIMARY KEY IDENTITY(1,1),
	Tipo VARCHAR(50) NOT NULL
);

CREATE TABLE Cliente
(
	IdCliente INT PRIMARY KEY,
	Nombre VARCHAR(50) NOT NULL,
	PApellido VARCHAR(50) NOT NULL,
	SApellido VARCHAR(50) NOT NULL,
	FNacimiento DATE NOT NULL,
	TipoId INT NOT NULL FOREIGN KEY REFERENCES
		TipoIdentificacion(IdTipoIdentificacion),
	Residencia VARCHAR(50) NOT NULL,
	Direccion VARCHAR(250) NOT NULL,
	Telefono1 INT UNIQUE NOT NULL,
	Telefono2 INT UNIQUE NOT NULL,
	Correo VARCHAR(100) NOT NULL
);

CREATE TABLE Reservacion
(
	NumReservacion INT PRIMARY KEY IDENTITY(1,1),
	IdCliente INT NOT NULL FOREIGN KEY REFERENCES
		Cliente(IdCliente),
	IdHabitacion INT NOT NULL FOREIGN KEY REFERENCES
		Habitacion(IdHabitacion),
	FechaHoraIngreso DATETIME NOT NULL,
	CantidadPersonas INT NOT NULL,
	Vehiculo BIT NOT NULL,
	FechaSalida DATE NOT NULL
);

CREATE TABLE MetodoPago
(
	IdMetodo INT PRIMARY KEY IDENTITY(1,1),
	Metodos Varchar(50) NOT NULL
);
CREATE TABLE Factura
(	
	NumFactura INT PRIMARY KEY IDENTITY(1,1),
	FechaHora DATE NOT NULL,
	NumeroReserva INT FOREIGN KEY REFERENCES
		Reservacion(NumReservacion),
	CargoHabitacion INT,
	NumNoches INT NOT NULL,
	ImporteTotal INT NOT NULL,
	MetodoPago INT NOT NULL FOREIGN KEY REFERENCES
		MetodoPago(IdMetodo)
);

CREATE TABLE TipoActividad
(
	IdTipoActividad INT PRIMARY KEY IDENTITY(1,1),
	Tipo Varchar(50) NOT NULL,
	Descripcion VARCHAR(100)
);


CREATE TABLE ActividadRecreacion
(
	CedulaJuridica INT PRIMARY KEY,
	Nombre VARCHAR(50) NOT NULL,
	Correo VARCHAR(100) NOT NULL,
	Telefono INT NOT NULL,
	NombreContacto Varchar(50) NOT NULL, 
	Direccion VARCHAR(250),
	TipoActividad INT NOT NULL FOREIGN KEY REFERENCES
		TipoActividad(IdTipoActividad),
	TipoServicio INT NOT NULL FOREIGN KEY REFERENCES
		Servicios(IdServicio),
	Descripcion VARCHAR(250),
	Precio INT NOT NULL
);


--INSERTS PARA PROBAR
--Catalogos

INSERT INTO THospedaje (Nombre)
VALUES ('Hotel'), ('Cabina'), ('Hostel');

INSERT INTO RedesSociales (Red, URLRed)
VALUES ('Instagram', 'https://instagram.com/ejemplo'),
       ('Facebook',  'https://facebook.com/ejemplo'),
       ('TikTok',    'https://tiktok.com/@ejemplo');

INSERT INTO TipoCama (Tipos)
VALUES ('Individual'), ('Matrimonial'), ('Queen');

INSERT INTO Comodidades (ListaComodidades)
VALUES ('Aire acondicionado'), ('TV'), ('Caja fuerte'), ('Balcón');

INSERT INTO TipoIdentificacion (Tipo)
VALUES ('Cédula'), ('Pasaporte');

INSERT INTO MetodoPago (Metodos)
VALUES ('Efectivo'), ('Tarjeta'), ('SINPE');

INSERT INTO Servicios (Servicios)
VALUES ('WiFi'), ('Parqueo'), ('Desayuno'), ('Piscina');

INSERT INTO TipoActividad (Tipo, Descripcion)
VALUES ('Aventura', 'Actividades al aire libre'),
       ('Cultural', 'Tours y experiencias culturales'),
       ('Relax',    'Actividades de descanso');


--Tablas Principales

-- Hospedaje (ojo: CedulaJuridica NO es identity, se pone manual)
-- Tipo: 1..n según lo insertado en THospedaje
-- Redes: 1..n según RedesSociales
-- Servicios: 1..n según Servicios
INSERT INTO Hospedaje
(CedulaJuridica, Nombre, Tipo, Direccion, GPS, Telefono, Correo, URL, Redes, Servicios)
VALUES
(310100111, 'Hotel Paraíso', 1, 'Cahuita', '10.016,-84.214', 88887777, 'contacto@paraiso.com', 'https://paraiso.com', 1, 1),
(310100222, 'Cabinas La Montaña', 2, 'Puerto Viejo', '9.940,-83.964', 22223333, 'info@montana.com', 'https://montana.com', 2, 2);

INSERT INTO TipoHabitacion
(IdTipo, Nombre, Descripcion, Fotos, Comodidades, Precio, IdTipoCama)
VALUES
(101, 'Estándar', 'Habitación básica', 'std1.jpg', 2, 45000, 2),
(102, 'Suite', 'Habitación amplia', 'suite1.jpg', 1, 85000, 3);

INSERT INTO Habitacion
(IdHabitacion, IdTipo, Estado)
VALUES
(1, 101, 1),
(2, 101, 1),
(3, 102, 0);

-- Cliente (IdCliente manual)
INSERT INTO Cliente
(IdCliente, Nombre, PApellido, SApellido, FNacimiento, TipoId, Residencia, Direccion, Telefono1, Telefono2, Correo)
VALUES
(1001, 'Ana', 'López', 'Jiménez', '2003-05-10', 1, 'Costa Rica', 'Heredia, Barva', 88881111, 88882222, 'ana.lopez@email.com'),
(1002, 'Carlos', 'Pérez', 'Soto', '2001-11-22', 2, 'Panamá', 'San José, Escazú', 77771111, 77772222, 'carlos.perez@email.com');

-- Reservacion (NumReservacion es identity)
INSERT INTO Reservacion
(IdCliente, IdHabitacion, FechaHoraIngreso, CantidadPersonas, Vehiculo, FechaSalida)
VALUES
(1001, 1, '2025-01-08 14:00:00', 2, 1, '2025-01-10'),
(1002, 3, '2025-01-09 10:30:00', 1, 0, '2025-01-11');

-- Factura (NumFactura identity)
-- NumeroReserva: asume que las reservaciones quedaron 1 y 2 (si no, usa SELECT para verlas)
INSERT INTO Factura
(FechaHora, NumeroReserva, CargoHabitacion, NumNoches, ImporteTotal, MetodoPago)
VALUES
('2025-01-10', 1, 0, 2, 90000, 2),
('2025-01-11', 2, 0, 2, 170000, 3);

-- ActividadRecreacion
-- TipoServicio referencia Servicios (o sea: WiFi/Parqueo/etc). Es raro pero así está tu modelo.
INSERT INTO ActividadRecreacion
(CedulaJuridica, Nombre, Correo, Telefono, NombreContacto, Direccion, TipoActividad, TipoServicio, Descripcion, Precio)
VALUES
(310200111, 'Aventuras CR', 'hola@aventurascr.com', 88889999, 'María Rojas', 'La Fortuna', 1, 2, 'Tour de canopy', 35000),
(310200222, 'Relax Spa', 'info@relaxspa.com', 22224444, 'José Mora', 'Tamarindo', 3, 1, 'Masaje relajante', 30000);

--SELECTS PARA VERIFICAR
SELECT * FROM THospedaje;
SELECT * FROM RedesSociales;
SELECT * FROM Servicios;
SELECT * FROM Hospedaje;

SELECT * FROM TipoCama;
SELECT * FROM Comodidades;
SELECT * FROM TipoHabitacion;
SELECT * FROM Habitacion;

SELECT * FROM TipoIdentificacion;
SELECT * FROM Cliente;

SELECT * FROM Reservacion;

SELECT * FROM MetodoPago;
SELECT * FROM Factura;

SELECT * FROM TipoActividad;
SELECT * FROM ActividadRecreacion;

