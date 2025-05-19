DROP DATABASE IF EXISTS almacen;
CREATE DATABASE almacen;
USE almacen;
CREATE TABLE tipoDocumento (
    idDocumento INT PRIMARY KEY AUTO_INCREMENT,
    NombreDocu VARCHAR(50)
);
CREATE TABLE Rol (
    idRol INT PRIMARY KEY AUTO_INCREMENT,
    NombreRol VARCHAR(25)
);
CREATE TABLE usuarios (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    PrimerNombre VARCHAR(25),
    SegundoNombre VARCHAR(25),
    PrimerApellido VARCHAR(25),
    SegundoApellido VARCHAR(25),
    Celular BIGINT,
    FechaNacimiento DATE,
    Genero TINYINT(1),
    correo VARCHAR(30),
    idDocumento INT,
    idRol INT,
    FOREIGN KEY (idDocumento) REFERENCES tipoDocumento(idDocumento),
    FOREIGN KEY (idRol) REFERENCES Rol(idRol)
);
CREATE TABLE direccion (
    idDireccion INT PRIMARY KEY AUTO_INCREMENT,
    Barrio VARCHAR(25),
    DireccionCalle VARCHAR(25),
    DireccionNumero VARCHAR(25),
    Departamento VARCHAR(25),
    Pais VARCHAR(25),
    CodigoPostal INT,  -- CAMBIADO DE SMALLINT A INT
    Ciudad VARCHAR(25),
    idUsuario INT,
    FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
);
CREATE TABLE TipoFormaDePago (
    idFormPago INT PRIMARY KEY AUTO_INCREMENT,
    NombFormPago VARCHAR(25)
);
CREATE TABLE factura (
    idFactura INT PRIMARY KEY AUTO_INCREMENT,
    FechaHora DATETIME,
    Total INT,
    Cambio MEDIUMINT,
    NombreSuper VARCHAR(40),
    Celular BIGINT,
    idUsuario INT,
    idFormPago INT,
    FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario),
    FOREIGN KEY (idFormPago) REFERENCES TipoFormaDePago(idFormPago)
);
CREATE TABLE TipoProducto (
    idTipProduc INT PRIMARY KEY AUTO_INCREMENT,
    Categoria VARCHAR(30)
);
CREATE TABLE Marca (
    idMarca INT PRIMARY KEY AUTO_INCREMENT,
    NombreMarca VARCHAR(30)
);
CREATE TABLE Presentacion (
    idPresentacion INT PRIMARY KEY AUTO_INCREMENT,
    Descripcion VARCHAR(30)
);
CREATE TABLE Productos (
    idProductos INT PRIMARY KEY AUTO_INCREMENT,
    NombreProduc VARCHAR(25),
    Cantidad TINYINT UNSIGNED,
    Valor INT,
    Descripcion VARCHAR(50),
    idTipProduc INT,
    idMarca INT,
    idPresentacion INT,
    FOREIGN KEY (idTipProduc) REFERENCES TipoProducto(idTipProduc),
    FOREIGN KEY (idMarca) REFERENCES Marca(idMarca),
    FOREIGN KEY (idPresentacion) REFERENCES Presentacion(idPresentacion)
);
CREATE TABLE detalleFactura (
    idDetalle INT PRIMARY KEY AUTO_INCREMENT,
    idFactura INT,
    idProductos INT,
    Cantidad INT UNSIGNED,
    PrecioUnitario INT,
    Subtotal INT,
    FOREIGN KEY (idFactura) REFERENCES factura(idFactura),
    FOREIGN KEY (idProductos) REFERENCES Productos(idProductos)
);
CREATE TABLE Inventario (
    idInventario INT PRIMARY KEY AUTO_INCREMENT,
    idProductos INT,
    StockActual INT UNSIGNED,
    FechaActualizacion DATETIME,
    FOREIGN KEY (idProductos) REFERENCES Productos(idProductos)
);
INSERT INTO tipoDocumento (NombreDocu) VALUES 
("TI"), ("CC"), ("CE"), ("RC"), ("PAS");

INSERT INTO Rol (NombreRol) VALUES 
("Administrador"), ("Editor de productos"), ("Encargado de tienda"), ("Dependiente"), ("Gestor de pedidos");

INSERT INTO TipoFormaDePago (NombFormPago) VALUES 
("Efectivo"), ("PSE"), ("Tarjeta"), ("BRE-B");

INSERT INTO TipoProducto (Categoria) VALUES 
("Alimentos"), ("Bebidas"), ("Ropa"), ("Belleza"), ("Electrodomésticos"), ("Tecnología");

INSERT INTO Marca (NombreMarca) VALUES 
("Nestlé"), ("Coca-Cola"), ("Postobón"), ("Apple"), ("Samsung");

INSERT INTO Presentacion (Descripcion) VALUES 
("Unidad"), ("Litro"), ("Caja"), ("Paquete"), ("Botella");

INSERT INTO usuarios 
(PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, Celular, FechaNacimiento, Genero, correo, idDocumento, idRol) 
VALUES
("Carlos", "Andrés", "Pérez", "Gómez", 3201112233, '1990-05-15', 1, "carlos@gmail.com", 2, 1),
("Laura", "María", "Rodríguez", "Torres", 3115557788, '1992-08-21', 0, "laura@gmail.com", 1, 4),
("Juan", "José", "Martínez", "Díaz", 3001122334, '1985-12-30', 1, "juan@gmail.com", 2, 2),
("Camila", "Andrea", "López", "Ruiz", 3179995566, '1998-03-10', 0, "camila@gmail.com", 1, 5),
("Mateo", "David", "García", "Moreno", 3133334444, '2000-07-22', 1, "mateo@gmail.com", 3, 3);

INSERT INTO direccion 
(Barrio, DireccionCalle, DireccionNumero, Departamento, Pais, CodigoPostal, Ciudad, idUsuario) 
VALUES
("Centro", "Carrera 7", "123", "Cundinamarca", "Colombia", 110111, "Bogotá", 1),
("Laureles", "Calle 10", "55", "Antioquia", "Colombia", 50010, "Medellín", 2),
("San Fernando", "Av 3N", "23A", "Valle", "Colombia", 760001, "Cali", 3),
("El Prado", "Calle 8", "88", "Atlántico", "Colombia", 80001, "Barranquilla", 4),
("Poblado", "Carrera 43A", "15", "Antioquia", "Colombia", 50012, "Medellín", 5);

INSERT INTO productos 
(NombreProduc, Cantidad, Valor, Descripcion, idTipProduc, idMarca, idPresentacion) 
VALUES
("Chocolatina Jet", 30, 2750, "Chocolate clásico colombiano.", 1, 1, 1),
("Coca-Cola 1L", 50, 3500, "Bebida gaseosa en botella plástica.", 2, 2, 2),
("Camisa Polo", 20, 45000, "Camisa algodón talla M.", 3, 1, 3),
("Shampoo Pantene", 40, 15000, "Para cabello liso 400ml.", 4, 1, 5),
("Smartphone Galaxy", 10, 1200000, "Samsung A34 Dual SIM.", 6, 5, 3);

INSERT INTO factura 
(FechaHora, Total, Cambio, NombreSuper, Celular, idUsuario, idFormPago) 
VALUES
('2024-05-01 10:30:00', 2750, 250, 'Supermercado El Buen Precio', 3102223344, 1, 1),
('2024-05-01 11:15:00', 3500, 0, 'Supermercado El Buen Precio', 3114445566, 2, 3),
('2024-05-02 13:45:00', 45000, 0, 'Supermercado El Buen Precio', 3123456789, 3, 2),
('2024-05-02 14:20:00', 15000, 0, 'Supermercado El Buen Precio', 3139876543, 4, 1),
('2024-05-03 15:00:00', 1200000, 0, 'Supermercado El Buen Precio', 3145678912, 5, 3);

INSERT INTO detalleFactura 
(idFactura, idProductos, Cantidad, PrecioUnitario, Subtotal) 
VALUES
(1, 1, 1, 2750, 2750),
(2, 2, 1, 3500, 3500),
(3, 3, 1, 45000, 45000),
(4, 4, 1, 15000, 15000),
(5, 5, 1, 1200000, 1200000);

INSERT INTO Inventario 
(idProductos, StockActual, FechaActualizacion) 
VALUES
(1, 29, NOW()),
(2, 49, NOW()),
(3, 19, NOW()),
(4, 39, NOW()),
(5, 9, NOW());