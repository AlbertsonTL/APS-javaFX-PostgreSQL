-- =====================================================================
-- Script SQL obtenido por ingeniería inversa del proyecto Punto de Venta
-- =====================================================================
-- Origen: extraído y verificado directamente desde el backup binario
--         "ventas.backup" (formato TAR de pg_dump 9.2.3) incluido en el
--         proyecto, usando pg_restore. Cada tabla, columna, secuencia,
--         llave primaria y llave foránea fue confirmada contra el uso
--         real que hace el código Java (DBConnection, LoginController,
--         RegistroController, ProductoController).
--
-- Motor:  PostgreSQL
-- Uso:
--   1. createdb -U postgres ventas
--   2. psql -U postgres -d ventas -f ventas_ingenieria_inversa.sql
-- =====================================================================

BEGIN;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

-- ---------------------------------------------------------------------
-- Limpieza (permite re-ejecutar el script sin errores)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS producto CASCADE;
DROP TABLE IF EXISTS marca CASCADE;
DROP TABLE IF EXISTS categoria CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

-- =====================================================================
-- TABLA: categoria
-- Usada en: ProductoController.java -> "SELECT idcategoria, nombre_categoria FROM categoria"
-- =====================================================================
CREATE TABLE categoria (
    idcategoria      SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL
);

-- =====================================================================
-- TABLA: marca
-- Usada en: ProductoController.java -> "SELECT idmarca, nombre_marca FROM marca"
-- =====================================================================
CREATE TABLE marca (
    idmarca      SERIAL PRIMARY KEY,
    nombre_marca VARCHAR(100) NOT NULL
);

-- =====================================================================
-- TABLA: producto
-- Usada en: ProductoController.java (cargarDatosTabla, addProducto,
--           modificarProducto, eliminarProducto, buscarProducto)
-- =====================================================================
CREATE TABLE producto (
    idproducto      SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    precio          INTEGER NOT NULL,
    idcategoria     INTEGER NOT NULL,
    idmarca         INTEGER NOT NULL,
    CONSTRAINT producto_idcategoria_fkey FOREIGN KEY (idcategoria) REFERENCES categoria (idcategoria),
    CONSTRAINT producto_idmarca_fkey     FOREIGN KEY (idmarca)     REFERENCES marca (idmarca)
);

-- =====================================================================
-- TABLA: usuarios
-- Usada en: LoginController.java (login), RegistroController.java (alta de usuario)
-- Nota: la columna de correo es "correo" (no "email") y el password se
--       guarda con hash SHA-1 (DigestUtils.sha1Hex).
-- =====================================================================
CREATE TABLE usuarios (
    idusuarios SERIAL PRIMARY KEY,
    nombre     VARCHAR(100) NOT NULL,
    apellido   VARCHAR(100) NOT NULL,
    sexo       VARCHAR(10)  NOT NULL,
    correo     VARCHAR(100) NOT NULL,
    usuario    VARCHAR(100) NOT NULL,
    pass       VARCHAR(100) NOT NULL
);

-- =====================================================================
-- DATOS: categoria (9 filas)
-- =====================================================================
INSERT INTO categoria (idcategoria, nombre_categoria) VALUES
(1, 'Golosinas'),
(2, 'Ferreteria'),
(3, 'Calzado'),
(4, 'Productos de limpieza'),
(5, 'Electronica'),
(6, 'Celulares'),
(7, 'Telas'),
(8, 'Libros'),
(9, 'Bisuteria');

-- =====================================================================
-- DATOS: marca (9 filas)
-- =====================================================================
INSERT INTO marca (idmarca, nombre_marca) VALUES
(1, 'Saboy'),
(2, 'RS21'),
(3, 'Rindex'),
(4, 'Nintendo'),
(5, 'Nokia'),
(6, 'Telas nuevo sur'),
(7, 'Santillana'),
(8, 'Hermo'),
(9, 'EPA ferreteria');

-- =====================================================================
-- DATOS: producto (110 filas)
-- =====================================================================
INSERT INTO producto (idproducto, nombre_producto, precio, idcategoria, idmarca) VALUES
(1, 'producto 1', 100, 1, 1),
(2, 'producto 2', 200, 1, 1),
(3, 'producto 3', 300, 1, 1),
(4, 'producto 4', 400, 1, 1),
(5, 'producto 5', 500, 1, 1),
(6, 'producto 6', 600, 1, 1),
(7, 'producto 7', 700, 1, 1),
(8, 'producto 8', 800, 1, 1),
(11, 'producto 11', 2000, 1, 1),
(12, 'producto 12', 3000, 1, 1),
(13, 'producto 13', 4000, 1, 1),
(14, 'producto 14', 5000, 1, 1),
(15, 'producto 15', 6000, 1, 1),
(16, 'producto 16', 7000, 1, 1),
(17, 'producto 17', 8000, 1, 1),
(18, 'producto 18', 9000, 1, 1),
(19, 'producto 19', 10000, 1, 1),
(20, 'producto 20', 11000, 1, 1),
(21, 'producto 21', 12000, 1, 1),
(22, 'producto 22', 13000, 1, 1),
(23, 'producto 23', 14000, 1, 1),
(24, 'producto 24', 15000, 1, 1),
(25, 'producto 25', 16000, 1, 1),
(26, 'producto 26', 17000, 1, 1),
(27, 'producto 27', 18000, 1, 1),
(28, 'producto 28', 19000, 1, 1),
(29, 'producto 29', 20000, 1, 1),
(30, 'producto 30', 21000, 1, 1),
(31, 'producto 31', 220000, 1, 1),
(32, 'producto 32', 23000, 1, 1),
(33, 'producto 33', 24000, 1, 1),
(34, 'producto 34', 200, 1, 1),
(35, 'producto 35', 300, 1, 1),
(36, 'producto 36', 400, 1, 1),
(37, 'producto 37', 500, 1, 1),
(38, 'producto 38', 600, 1, 1),
(39, 'producto 39', 700, 1, 1),
(40, 'producto 40', 800, 1, 1),
(41, 'producto 41', 900, 1, 1),
(42, 'producto 42', 1000, 1, 1),
(43, 'producto 43', 2000, 1, 1),
(44, 'producto 44', 3000, 1, 1),
(45, 'producto 45', 4000, 1, 1),
(46, 'producto 46', 5000, 1, 1),
(47, 'producto 47', 6000, 1, 1),
(48, 'producto 48', 7000, 1, 1),
(49, 'producto 49', 8000, 1, 1),
(50, 'producto 50', 9000, 1, 1),
(51, 'producto 51', 10000, 1, 1),
(52, 'producto 52', 11000, 1, 1),
(53, 'producto 53', 12000, 1, 1),
(54, 'producto 54', 13000, 1, 1),
(55, 'producto 55', 14000, 1, 1),
(56, 'producto 56', 15000, 1, 1),
(57, 'producto 57', 16000, 1, 1),
(58, 'producto 58', 17000, 1, 1),
(59, 'producto 59', 18000, 1, 1),
(60, 'producto 60', 19000, 1, 1),
(61, 'producto 61', 20000, 1, 1),
(62, 'producto 62', 21000, 1, 1),
(63, 'producto 63', 220000, 1, 1),
(64, 'producto 64', 23000, 1, 1),
(65, 'producto 65', 24000, 1, 1),
(66, 'producto 66', 200, 1, 1),
(67, 'producto 67', 300, 1, 1),
(68, 'producto 68', 400, 1, 1),
(69, 'producto 69', 500, 1, 1),
(70, 'producto 70', 600, 1, 1),
(71, 'producto 71', 700, 1, 1),
(72, 'producto 72', 800, 1, 1),
(73, 'producto 73', 900, 1, 1),
(74, 'producto 74', 1000, 1, 1),
(75, 'producto 75', 2000, 1, 1),
(76, 'producto 76', 3000, 1, 1),
(77, 'producto 77', 4000, 1, 1),
(78, 'producto 78', 5000, 1, 1),
(79, 'producto 79', 6000, 1, 1),
(80, 'producto 80', 7000, 1, 1),
(81, 'producto 81', 8000, 1, 1),
(82, 'producto 82', 9000, 1, 1),
(83, 'producto 83', 10000, 1, 1),
(84, 'producto 84', 11000, 1, 1),
(85, 'producto 85', 12000, 1, 1),
(86, 'producto 86', 13000, 1, 1),
(87, 'producto 87', 14000, 1, 1),
(88, 'producto 88', 15000, 1, 1),
(89, 'producto 89', 16000, 1, 1),
(90, 'producto 90', 17000, 1, 1),
(91, 'producto 91', 18000, 1, 1),
(92, 'producto 92', 19000, 1, 1),
(93, 'producto 93', 20000, 1, 1),
(94, 'producto 94', 21000, 1, 1),
(95, 'producto 95', 220000, 1, 1),
(96, 'producto 96', 23000, 1, 1),
(97, 'producto 97', 24000, 1, 1),
(98, 'producto 98', 24000, 1, 1),
(99, 'producto 99', 24000, 1, 1),
(100, 'producto 100', 100000, 2, 2),
(101, 'producto 101', 35000, 5, 5),
(102, 'producto 102', 38000, 9, 5),
(103, 'producto 1 chocolate', 120, 1, 1),
(104, 'producto 2 chupetas', 210, 1, 1),
(116, 'nuevo producto', 10000, 3, 2),
(10, 'producto 10 cafe', 220, 1, 1),
(9, 'producto 9 refresco', 315, 1, 1),
(106, 'producto 108', 232, 2, 2),
(107, 'producto 109', 221, 2, 2),
(108, 'producto 110', 230, 1, 1),
(109, 'producto nuevo', 321, 1, 1),
(119, 'producto AABB', 45321, 2, 9);

-- =====================================================================
-- DATOS: usuarios (2 filas)
-- password: SHA-1 hex (ver Validaciones/DigestUtils en el código Java)
-- =====================================================================
INSERT INTO usuarios (idusuarios, nombre, apellido, sexo, correo, usuario, pass) VALUES
(1, 'nelson', 'marcano', 'Hombre', 'elchino@hotmail.com', 'nelson', '40bd001563085fc35165329ea1ff5c5ecbdbbeef'),
(2, 'usuario', 'usuario', 'Hombre', 'usuario@hotmail.com', 'usuario_prueba', '40bd001563085fc35165329ea1ff5c5ecbdbbeef');

-- =====================================================================
-- Ajustar las secuencias SERIAL al último id insertado, para que los
-- próximos INSERT hechos desde la aplicación (addProducto, registroUsuario)
-- no choquen con los ids ya existentes.
-- =====================================================================
SELECT setval('categoria_idcategoria_seq', (SELECT MAX(idcategoria) FROM categoria));
SELECT setval('marca_idmarca_seq',         (SELECT MAX(idmarca)     FROM marca));
SELECT setval('producto_idproducto_seq',   (SELECT MAX(idproducto)  FROM producto));
SELECT setval('usuarios_idusuarios_seq',   (SELECT MAX(idusuarios)  FROM usuarios));

COMMIT;