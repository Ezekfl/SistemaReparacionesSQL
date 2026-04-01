--	====================================
--	Taller Practicol: "Arquitectura
--	y Gestion de Datos en TiendaTec"
--	Estudiante: Ezequiel Flores Salazar
--	Trabajo individual
--	====================================

-- ==========================
-- CREACIÓN DE BASE DE DATOS
-- ==========================

CREATE DATABASE TIENDA_TEC;
GO

USE TIENDA_TEC;
GO

--	Tabla Productos
CREATE TABLE PRODUCTOS(
  	ProductoID INT IDENTITY PRIMARY KEY,
	Descripcion VARCHAR(100) NOT NULL,
	Valor DECIMAL(10,2) NOT NULL,
	--	En este caso pedia el usar FLOAT pero investigando averigue que 
	--	FLOAT es un valor aproximado que a la hora de hacer ecuaciones no 
	--	es conveniente ya que para FLOAT 0.1 + 0.2 ≠ 0.3 exactamente
	--	sin embargo DECIMAL si que guarda los valores exactos y se usa para
	--	situaciones de manegar valores monetarios
	Stock INT NOT NULL
);

--	Tabla Ventas
CREATE TABLE VENTAS(
	VentaID INT IDENTITY PRIMARY KEY,
	ProductoID INT,
	Cantidad INT NOT NULL,
	Fecha DATETIME DEFAULT GETDATE(),
	
	FOREIGN KEY (ProductoID) REFERENCES PRODUCTOS(ProductoID)
);

--	===============
--	DML 
--	===============
INSERT INTO PRODUCTOS (Descripcion, Valor, Stock)
VALUES
('Laptop Dell XPS', 1200, 10),
('Mouse Logitech Pro', 50, 25),
('Teclado Mecánico RGB', 150, 15),
('Monitor Samsung 27', 300, 8),
('Audifonos Sony Pro', 200, 12);

--	========================
--	Ajuste de precios (%15)
--	========================
UPDATE PRODUCTOS
SET Valor = Valor * 1.15;

--	================================
--	DEPURACION (Eliminar stock = 0)
--	================================

DELETE FROM PRODUCTOS
WHERE Stock = 0;

--	==================
--	CONSULTAS (SELECT)
--	==================

-- Rango de valor
SELECT *
FROM PRODUCTOS
WHERE Valor BETWEEN 100 AND 1000;

-- Búsqueda de texto
SELECT *
FROM PRODUCTOS
WHERE Descripcion LIKE '%Pro%';

-- Valor total del inventario
SELECT SUM(Valor * Stock) AS TotalInventario
FROM PRODUCTOS;

-- Costo promedio
SELECT AVG(Valor) AS PromedioPrecio
FROM PRODUCTOS;

-- 1. Catálogo ordenado
CREATE PROCEDURE sp_CatalogoOrdenado
AS
BEGIN
    SELECT *
    FROM PRODUCTOS
    ORDER BY Valor DESC;
END;
GO

-- 2. Alerta de existencias
CREATE PROCEDURE sp_AlertaExistencias
@Limite INT
AS
BEGIN
    SELECT *
    FROM PRODUCTOS
    WHERE Stock < @Limite;
END;
GO

-- 3. Registrar transacción
CREATE PROCEDURE sp_RegistrarTransaccion
@ProductoID INT,
@Cantidad INT
AS
BEGIN
    INSERT INTO VENTAS (ProductoID, Cantidad)
    VALUES (@ProductoID, @Cantidad);
END;
GO

-- 4. Cambiar costo
CREATE PROCEDURE sp_CambiarCosto
@ProductoID INT,
@NuevoValor FLOAT
AS
BEGIN
    UPDATE PRODUCTOS
    SET Valor = @NuevoValor
    WHERE ProductoID = @ProductoID;
END;
GO

-- ======================================
-- DESAFÍO FINAL (GROUP BY)
-- ======================================

SELECT ProductoID, SUM(Cantidad) AS TotalVendido
FROM VENTAS
GROUP BY ProductoID;


-- =========================
-- PRUEBAS DE PROCEDIMIENTOS
-- =========================

EXEC sp_CatalogoOrdenado;
EXEC sp_AlertaExistencias 10;
EXEC sp_RegistrarTransaccion 1, 2;
EXEC sp_CambiarCosto 2, 75;