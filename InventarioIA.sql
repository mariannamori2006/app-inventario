-- DROP DATABASE InventarioIA;
CREATE DATABASE InventarioIA;
USE InventarioIA;

CREATE TABLE Producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_actual INT NOT NULL,
    umbral_alerta INT DEFAULT 3 
);

CREATE TABLE Venta (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT,
    fecha DATE NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto) ON DELETE RESTRICT 
);

CREATE TABLE Entrada (
    id_entrada INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT,
    fecha DATE NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto) ON DELETE RESTRICT
);


INSERT INTO Producto (nombre, precio_venta, stock_actual, umbral_alerta)
VALUES ("Laptop HP", 2850, 80, 3);

-- ventas (Laptop HP)
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (1, "2026-01-01", 3);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (1, "2026-01-02", 5);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (1, "2026-01-03", 4);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (1, "2026-01-04", 6);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (1, "2026-01-05", 8);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (1, "2026-01-06", 2);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (1, "2026-01-07", 7);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (1, "2026-01-08", 5);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (1, "2026-01-09", 9);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (1, "2026-01-10", 4);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (1, "2026-01-11", 6);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (1, "2026-01-12", 3);

INSERT INTO Producto (nombre, precio_venta, stock_actual, umbral_alerta) 
VALUES ("Mouse Gamer Logitech", 120, 18, 3);


INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (2, "2026-01-13", 2);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (2, "2026-01-14", 4);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (2, "2026-01-15", 1);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (2, "2026-01-16", 2);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (2, "2026-01-17", 1);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (2, "2026-01-18", 2);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (2, "2026-01-19", 1);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (2, "2026-01-20", 2);


INSERT INTO Producto (nombre, precio_venta, stock_actual, umbral_alerta) 
VALUES ("Audifonos HyperX", 350, 30, 3);

-- Historial de 10 ventas de Audífonos (ID 3)
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (3, "2026-02-01", 2);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (3, "2026-02-02", 1);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (3, "2026-02-03", 4);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (3, "2026-02-04", 1);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (3, "2026-02-05", 2);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (3, "2026-02-06", 5);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (3, "2026-02-07", 1);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (3, "2026-02-08", 3);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (3, "2026-02-09", 2);
INSERT INTO Venta (id_producto, fecha, cantidad) VALUES (3, "2026-02-10", 2);