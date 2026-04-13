CREATE DATABASE InventarioIA;
USE InventarioIA;

CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL, 
    nombre VARCHAR(150) NOT NULL,
    id_categoria INT,
    precio_compra DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT DEFAULT 5,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_categoria FOREIGN KEY (id_categoria) 
        REFERENCES categorias(id) ON DELETE SET NULL
);

CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_venta_historico DECIMAL(10,2) NOT NULL,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_producto_venta FOREIGN KEY (id_producto) 
        REFERENCES productos(id) ON DELETE CASCADE
);

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol ENUM('Jefe', 'Administrador', 'Vendedor') NOT NULL DEFAULT 'Vendedor',
    estado ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE operaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT, 
    accion TEXT NOT NULL, 
    modulo VARCHAR(50), 
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuario_operacion FOREIGN KEY (id_usuario) 
        REFERENCES usuarios(id) ON DELETE SET NULL
);

INSERT INTO ventas (id_producto, cantidad, precio_venta_historico, fecha_venta) 
VALUES (1, 3, 750.00, '2026-04-06 14:30:00');

INSERT INTO ventas (id_producto, cantidad, precio_venta_historico, fecha_venta) 
VALUES (2, 1, 1900.00, '2026-04-08 10:15:00');

INSERT INTO ventas (id_producto, cantidad, precio_venta_historico, fecha_venta) 
VALUES (1, 2, 750.00, '2026-04-10 18:45:00');

SELECT * FROM productos;

DROP DATABASE InventarioIA;