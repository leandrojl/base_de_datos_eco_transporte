create database if not exists eco_transporte_db;
use eco_transporte_db;

create table bicicleta(
id int auto_increment,
rodado int not null,
marca int not null,
constraint pk_bicicleta primary key (id)
);

show create table bicicleta;

ALTER TABLE bicicleta
MODIFY COLUMN marca varchar(50) NULL;

select * from bicicleta;

alter table bicicleta auto_increment = 1;

insert into bicicleta
(id,rodado,marca)
values (101,28,"moovit"),(102,28,"tesla"),(103,28,"peugeot");

insert into bicicleta
(id,rodado,marca)
values (1,28,"moovit");

insert into bicicleta
(rodado,marca)
values (28,"bikerz");

insert into bicicleta
(rodado,marca)
values (28,"bikerzt");

create table casco(
idBici int,
nro_casco int,
talle varchar(5) not null,
constraint pk_casco primary key (idBici,nro_casco),
constraint fk_bicicleta foreign key(idBici) references bicicleta(id));




create table accesorio(
cod int auto_increment,
nombre varchar(50) not null,
personalizado varchar(50) not null,
constraint pk_accesorio primary key (cod)
);

create table estacion(
cod int auto_increment,
nombre varchar(50) not null,
horario time not null, /*'HH-MM-SS'*/
ubicacion varchar(50) not null,
constraint pk_estacion primary key (cod)

);

create table vecino(
tipodoc varchar(5) not null,
nro_doc int not null,
nombre varchar(50) not null,
direccion varchar(100) not null,
foto blob,
constraint pk_vecino primary key(tipodoc,nro_doc)
);

ALTER TABLE vecino
MODIFY COLUMN foto BLOB NULL;


create table tiene(
idBici int,
codAcc int,
constraint pk_tiene primary key(idBici, codAcc),
constraint fk_bicicleta_tiene foreign key(idBici) references bicicleta(id),
constraint fk_accesorio_tiene foreign key(codAcc) references accesorio(cod)
);

create table operacion(
id int,
fecha_hora date not null,
codEstacion int not null,
idBici int not null,
tipo varchar(50) not null,
tipodoc varchar(5) not null,
nrodoc int not null,
constraint pk_operacion primary key (id),
constraint fk_estacion_operacion foreign key (codEstacion) references estacion(cod),
constraint fk_bicicleta_operacion foreign key (idBici) references bicicleta(id),
constraint fk_vecino_operacion foreign key (tipodoc, nrodoc) references vecino(tipodoc,nro_doc)
);

-- Insertar dos registros para una tabla a elección, que tengan más de 2 campos.

insert into vecino
(tipodoc,nro_doc,nombre,direccion,foto)
values ("dni",10990190,"tupac","alberdi 545", null),("dni",10990191,"choufa","alberdi 745", null);

-- Eliminar todos los cascos del rango de bicicletas con id=101 a id=123, que sean talle P.
delete from casco c
where idBici between 101 and 123
and talle like "P";

select * from bicicleta;


insert into casco
(idBici,nro_casco,talle)
values (102,1,"P");

select * from casco;

select * from vecino;

-- Actualizar todos los accesorios que contengan personalizado ‘MVK-’ a ‘ECO RRR’.
-- cuando dice CONTENGA se utiliza '%MVK-%'

update accesorio
set personalizado = "ECO RRR"
where personalizado = "%MVK-%";

select * from accesorio;

show create table accesorio;

insert into accesorio
(cod,nombre,personalizado)
values (1,"Luz", "MVK-"),(2,"Camara", "MVK-"),(3,"Bocina", "MVK-");

-- a. Listar las bicis que tienen asiento para niño y cuántos cascos tienen asociados.

select b.id, count(c.nro_casco) as cantidad_cascos
from bicicleta b
 join casco c on b.id = c.idbici
where exists
(select 1
from tiene t
join accesorio a on t.codacc = a.cod
where t.idbici = b.id
and a.nombre = "asiento niño"
)
group by b.id;

select b.id, count(c.nro_casco) as cantidad_cascos
from bicicleta b
left join casco c on b.id = c.idbici /*si agrego el left join, me va a mostrar la bici aunque no tenga ningun casco asociado*/
where exists
(select 1
from tiene t
join accesorio a on t.codacc = a.cod
where t.idbici = b.id
and a.nombre = "asiento niño"
)
group by b.id;

select * from casco;
select * from bicicleta;
select * from accesorio;
select * from tiene;

insert into accesorio
(cod,nombre,personalizado)
values(4,"Asiento niño", "ABB 323");

insert into tiene
(idbici, codacc)
values (1,4);

insert into tiene
(idbici, codacc)
values (101,4);

insert into tiene
(idbici, codacc)
values (101,1);

select * from casco;

insert into casco
(idbici,nro_casco,talle)
values (1,2,"xl"),(1,3,"l");

select *
from bicicleta b
where exists
(select 1
from tiene t
join accesorio a on t.codacc = a.cod
where t.idbici = b.id
and a.cod = 4
);
-- b. Mostrar código y rodado de las bicicletas que tienen todos los accesorios.

-- que no exista una bicicleta que no tenga todos los accesorios
select b.id, b.rodado
from bicicleta b
where not exists
(select 1
from accesorio a
where not exists
(select 1
from tiene t
where t.idbici = b.id
and t.codacc = a.cod));

select * from bicicleta;
select * from accesorio;
select * from tiene;

insert into tiene
(idbici, codacc)
values (102,1),(102,2),(102,3),(102,4); /*la bicicleta 102 tesla por ahora tiene todos los accesorios*/


-- c. ¿Cuál es la cantidad de operaciones en el primer trimestre del año?

select count(id) as cantidad_operaciones_primer_trimestre
from operacion
where fecha_hora between "2024-01-01" and "2024-03-31";

select * from estacion;
select * from operacion;

show create table operacion;
show create table estacion; -- el formato de time es 'hh-mm-ss'

insert into estacion
(cod, nombre, horario,ubicacion)
values(1,"estacion palermo soho", "09:00:00","palermo soho");

select * from vecino;

insert into operacion
(id,fecha_hora,codestacion,idbici,tipo,tipodoc,nrodoc)
values (1,"2024-06-17",1,1,"alquiler","dni","10990190");

insert into operacion
(id,fecha_hora,codestacion,idbici,tipo,tipodoc,nrodoc)
values (2,"2024-01-01",1,1,"alquiler","dni","10990190");

alter table operacion
modify fecha_hora date not null; -- el formato de date es 'yy-mm-dd'

/*d. ¿Cuál es la cantidad de bicis no devueltas en el último mes, en el día a día? ¿Y desde que empezó a funcionar
el sistema? Se puede suponer que arrancó el 1/04/2022.*/

select count(op.idbici) as bicis_no_devueltas_ultimo_mes
from operacion op, operacion op2
where  not exists
(select 1
from bicicleta b
where b.id = op.idbici
and op.tipo like "devuelto"
);

select * from operacion;

-- bicis devueltas ultimo mes

select count(op.idbici) as bicis_devueltas_ultimo_mes
from operacion op
where exists
(select 1
from bicicleta b
where b.id = op.idbici
and op.tipo = "devuelto"
and op.fecha_hora between "2024-05-17" and "2024-06-17"
)
;

select * from operacion;

select count(op.idbici) as bicis_no_devueltas_ultimo_mes
from operacion op
where exists
(select 1
from bicicleta b 
where b.id = op.idbici
and op.fecha_hora between "2024-05-17" and "2024-06-17"
and op.tipo != "devuelto"); 

select count(op.idbici) 
from operacion op
where fecha_hora between "2024-05-17" and "2024-06-17"
and op.tipo != "devuelto";

select count(op.idbici) as bicis_no_devueltas_desde_funcion_del_sistema
from operacion op
where fecha_hora between "2022-04-01" and "2024-06-17"
and op.tipo != "devuelto";

select * from operacion;

-- cual es la cantidad de bicis devueltas en el ultimo mes?

select count(op.idbici) as bicis_devueltas
from operacion op
where fecha_hora between "2024-05-17" and "2024-06-17"
and op.tipo = "devuelto";

select * from operacion;
select * from bicicleta;

update operacion
set idbici = 103
where id = 2;

select * from operacion;

update operacion
set tipo = "retiro"
where tipo = "alquiler";

insert into operacion
(id, fecha_hora, codestacion, idbici,tipo,tipodoc,nrodoc)
values (3,"2024-05-20",1,101,"alquiler","dni","10990190");

insert into operacion
(id, fecha_hora, codestacion, idbici,tipo,tipodoc,nrodoc)
values (4,"2024-05-20",1,102,"devuelto","dni","10990190");

insert into operacion
(id, fecha_hora, codestacion, idbici,tipo,tipodoc,nrodoc)
values (5,"2024-05-19",1,102,"retiro","dni","10990190");

update operacion
set fecha_hora = "2024-05-19"
where id = 4;


select * from operacion;

-- e. ¿Cuáles son las bicis con más cantidad de accesorios?


select b.id, count(t.codacc) as cantidad_accesorios
from bicicleta b
join tiene t on b.id = t.idbici
group by b.id
order by count(t.codacc) desc;

/*f. Listar nombre y ubicación de las estaciones preferidas de los vecinos, entendiendo preferidas como las que
concentran más préstamos.*/

select e.nombre, e.ubicacion, count(o.id) as prestamos 
from estacion e 
join operacion o on e.cod = o.codEstacion 
where o.tipo = "retiro"
group by e.cod, e.nombre, e.ubicacion 
order by prestamos desc;

select * from estacion;
select * from operacion;

-- g. Listar los nombres de vecinos alfabéticamente de 
-- U a W (Ulises Bueno, Vicente López, Will Smith) junto a 
-- la cantidad de estaciones distintas que uso en la última semana, 
-- aún si no se prestó bicicleta (0 estaciones esa semana).
/*h. Mostrar el ránking de vecinos que han usado el sistema con más de 3 bicis distintas y que las devolvieron
según las reglas.
i. ¿Cómo medirías el éxito del programa de Eco Transporte? Armar una consulta que lo resuelva.*/