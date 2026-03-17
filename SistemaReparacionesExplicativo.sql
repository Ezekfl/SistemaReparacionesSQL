-- ======================================
-- SISTEMA DE GESTIÓN DE REPARACIONES
-- Proyecto Introducción a Programación
--
-- Autores:
-- • Ezequiel Flores
-- • Leiber Aguero
-- • Katherine Rojas
-- • Samantha Flores
--
-- Curso: Introducción a la Programación
-- Fecha: 2026
--
-- Descripción:
-- Este sistema permite gestionar reparaciones tecnológicas,
-- incluyendo el registro de usuarios, equipos, técnicos,
-- asignaciones y seguimiento del estado de cada reparación.
--
-- Nota técnica:
-- Este proyecto fue adaptado para SQL Server utilizando
-- IDENTITY en lugar de AUTO_INCREMENT, ya que este último
-- pertenece a MySQL y no es compatible con SQL Server.
-- ======================================
-- ======================================
-- CREACIÓN DE BASE DE DATOS
-- ======================================

CREATE DATABASE SistemaReparaciones;
GO

USE SistemaReparaciones;
GO

-- ======================================
-- TABLA: USUARIOS
-- ======================================

/*
Se utiliza CREATE TABLE para crear una tabla.

IDENTITY(1,1):
- Genera automáticamente IDs únicos
- 1 = valor inicial
- 1 = incremento

PRIMARY KEY:
- Identifica de forma única cada registro

NOT NULL:
- Obliga a que el campo tenga valor

UNIQUE:
- Evita datos repetidos
*/

CREATE TABLE Usuarios(
    UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    CorreoElectronico VARCHAR(100) UNIQUE NOT NULL
);

-- ======================================
-- TABLA: EQUIPOS
-- ======================================

/*
FOREIGN KEY:
- Crea una relación entre tablas
- Aquí conectamos cada equipo con un usuario

Esto asegura integridad de datos
(no puedes asignar un equipo a un usuario que no existe)
*/

CREATE TABLE Equipos(
    EquipoID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT,
    Modelo VARCHAR(100),
    Marca VARCHAR(100),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

-- ======================================
-- TABLA: TECNICOS
-- ======================================

CREATE TABLE Tecnicos(
    TecnicoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100),
    Especialidad VARCHAR(100)
);

-- ======================================
-- TABLA: REPARACIONES
-- ======================================

/*
DEFAULT:
- Asigna un valor por defecto si no se especifica

En este caso:
Estado = 'Pendiente'
*/

CREATE TABLE Reparaciones(
    ReparacionID INT IDENTITY(1,1) PRIMARY KEY,
    EquipoID INT,
    FechaSolicitud DATETIME,
    Estado VARCHAR(50) DEFAULT 'Pendiente',
    FOREIGN KEY (EquipoID) REFERENCES Equipos(EquipoID)
);

-- ======================================
-- TABLA: ASIGNACIONES
-- ======================================

/*
Esta tabla conecta:
- Reparaciones
- Técnicos

Es una tabla intermedia (relación muchos a muchos)
*/

CREATE TABLE Asignaciones(
    AsignacionID INT IDENTITY(1,1) PRIMARY KEY,
    ReparacionID INT,
    TecnicoID INT,
    FOREIGN KEY (ReparacionID) REFERENCES Reparaciones(ReparacionID),
    FOREIGN KEY (TecnicoID) REFERENCES Tecnicos(TecnicoID)
);

-- ======================================
-- TABLA: DETALLES DE REPARACIÓN
-- ======================================

CREATE TABLE DetallesReparacion(
    DetalleID INT IDENTITY(1,1) PRIMARY KEY,
    ReparacionID INT,
    Descripcion VARCHAR(255),
    FechaFinalizacion DATETIME,
    FOREIGN KEY (ReparacionID) REFERENCES Reparaciones(ReparacionID)
);

-- ======================================
-- INSERCIÓN DE DATOS
-- ======================================

/*
INSERT INTO:
- Se usa para agregar datos a una tabla
*/

INSERT INTO Usuarios (Nombre,CorreoElectronico) VALUES
('Samantha Flores','Samfl@email.com'),
('Ezequiel Flores','Ezekfl@email.com'),
('Leiber Aguero','Leibag@email.com'),
('Katherine Rojas','Kathro@email.com');

INSERT INTO Equipos (UsuarioID, Modelo, Marca) VALUES
(1,'XPS 14','Dell'),
(2,'MacBook Pro','Apple'),
(3,'Galaxy Book','Samsung'),
(4,'ThinkPad X1','Lenovo');

INSERT INTO Tecnicos (Nombre,Especialidad) VALUES
('Cintia Aguirre','Laptop'),
('Nélida Fernandez','Celulares'),
('Miriam Campo','Hardware'),
('Adelina Hermida','Software');

INSERT INTO Reparaciones (EquipoID, FechaSolicitud) VALUES
(1,'2026-03-01'),
(2,'2026-03-05'),
(3,'2026-03-10'),
(4,'2026-03-12');

INSERT INTO Asignaciones (ReparacionID, TecnicoID) VALUES
(1,1),
(2,2),
(3,3),
(4,4);

INSERT INTO DetallesReparacion (ReparacionID, Descripcion, FechaFinalizacion) VALUES
(1,'Cambio de batería','2026-03-03'),
(2,'Reemplazo de pantalla','2026-03-07'),
(3,'Limpieza interna','2026-03-12'),
(4,'Reinstalación del sistema operativo','2026-03-15');

-- ======================================
-- CONSULTAS
-- ======================================

/*
SELECT:
- Permite consultar datos

INNER JOIN:
- Une tablas relacionadas

En este caso:
- Usuarios + Equipos + Reparaciones
*/

SELECT
    Usuarios.Nombre,
    Equipos.Modelo,
    Reparaciones.Estado
FROM Reparaciones
INNER JOIN Equipos ON Reparaciones.EquipoID = Equipos.EquipoID
INNER JOIN Usuarios ON Equipos.UsuarioID = Usuarios.UsuarioID;

-- ======================================
-- CONCLUSIÓN
-- ======================================

/*
Este sistema demuestra:

✔ Uso de tablas relacionadas
✔ Uso de llaves primarias y foráneas
✔ Inserción de datos
✔ Consultas con JOIN
✔ Diferencias entre motores SQL

AUTO_INCREMENT (MySQL)
IDENTITY (SQL Server)

Esto permite que el sistema sea adaptable
a diferentes entornos de base de datos.
*/