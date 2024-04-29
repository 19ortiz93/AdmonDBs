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


INSERT INTO CARGO VALUES (10,'Gerente General',1);
INSERT INTO CARGO VALUES (20,'Gerente de Produccion',2);
INSERT INTO CARGO VALUES (30,'Administrador de Planta',3);
INSERT INTO CARGO VALUES (40,'Gerente Financiero',2);
INSERT INTO CARGO VALUES (50,'Jefe de Sistemas',3);
INSERT INTO CARGO VALUES (60,'DBA',3);
INSERT INTO CARGO VALUES (70,'Analista de Sistemas',4);

INSERT INTO EMPLEADO VALUES (100,'Luis Franco',33,1500000,20);
INSERT INTO EMPLEADO VALUES (200,'Ana Velasco',58,3600000,40);
INSERT INTO EMPLEADO VALUES (300,'Paula Isaza',24,910000,60);
INSERT INTO EMPLEADO VALUES (400,'Jose Velez',77,2900000,20);
INSERT INTO EMPLEADO VALUES (500,'Ximena Torres',21,810000,70);
INSERT INTO EMPLEADO VALUES (600,'Cristina Galeano',31,990000,10);
INSERT INTO EMPLEADO VALUES (700,'Noe Rosales',66,2600000,20);

CREATE VIEW vista1 AS
SELECT nombre, edad, sueldo
FROM empleado
WHERE edad >= 30
WITH READ ONLY;

CREATE VIEW vista2 AS
SELECT cedula, nombre, edad
FROM empleado
WHERE sueldo > 2000000;

select *
from vista2;

select * from EMPLEADO;

UPDATE empleado
SET sueldo = 580000
WHERE cedula = 700;

select *
from vista2
where cedula = 200;

UPDATE vista2
SET edad = edad + 1
WHERE cedula = 200;

UPDATE vista2
SET edad = edad + 1
WHERE nombre = ‘Luis Franco’;

UPDATE vista3
SET nombre = ‘Cristina Galeano Hernandez’
WHERE nombre = ‘Cristina Galeano’;

UPDATE vista3
SET sueldo = 5900000
WHERE nombre = ‘Cristina Galeano Hernandez’;

UPDATE vista3
SET nombrecargo = ‘DBA’
WHERE nombre = ‘Cristina Galeano Hernandez’;


