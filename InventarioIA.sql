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

-- Usuarios Mariana aqui las contraseñas son admin123 de ti, oscar y de mi y norris123 de lando y perez123 de sergio xd lo sale asi porque estan codificadas :)
INSERT INTO usuarios (id, nombre, username, password, rol, estado, fecha_creacion) VALUES 
(1, 'Jhanok Leon', 'jhanok_jefe', 'scrypt:32768:8:1$Kcx0w8WI32AwU5CR$ed3e75871b695780598816f199042b08332145e39660233088b939527ecb822c954a6316279930f78f85f341b80f1464455589a19c6298e3b48f6540b6e9273c', 'Jefe', 'Activo', '2026-04-12 18:50:17'),
(2, 'Marianna Mori', 'Mari_jefe', 'scrypt:32768:8:1$sdRkU0C3nwzDwePG$c75fe9871b695780598816f199042b08332145e39660233088b939527ecb822c954a6316279930f78f85f341b80f1464455589a19c6298e3b48f6540b6e9273c', 'Jefe', 'Activo', '2026-04-14 17:12:56'),
(3, 'Oscar Piastri', 'oscar_admin', 'scrypt:32768:8:1$uSAJ5VLhbiOjSDHh$e333f8b3c94f57c858e38d789061099e078028776610787e9c5e3f4e3c3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f', 'Administrador', 'Activo', '2026-04-13 00:34:13'),
(4, 'Lando Norris', 'norris_admin', 'scrypt:32768:8:1$fNUxtDKmXVJmC5tR$9365ea6216a69874e40283789061099e078028776610787e9c5e3f4e3c3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f', 'Administrador', 'Activo', '2026-04-13 01:04:34'),
(5, 'Sergio Perez', 'perez_vendedor', 'scrypt:32768:8:1$qvJ7wAlRKFe6mwzk$414fba0f21469e3a6c17f16f393d254b83b9c7924d623230a133f9154f2427a9296e832962257d298f65879a95393962657876a91c12e841804108876c12e5f5', 'Vendedor', 'Activo', '2026-04-12 21:56:44');

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

