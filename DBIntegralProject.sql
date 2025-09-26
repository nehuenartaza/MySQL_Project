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

alter table Articulos add column categoriaID int not null default 1;
alter table Articulos add constraint fk_categoriaID foreign key (categoriaID) references Categorias(categoriaID);

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

create table Categorias (
categoriaID int primary key auto_increment,
nombre varchar(50) not null,
descripcion varchar(255) not null
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

#Muestra todos los articulos + categorias
select articuloID as id,
nombre,
precio,
stock,
null as codPostal,
null as provincia,
"articulo" as tipo
from Articulos
union
select localidadID as id,
nombre,
null as precio,
null as stock,
codigoPostal as codPostal,
provincia,
"Ciudad" as tipo
from Localidades;

#Muestra todos los clientes + localidades
select clienteID as id,
nombre,
apellido,
cuit,
direccion,
observaciones,
null as codPostal,
null as provincia
from Clientes
union
select localidadID as id,
nombre,
null as apellido,
null as cuit,
null as direccion,
null as observaciones,
codigoPostal as codPostal,
provincia
from Localidades;

#Muestra todos los clientes + localidades, solo aquellos con apellido inicial G y localidades de Bs As
select clienteID as id,
nombre,
apellido,
cuit,
direccion,
observaciones,
null as codPostal,
null as provincia
from Clientes
where apellido like "G%"
union
select localidadID as id,
nombre,
null as apellido,
null as cuit,
null as direccion,
null as observaciones,
codigoPostal as codPostal,
provincia
from Localidades
where provincia = "Buenos Aires";

#Muestra los articulos con mas de 50 stock + Detalles
select articuloID as id,
nombre,
precio,
stock,
categoriaID,
null as articuloID,
null as facturaID,
null as cantidad
from Articulos
where stock > 50
union
select detalleID as id,
null as nombre,
null as precio,
null as stock,
null as categoriaID,
articuloID,
facturaID,
cantidad
from Detalles
where articuloID in (select articuloID from Articulos where stock > 50);

#Muestra todos los datos de los clientes + ciudad en las que viven
select c.*,
l.nombre as ciudad,
l.codigoPostal,
l.provincia
from Clientes as c
join Localidades as l on c.localidadID = l.localidadID;

#Muestra todas las Facturas + Detalles de los articulos asociados a cada una de las Facturas (no hace falta mostrar los Articulos)
select f.FacturaID,
f.Letra,
f.Numero,
f.Fecha,
f.Monto,
d.ArticuloID,
d.Cantidad
from Facturas as f
join Detalles as d on f.facturaID = d.facturaID;

#Muestra todas las Facturas + Detalles de los articulos asociados a cada una de las Facturas + nombre de los articulos
select f.FacturaID,
f.Letra,
f.Numero,
f.Fecha,
f.Monto,
d.ArticuloID,
a.nombre,
d.Cantidad
from Facturas as f
join Detalles as d on f.facturaID = d.facturaID
join Articulos as a on d.articuloID = a.articuloID;

#Muestra todas las facturas de los clientes con apellido García
select f.*
from Facturas as f
join Clientes c on f.clienteID = c.clienteID
where c.apellido like "%García%";

#Muestra todos los articulos comprados por los clientes con apellido López
select a.*,
c.apellido,
c.clienteID
from Articulos as a
join Detalles as d on a.articuloID = d.articuloID
join Facturas as f on d.facturaID = f.facturaID
join Clientes as c on f.clienteID = c.clienteID
where c.apellido like "%López%";

#Muestra todos los clientes, juntando el nombre y el apellido en una misma columna
select clienteID,
direccion,
concat(nombre, '-', apellido) as nombreCompleto
from Clientes;

#Lo mismo que la query anterior pero usando concat_ws
select clienteID,
direccion,
concat_ws('-', nombre, apellido) as nombreCompleto
from Clientes;

#Lo mismo que la query anterior pero mostrando en mayúsculas el valor cargado en nombre
select clienteID,
direccion,
upper(nombre) as nombre
from Clientes;

#Muestra los nombres de los clientes, y la inicial del nombre en una nueva columna
select nombre,
left(nombre, 1) as inicial
from Clientes;

#Muestra todas las facturas además de una columna que calcula el precio extra por el iva, mostrando como mucho 2 decimales
select *,
round(monto * 0.21, 2) as extraIVA
from Facturas;

#Lo mismo que la query anterior pero sumando el iva al precio final
select *,
round(monto * 1.21, 2) as precioNeto
from Facturas;

#Lo mismo que la query anterior pero redondeando el precioNeto a favor del cliente
select *,
floor(round(monto * 1.21, 2)) as favorDelCliente
from Facturas;

#Muestra todas las facturas efectuadas en 2021
select *
from Facturas
having year(fecha) = 2021;

#Muestra todas las facturas efectuadas en marzo o septiembre del 2021
select *
from (select * from Facturas having year(fecha) = 2021) as Facturas2021
having month(Facturas2021.fecha) = 3 or month(Facturas2021.fecha) = 9;

#Muestra las facturas efectuadas el primer día de cualquier mes cualquier año
select *
from Facturas
having day(fecha) = 1;

#Muestra todas las facturas, además de una columna que muestra cuantos días pasaron de esa factura
select *,
datediff(curdate(), fecha) as dias
from Facturas;

#Lo mismo que la query anterior, además de una columna que muestra el nombre del día
select *,
datediff(curdate(), fecha) as dias,
dayname(fecha) as nombreDia
from Facturas;

#Lo mismo que la query anterior, además de una columna que muestra el día del año
select *,
datediff(curdate(), fecha) as dias,
dayname(fecha) as nombreDia,
dayofyear(fecha) as diaDelAnio
from Facturas;

#Lo mismo que la query anterior, además de una columna que muestra el primer vencimiento de la factura (30 días luego de la emisión)
select *,
datediff(curdate(), fecha) as dias,
dayname(fecha) as nombreDia,
dayofyear(fecha) as diaDelAnio,
adddate(fecha, interval 30 day) as vencimiento_1
from Facturas;

#Lo mismo que la query anterior, además de una columna que muestra el segundo vencimiento de la factura (2 meses luego)
select *,
datediff(curdate(), fecha) as dias,
dayname(fecha) as nombreDia,
dayofyear(fecha) as diaDelAnio,
adddate(fecha, interval 30 day) as vencimiento_1,
adddate(fecha, interval 2 month) as vencimiento_2
from Facturas;

/*
update Facturas
set clienteID = 9
where facturaID = 20;
*/
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
/*
INSERT INTO Clientes (nombre, apellido, cuit, direccion, observaciones, localidadID) VALUES
("Santiago", "González", "23-24582359-9", "Uriburu 558 - 7ºA", "VIP", 3),
("Gloria", "Fernández", "23-35965852-5", "Constitución 323", "GBA", 1),
("Gonzalo", "López", "23-33587416-0", "Arias 2624", "GBA", 5),
("Carlos", "García", "23-42321230-9", "Pasteur 322 - 2ºC", "VIP", 2),
("Micaela", "Altieri", "23-22885566-5", "Santamarina 1255", "GBA", 4);
*/
/*
insert into Clientes (nombre, apellido, cuit, direccion, observaciones, localidadID) VALUES
("Elias", "Geronimo", "52-35105893-2", "Calle Ficticia 5293", null, 1);
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
/*
insert into Articulos(nombre, precio, stock, categoriaID) values
("iCorn 19", 1200000, 94, 7);
*/
/*
insert into Facturas(letra, numero, clienteID, fecha, monto) values
("A", 28, 2, "2021-03-18", 1589.50),
("A", 39, 4, "2021-04-12", 979.75),
("B", 8, 3, "2021-04-25", 512.35),
("B", 12, 5, "2021-05-01", 2385.70),
("B", 19, 5, "2022-05-26", 979.75);
*/
/*
INSERT INTO Categorias (nombre, descripcion) VALUES
('Hardware', 'Componentes físicos como procesadores, memorias, discos duros y periféricos.'),
('Software', 'Programas y aplicaciones desarrollados para diferentes plataformas.'),
('Servicios en la Nube', 'Soluciones de almacenamiento, procesamiento y servicios basados en la nube.'),
('Ciberseguridad', 'Productos y servicios para proteger sistemas y datos contra amenazas digitales.'),
('Inteligencia Artificial', 'Desarrollo y aplicación de modelos de IA y aprendizaje automático.'),
('Desarrollo Web', 'Diseño y programación de sitios y aplicaciones web.'),
('Dispositivos Móviles', 'Smartphones, tablets y accesorios relacionados.'),
('IoT (Internet de las Cosas)', 'Dispositivos conectados y automatización del hogar y la industria.'),
('Realidad Aumentada / Virtual', 'Soluciones para experiencias inmersivas en RA y RV.'),
('Consultoría Tecnológica', 'Servicios de asesoría en implementación y transformación digital.');
*/
