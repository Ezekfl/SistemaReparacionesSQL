-- ======================================
-- BASE DE DATOS
-- ======================================
CREATE DATABASE SistemaReparaciones;
GO

USE SistemaReparaciones;
GO

-- ======================================
-- CREACIÓN DE TABLAS
-- ======================================

CREATE TABLE Usuarios(
    UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    CorreoElectronico VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Equipos(
    EquipoID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT,
    Modelo VARCHAR(100),
    Marca VARCHAR(100),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

CREATE TABLE Tecnicos(
    TecnicoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100),
    Especialidad VARCHAR(100)
);

CREATE TABLE Reparaciones(
    ReparacionID INT IDENTITY(1,1) PRIMARY KEY,
    EquipoID INT,
    FechaSolicitud DATETIME,
    Estado VARCHAR(50) DEFAULT 'Pendiente',
    FOREIGN KEY (EquipoID) REFERENCES Equipos(EquipoID)
);

CREATE TABLE Asignaciones(
    AsignacionID INT IDENTITY(1,1) PRIMARY KEY,
    ReparacionID INT,
    TecnicoID INT,
    FOREIGN KEY (ReparacionID) REFERENCES Reparaciones(ReparacionID),
    FOREIGN KEY (TecnicoID) REFERENCES Tecnicos(TecnicoID)
);

CREATE TABLE DetallesReparacion(
    DetalleID INT IDENTITY(1,1) PRIMARY KEY,
    ReparacionID INT,
    Descripcion VARCHAR(255),
    FechaFinalizacion DATETIME,
    FOREIGN KEY (ReparacionID) REFERENCES Reparaciones(ReparacionID)
);

-- ======================================
-- INSERTS
-- ======================================

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
-- CONSULTA FINAL
-- ======================================

SELECT
    Usuarios.Nombre,
    Equipos.Modelo,
    Reparaciones.Estado
FROM Reparaciones
INNER JOIN Equipos ON Reparaciones.EquipoID = Equipos.EquipoID
INNER JOIN Usuarios ON Equipos.UsuarioID = Usuarios.UsuarioID;