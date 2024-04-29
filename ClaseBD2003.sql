-- ****************************************************************** --
-- **                         VISTAS COMUNES                       ** --
-- ****************************************************************** --

-- CREAR LAS SIGUIENTES TABLAS:

CREATE TABLE EMPLEADO
(CEDULA NUMBER PRIMARY KEY,
NOMBRE VARCHAR2(40) NOT NULL,
EDAD NUMBER,
SUELDO NUMBER,
CODCARGO NUMBER);

CREATE TABLE CARGO
(CODIGO NUMBER PRIMARY KEY,
NOMBRE VARCHAR2(40) NOT NULL,
CATEGORIA NUMBER);

ALTER TABLE EMPLEADO
ADD FOREIGN KEY(CODCARGO)
REFERENCES CARGO(CODIGO);

-- INSERTAR LOS SIGUIENTES DATOS SOBRE LAS TABLAS CREADAS.

INSERT INTO CARGO VALUES (10,'Gerente General',1);
INSERT INTO CARGO VALUES (20,'Gerente de Produccion',2);
INSERT INTO CARGO VALUES (30,'Administrador de Planta',3);
INSERT INTO CARGO VALUES (40,'Gerente Financiero',2);
INSERT INTO CARGO VALUES (50,'Jefe de Sistemas',3);
INSERT INTO CARGO VALUES (60,'DBA' ,3);
INSERT INTO CARGO VALUES (70,'Analista de Sistemas',4);

SELECT * FROM CARGO;

INSERT INTO EMPLEADO VALUES (100,'Luis Franco',33,1500000,20);
INSERT INTO EMPLEADO VALUES (200,'Ana Velasco',58,3600000,40);
INSERT INTO EMPLEADO VALUES (300,'Paula Isaza',24,910000,60);
INSERT INTO EMPLEADO VALUES (400,'Jose Velez',77,2900000,20);
INSERT INTO EMPLEADO VALUES (500,'Ximena Torres',21,810000,70);
INSERT INTO EMPLEADO VALUES (600,'Cristina Galeano',31,990000,10);
INSERT INTO EMPLEADO VALUES (700,'Noe Rosales',66,2600000,20);

SELECT * FROM EMPLEADO;

-- CREAR LAS SIGUIENTES DOS VISTAS

CREATE VIEW vista1 AS
SELECT nombre, edad, sueldo
FROM empleado
WHERE edad >= 30
WITH READ ONLY;

CREATE VIEW vista2 AS
SELECT cedula, nombre, edad
FROM empleado
WHERE sueldo > 2000000;

-- MIREMOS QUE METADATOS ALMACENA REFERENTES A LAS VISTAS CREADAS
-- QUÉ SIGNIFICA EL RESULTADO?

SELECT text
FROM user_views
WHERE view_name = 'VISTA1';

SELECT text
FROM user_views
WHERE view_name = 'VISTA2';

-- MIREMOS EL CONTENIDO DE LA VISTA LLAMADA VISTA2. APARECE UN EMPLEADO LLAMADO
-- NOE ROSALES? Si

SELECT *
FROM vista2;

-- ACTUALICEMOSLE AL EMPLEADO CON CEDULA 700 SU SUELDO. HACER ESTO EN LA TABLA
-- BASE.

UPDATE empleado
SET sueldo = 580000
WHERE cedula = 700;

-- VOLVAMOS A CONSULTAR LA VISTA. APARECE NOE ROSALES? POR QUE SUCEDE ESTO? Por que no cumple con la condición del where en la consulta no gana dos millones.


SELECT *
FROM vista2;

-- MIREMOS LOS DATOS DEL EMPLEADO CON CEDULA 200.

SELECT * FROM vista2 WHERE CEDULA = 200;

-- A TRAVES DE LA VISTA, A ESE EMPLEADO CON CEDULA 200 SUMEMOSLE UNO A LA EDAD.

UPDATE vista2
SET edad = edad + 1
WHERE cedula = 200;

-- CONSULTEMOS DE NUEVO LA VISTA. LA EDAD DEL EMPLEADO 200 SUBIO EN UNO?

SELECT * FROM VISTA2;

-- Y LA EDAD DEL EMPLEADO 200 QUEDO SUMADO EN UNO EN LA TABLA BASE? sii las vistas son actualizables

SELECT *
FROM empleado
WHERE cedula = 200;   -- SIGNIFICA QUE LA VISTA VISTA2 ES ACTUALIZABLE.

-- AHORA, A TRAVÉS DE LA VISTA, TRATEMOS DE SUMARLE UNO A LA EDAD DE LUIS FRANCO.
-- QUÉ SUCEDE? POR QUE SUCEDE ESTO?
UPDATE vista1
SET edad = edad + 1
WHERE nombre = 'Luis Franco';

-- CREEMOS LA SIGUIENTE VISTA. QUÉ SUCEDE?

CREATE VIEW vista3 AS
SELECT e.nombre, e.edad, c.nombre
FROM empleado e INNER JOIN cargo c
ON e.codcargo = c.codigo
WHERE e.edad < 50;

-- SE CORRIGE ASI...

CREATE VIEW vista3 AS
SELECT e.nombre, e.edad, c.nombre AS NOMBRECARGO
FROM empleado e INNER JOIN cargo c
ON e.codcargo = c.codigo
WHERE e.edad < 50;

-- MIREMOS EL CONTENIDO DE LA VISTA VISTA3

SELECT * FROM VISTA3;

-- HAGAMOS ESTA MODIFICACION A TRAVÉS DE LA VISTA

UPDATE vista3
SET nombre = 'Cristina Galeano Hernandez'
WHERE nombre = 'Cristina Galeano';

-- AHORA MIREMOS SI LA MODIFICACION ANTERIOR QUEDO HECHA.

SELECT * FROM VISTA3;

-- POR QUE LA MODIFICACIÓN SIGUIENTE NO FUNCIONA?

UPDATE vista3
SET sueldo = 5900000
WHERE nombre = 'Cristina Galeano Hernandez';

-- POR QUE LA MODIFICACIÓN SIGUIENTE SACA ERROR?

UPDATE vista3
SET nombrecargo = 'DBA'
WHERE nombre = 'Cristina Galeano Hernandez';
-- vista 3 es actualizable solo para el lado del empleado no del cargo

-- CREEMOS LA SIGUIENTE VISTA PARA MIRAR QUE HACE LA CLAUSULA WITH CHECK OPTION.

CREATE VIEW vista4 AS
SELECT cedula, nombre, edad, sueldo
FROM empleado
WHERE sueldo < 2000000
WITH CHECK OPTION;
-- obliga a que para poder insertar cumpla con la condicion del where

Select * from vista4;
-- INSERTEMOS ESTE DATO A TRAVÉS DE LA VISTA? FUNCIONO?

INSERT INTO vista4 VALUES
(900, 'Ricardo Marin', 56, 1900000);

-- INSERTEMOS ESTE OTRO DATO A TRAVES DE LA VISTA? QUE SUCEDIO?

INSERT INTO vista5 VALUES
(1900, 'Melissa Arboleda', 31, 3400000);
 -- las comunes almacenan los select y las materializables los resultados del select
 -- sirve para facilidad en la ejecucion de la consulta
 -- tambien para control de acceso-
 
CREATE VIEW vista5 AS
SELECT cedula, nombre, edad, sueldo
FROM empleado
WHERE sueldo < 2000000;
select * from vista5;