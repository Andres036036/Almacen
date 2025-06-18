CREATE DATABASE IF NOT EXISTS TiendaOnline
CHARACTER SET utf8mb4
COLLATE utf8mb4_spanish_ci;
USE TiendaOnline;

CREATE TABLE IF NOT EXISTS cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(15),
    direccion VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL
);

CREATE TABLE IF NOT EXISTS pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE TABLE IF NOT EXISTS detalle_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedido(id),
    FOREIGN KEY (producto_id) REFERENCES producto(id)
);

CREATE TABLE IF NOT EXISTS auditoria_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    cliente_id INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    accion VARCHAR(50)
);

DELIMITER $$
CREATE FUNCTION CalcularTotalPedido(pedido_id INT)
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(p.precio * dp.cantidad)
    INTO total
    FROM detalle_pedido dp
    JOIN producto p ON dp.producto_id = p.id
    WHERE dp.pedido_id = pedido_id;
    RETURN IFNULL(total, 0.00);
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER DescontarStock
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE producto
    SET stock = stock - NEW.cantidad
    WHERE id = NEW.producto_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER RegistrarAuditoriaPedido
AFTER INSERT ON pedido
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_pedidos (pedido_id, cliente_id, accion)
    VALUES (NEW.id, NEW.cliente_id, 'Pedido registrado');
END$$
DELIMITER ;

CREATE VIEW VistaPedidos AS
SELECT p.id, p.cliente_id, p.fecha,
       CalcularTotalPedido(p.id) AS total
FROM pedido p;

DELIMITER $$
CREATE PROCEDURE RegistrarPedido(cliente_id INT)
BEGIN
    DECLARE pedido_id INT;
    INSERT INTO pedido (cliente_id)
    VALUES (cliente_id);
    SET pedido_id = LAST_INSERT_ID();
END$$
DELIMITER ;

-- ejemplo
ALTER TABLE cliente MODIFY direccion VARBINARY(255);

INSERT INTO cliente (nombre, correo_electronico, telefono, direccion)
VALUES
('Pedro', 'juan123@gmail.com', '123456789', hex(AES_ENCRYPT('Calle siempre vivía', 'fgghhjjk'))),
('Juan Pérez', 'juan.perez@example.com', '987654321', hex(AES_ENCRYPT('Calle siempre vivía', 'fgghhjjk'))),
('María García', 'maria.garcia@example.com', '555123456', hex(AES_ENCRYPT('Calle siempre vivía', 'fgghhjjk')));

INSERT INTO producto (nombre, descripcion, precio, stock)
VALUES
('arroz roa – 500g', 'Tipo de Arroz: Arroz blanco de grano largo. Textura: Suelto y esponjoso al cocinar.', 100.00, 50),
('Leche Entera Alqueria 1100ml', 'Calidad y frescura: Alquería se enfoca en la calidad de su leche, asegurando un producto 
fresco y nutritivo.', 200.00, 30);

CALL RegistrarPedido(1);

INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad)
VALUES
    (1, 1, 2),
    (1, 2, 1);
    
UPDATE pedido
SET total = CalcularTotalPedido(1)
WHERE id = 1;

SELECT id, nombre, correo_electronico, telefono,CAST(AES_DECRYPT(UNHEX(direccion), 'fgghhjjk') AS CHAR) AS direccion
FROM cliente;

select * from cliente;
SELECT * FROM VistaPedidos;
SELECT * FROM auditoria_pedidos;
SELECT * FROM producto;

drop database tiendaonline;