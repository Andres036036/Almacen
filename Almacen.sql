drop database if exists almacen;
CREATE DATABASE almacen;
USE almacen;
CREATE TABLE usuarios(
idUsuario int primary key,
PrimerNombr varchar(25),
segundoNombr varchar(25),
PrimerApelli varchar(25),
SegundoApelli varchar(25),
Celular bigint,
FechaNacimi date,
Genero tinyint(1)
);
ALTER TABLE usuarios ADD correo varchar (30);
CREATE TABLE direccion(
idDreccion int primary key,
Barrio varchar(25),
DirecciCalle varchar (25),
DirecciNumero varchar (25),
Departamen varchar (25),
Pais varchar (25),
CodigoPostal smallint,
Ciudad varchar (25)
);
CREATE TABLE tipoDoc(
idDocumento int primary key auto_increment,
NombreDocu varchar (50)
);
CREATE TABLE factura(
idFactura int primary key auto_increment,
FechaHora datetime,
Total int,
Cambio mediumint,
NombreSuper varchar(40),
Celular bigint
);
CREATE TABLE Rol(
idRol int primary key,
NombreRol varchar (25)
);
CREATE TABLE TipoFormaDePago(
idFormPago int primary key,
NombFormPago varchar (25)
);
CREATE TABLE Productos(
idProductos int primary key auto_increment,
NombreProduc varchar(25),
Cantidad tinyint(150),
Valor int,
Descripcion varchar (50),
imagen mediumblob
);
CREATE TABLE TipoProduc(
idTipProduc int primary key auto_increment,
Aliment varchar(30),
Bebida varchar (30),
Limpieza varchar (30),
AseoPerson varchar (30),
Electrodomesti varchar (30),
tecnoligi varchar (30)
);
ALTER TABLE usuarios
ADD CONSTRAINT IdDocUsuarios
FOREIGN KEY (idUsuario) REFERENCES tipodoc(idDocumento);
ALTER TABLE direccion 
ADD CONSTRAINT IdDerecciUsuario
FOREIGN KEY (idDreccion) REFERENCES usuarios(idUsuario);
ALTER TABLE factura
ADD CONSTRAINT IdUsuariofactura
FOREIGN KEY (idfactura) REFERENCES usuarios(idUsuario);
ALTER TABLE factura
ADD CONSTRAINT IdPagofactura
FOREIGN KEY (idfactura) REFERENCES tipoformadepago(idFormPago);
ALTER TABLE productos
ADD CONSTRAINT idProductoTipoProd
FOREIGN KEY (idProductos) REFERENCES tipoproduc(idTipProduc);


