create database if not exists IntegralProject;
create table Clientes (
clienteID int primary key auto_increment unique,
nombre varchar(25) not null,
apellido varchar(25) not null,
cuit char(25) not null unique,
direccion varchar(50) not null,
comentarios varchar(50)
);

create table Articulos (
articuloID int primary key auto_increment unique,
nombre varchar(50),
precio double,
stock int
);

create table Facturas (
facturaID int primary key auto_increment unique,
letra char(1) not null,
numero int not null,
clienteID int not null,
fecha date not null,
monto double,
constraint fk_clienteID foreign key(clienteID) references Clientes(clienteID)
);

create table Detalles (
detalleID int primary key auto_increment unique,
articuloID int not null,
facturaID int not null,
cantidad int,
constraint fk_articuloID foreign key(articuloID) references Articulos(articuloID),
constraint fk_facturaID foreign key(facturaID) references Facturas(facturaID)
);

create table Localidades (
localidadID int primary key auto_increment unique,
nombre varchar(40) not null,
codigoPostal varchar(10) not null unique,
provincia varchar(20) not null
);

#Muestra todas las facturas de un cliente en particular
select f.*, c.nombre, c.apellido
from Clientes c
join Facturas f on f.clienteID = c.clienteID
where c.clienteID = 3;

#Muestra los clientes que no tienen comentarios
select *
from Clientes c
where c.comentarios is NULL;

#Muestra todos los articulos de mayor precio a menor
select *
from Articulos a
order by a.precio desc;

#Muestra todos los detalles de una factura en particular (detalles de Detalles, detalles de Articulos, detalles de Facturas y detalles de Clientes)
select d.*, a.*, f.*, c.*
from Detalles d
join Facturas f on f.facturaID = d.facturaID
join Articulos a on a.articuloID = d.articuloID
join Clientes c on c.clienteID = f.clienteID
where f.facturaID = 12;

show databases;
show tables;

#Muestra todos los clientes
select * from Clientes;

#Muestra todas las facturas
select * from Facturas;

#Muestra todos los articulos
select * from Articulos;

#Muestra todos los detalles
select * from detalles;

#Muestra todas las localidades
select * from Localidades;

describe Clientes;

alter table Facturas modify monto double unsigned;
alter table Articulos modify nombre varchar(70);
alter table Articulos modify precio double unsigned not null;
alter table Articulos modify stock int unsigned not null;
alter table Clientes modify nombre varchar(30) not null;
alter table Clientes modify apellido varchar(35) not null;
alter table Clientes change comentarios observaciones varchar(255);
alter table Clientes add column localidadID int, add constraint fk_localidadID foreign key (localidadID) references Localidades(localidadID);


/*
INSERT INTO Clientes (nombre, apellido, cuit, direccion, comentarios) VALUES
('Carlos', 'Pérez', '20-12345678-1', 'Av. Corrientes 1234', 'Cliente frecuente'),
('Lucía', 'Gómez', '27-87654321-2', 'Calle Falsa 123', 'Pago en efectivo'),
('María', 'Rodríguez', '23-45678901-3', 'Mitre 789', 'Sin comentarios'),
('Juan', 'López', '25-23456789-4', 'Belgrano 456', 'Solicita factura A'),
('Ana', 'Martínez', '30-98765432-5', 'Rivadavia 987', NULL);
*/
/*
INSERT INTO Articulos (nombre, precio, stock) VALUES
('Teclado mecánico', 15000.00, 25),
('Mouse gamer', 8500.00, 40),
('Monitor 24 pulgadas', 60000.00, 15),
('Notebook i5', 350000.00, 8),
('Auriculares Bluetooth', 20000.00, 30);
*/
/*
INSERT INTO Facturas (letra, numero, clienteID, fecha, monto) VALUES
('A', 1001, 1, '2025-08-01', 75000.00),
('B', 1002, 2, '2025-08-05', 8500.00),
('A', 1003, 3, '2025-08-10', 410000.00),
('B', 1004, 4, '2025-08-15', 35000.00),
('A', 1005, 5, '2025-08-20', 20000.00);
*/
/*
INSERT INTO Detalles (articuloID, facturaID, cantidad) VALUES
(1, 1, 2),  -- 2 teclados para factura 1001
(2, 1, 1),  -- 1 mouse para factura 1001
(2, 2, 1),  -- 1 mouse para factura 1002
(4, 3, 1),  -- 1 notebook para factura 1003
(1, 4, 1),  -- 1 teclado para factura 1004
(5, 5, 1);  -- 1 auricular para factura 1005
*/
/*
INSERT INTO Facturas (letra, numero, clienteID, fecha, monto) VALUES
('A', 1006, 2, '2025-08-22', 40000.00),
('B', 1007, 1, '2025-08-23', 13500.00),
('F', 1008, 3, '2025-08-24', 120000.00),
('B', 1009, 4, '2025-08-25', 30000.00),
('A', 1010, 5, '2025-08-26', 19000.00),
('V', 1011, 1, '2025-08-26', 78500.00),
('Z', 1012, 2, '2025-08-27', 160000.00),
('U', 1013, 3, '2025-08-27', 58000.00),
('K', 1014, 4, '2025-08-28', 45000.00),
('Q', 1015, 5, '2025-08-28', 25000.00);
*/
/*
INSERT INTO Detalles (articuloID, facturaID, cantidad) VALUES
(3, 6, 1),  -- Monitor para factura 1006
(1, 7, 1),  -- Teclado para factura 1007
(2, 7, 1),  -- Mouse para factura 1007
(3, 8, 2),  -- 2 monitores para factura 1008
(5, 9, 3),  -- 3 auriculares para factura 1009
(2, 10, 1), -- Mouse para factura 1010
(4, 11, 1), -- Notebook para factura 1011
(5, 11, 1), -- Auriculares para factura 1011
(4, 12, 1), -- Notebook para factura 1012
(1, 12, 1), -- Teclado para factura 1012
(3, 13, 1), -- Monitor para factura 1013
(2, 13, 2), -- 2 mouse para factura 1013
(5, 14, 2), -- 2 auriculares para factura 1014
(1, 14, 1), -- Teclado para factura 1014
(2, 15, 1); -- Mouse para factura 1015
*/
/*aa
INSERT INTO Clientes (nombre, apellido, cuit, direccion, observaciones, localidadID) VALUES
("Santiago", "González", "23-24582359-9", "Uriburu 558 - 7ºA", "VIP", 3),
("Gloria", "Fernández", "23-35965852-5", "Constitución 323", "GBA", 1),
("Gonzalo", "López", "23-33587416-0", "Arias 2624", "GBA", 5),
("Carlos", "García", "23-42321230-9", "Pasteur 322 - 2ºC", "VIP", 2),
("Micaela", "Altieri", "23-22885566-5", "Santamarina 1255", "GBA", 4);
*/
/*
insert into Localidades(localidadID, nombre, codigoPostal, provincia) values
(1, "CABA", 1000, "Buenos Aires"),
(2, "Rosario", 2000, "Santa Fe"),
(3, "Cordoba", 5000, "Cordoba"),
(4, "San Miguel de Tucuman", 4000, "Tucuman"),
(5, "Neuquen", 8300, "Neuquen");
*/
/*
insert into Articulos(nombre, precio, stock) values
("Webcam con Microfono Plug & Play", 513.35, 39),
("Apple AirPods Pro", 979.75, 152),
("Lavasecarropas Automatico Samsung", 1589.50, 12),
("Gloria Trevi / Gloria / CD+DVD", 2385.70, 2);
*/