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

-- agregare esto porque me acorde que tu no tendras los datos que yo tengo asi que mejor lo pongo todo

-- Categorías
INSERT INTO categorias (id, nombre) VALUES 
(1, 'Electrónica'),
(2, 'Accesorios');

-- Usuarios Mariana aqui las contraseñas son admin123 de todos  :)
--esto desactivara las claves foraneas pero si no quieres
-- puedes solamente borrar todo el script y crea uno desde 0 con DROP DATABASE InventarioIA;
SET FOREIGN_KEY_CHECKS = 0; 


TRUNCATE TABLE operaciones;
TRUNCATE TABLE usuarios;

SET FOREIGN_KEY_CHECKS = 1; -- esto las activa de nuevo

INSERT INTO usuarios (id, nombre, username, password, rol, estado, fecha_creacion) VALUES 
(1, 'Jhanok Leon', 'jhanok_jefe', 'scrypt:32768:8:1$sdRkU0C3nwzDwePG$c75fe6945af111e5afc9f7bdf10c4eaa59725e29687c634a7988c5dd3125589d80a7a86d28a158094adc2a32d5a78b988eab0fa94c7b9d30062213a4f1059618', 'Jefe', 'Activo', NOW()),
(2, 'Marianna Mori', 'mari_jefe', 'scrypt:32768:8:1$sdRkU0C3nwzDwePG$c75fe6945af111e5afc9f7bdf10c4eaa59725e29687c634a7988c5dd3125589d80a7a86d28a158094adc2a32d5a78b988eab0fa94c7b9d30062213a4f1059618', 'Jefe', 'Activo', NOW()),
(3, 'Oscar Piastri', 'oscar_admin', 'scrypt:32768:8:1$sdRkU0C3nwzDwePG$c75fe6945af111e5afc9f7bdf10c4eaa59725e29687c634a7988c5dd3125589d80a7a86d28a158094adc2a32d5a78b988eab0fa94c7b9d30062213a4f1059618', 'Administrador', 'Activo', NOW()),
(4, 'Lando Norris', 'lando_admin', 'scrypt:32768:8:1$sdRkU0C3nwzDwePG$c75fe6945af111e5afc9f7bdf10c4eaa59725e29687c634a7988c5dd3125589d80a7a86d28a158094adc2a32d5a78b988eab0fa94c7b9d30062213a4f1059618', 'Administrador', 'Activo', NOW()),
(5, 'Sergio Perez', 'checo_vendedor', 'scrypt:32768:8:1$sdRkU0C3nwzDwePG$c75fe6945af111e5afc9f7bdf10c4eaa59725e29687c634a7988c5dd3125589d80a7a86d28a158094adc2a32d5a78b988eab0fa94c7b9d30062213a4f1059618', 'Vendedor', 'Activo', NOW());

-- Productos
INSERT INTO productos (id, codigo, nombre, id_categoria, precio_compra, precio_venta, stock_actual, stock_minimo, fecha_registro) VALUES 
(1, 'PROD-0001', 'Smartphone Samsung Galaxy A14', 1, 600.00, 750.00, 33, 5, '2026-04-11 00:32:14'),
(2, 'PROD-0002', 'Laptop Lenovo IdeaPad 3', 1, 1500.00, 1900.00, 30, 5, '2026-04-11 00:33:15'),
(3, 'PROD-0003', 'Mouse Inalámbrico Logitech M185', 2, 25.00, 45.00, 145, 5, '2026-04-11 00:33:46');

-- Historial de Ventas
INSERT INTO ventas (id_producto, cantidad, precio_venta_historico, fecha_venta) VALUES 
(1, 1, 750.00, '2026-04-11 11:31:40'),
(3, 3, 45.00, '2026-04-11 11:40:56'),
(1, 1, 750.00, '2026-04-11 11:42:49'),
(1, 13, 750.00, '2026-04-11 11:44:52'),
(3, 2, 45.00, '2026-04-11 15:16:46'),
(1, 3, 750.00, '2026-04-06 14:30:00'),
(2, 1, 1900.00, '2026-04-08 10:15:00'),
(1, 2, 750.00, '2026-04-10 18:45:00'),
(1, 2, 750.00, '2026-04-13 08:51:55');

