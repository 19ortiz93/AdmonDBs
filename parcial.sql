-- Linea que permite realizar operaciones de usuario
ALTER SESSION SET "_oracle_script" = true;


CREATE TABLE Taxis (
    id_taxi NUMBER PRIMARY KEY,
    marca VARCHAR2(50),
    modelo VARCHAR2(50),
    placa VARCHAR2(20),
    id_acopio NUMBER,
    CONSTRAINT fk_taxi_acopio FOREIGN KEY (id_acopio) REFERENCES Acopios(id_acopio)
);
    
drop table taxis;
 
drop table conductores;
CREATE TABLE Acopios (
    id_acopio NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    ubicacion VARCHAR2(200)
);

CREATE TABLE Conductores (
    id_conductor NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    edad NUMBER,
    experiencia_anios NUMBER,
    id_taxi NUMBER,
    CONSTRAINT fk_conductor_taxi FOREIGN KEY (id_taxi) REFERENCES Taxis(id_taxi)
);
-- Insertar datos en la tabla Taxi
 
INSERT INTO TaxiS (id_taxi, marca, modelo, placa,id_acopio) VALUES
(1, 'Toyota', 'Corolla', 'ABC123',1);
INSERT INTO TaxiS (id_taxi, marca, modelo, placa,id_acopio) VALUES
(2, 'Hyundai', 'Accent', 'DEF456',2);
INSERT INTO TaxiS (id_taxi, marca, modelo, placa,id_acopio) VALUES
(3, 'Chevrolet', 'Spark', 'GHI789',3);
INSERT INTO TaxiS (id_taxi, marca, modelo, placa,id_acopio) VALUES
(4, 'Ford', 'Fiesta', 'JKL012',4);
SELECT * FROM TAXIS;
 
-- Insertar datos en la tabla Acopio
 
INSERT INTO AcopioS (id_acopio, Nombre, ubicacion) VALUES
(1, 'Colores', 'Zona Norte'); 
INSERT INTO AcopioS (id_acopio, Nombre, ubicacion) VALUES
(2, 'TaxisMedallo', 'Zona Sur');
INSERT INTO AcopioS (id_acopio, Nombre, ubicacion) VALUES
(3, 'Cootaxis', 'Zona Este');
INSERT INTO AcopioS (id_acopio, Nombre, ubicacion) VALUES
(4, 'TaxisSA', 'Zona Oeste');
SELECT * FROM ACOPIOS;
 
-- Insertar datos en la tabla Conductor
 
INSERT INTO Conductores (id_conductor, nombre, edad, experiencia_anios,id_taxi) VALUES
(1, 'Juan Perez', 35, 5,1);
INSERT INTO Conductores (id_conductor, nombre, edad, experiencia_anios,id_taxi) VALUES
(2, 'Maria Gonzalez', 28, 3,2);
INSERT INTO Conductores (id_conductor, nombre, edad, experiencia_anios,id_taxi) VALUES
(3, 'Pedro Ramirez', 40, 8,3);
INSERT INTO Conductores (id_conductor, nombre, edad, experiencia_anios,id_taxi) VALUES
(4, 'Ana Lopez', 45, 10,4);
SELECT * FROM CONDUCTORES;
 
 
CREATE force VIEW vistataxis  AS
SELECT marca,modelo,placa
FROM taxis
where id_acopio > 2;
 
 
CREATE VIEW vista_comun_taxis AS
SELECT t.marca, t.modelo, a.nombre, c.edad
FROM taxis t
JOIN acopios a ON t.id_acopio = a.id_acopio
JOIN conductores c ON t.id_taxi = c.id_taxi
WHERE c.edad > 30
WITH CHECK OPTION;
 
 
INSERT INTO vista_comun_taxis VALUES
('renaul', '2021', 'acopio', 35);
 
 
CREATE MATERIALIZED VIEW VistaMaterializable
BUILD IMMEDIATE
REFRESH COMPLETE START WITH SYSDATE
NEXT (SYSDATE + 15/86400)
AS
SELECT e.cedula, e.nombre, e.edad, c.nombre AS nombrecargo
FROM empleado e INNER JOIN cargo c
ON e.codcargo = c.codigo
WHERE e.edad < 40;

-- El director de BI (Business Intelligence) de la compañía está requiriendo 
-- hacer un cargue de datos al datawarehouse, desde unas fuentes de datos 
-- que se encuentran en tablas de Oracle ya que se require separar los datos
-- de los conductores de taxis que tengan mas de 5 años de experiencia para 
-- obsequiar dos eventos como premio por su tiempo como servidor.
select * from conductores;

CREATE TABLE EventosConductores (
    id_evento NUMBER,
    id_conductor NUMBER,
    nombre_evento VARCHAR2(100),
    CONSTRAINT fk_eventosconductores_conductor FOREIGN KEY (id_conductor) REFERENCES Conductores(id_conductor)
);

INSERT ALL
  INTO EventosConductores (id_evento, id_conductor, nombre_evento) VALUES (1, id_conductor, 'Feria de Taxi Ecológicos')
  INTO EventosConductores (id_evento, id_conductor, nombre_evento) VALUES (2, id_conductor, 'Conferencia de Seguridad Vial')
SELECT id_conductor FROM Conductores WHERE experiencia_anios > 5;

select * from EventosConductores;

-- El director de BI (Business Intelligence) de la compañía está requiriendo 
-- hacer un cargue de datos al datawarehouse, desde unas fuentes de datos 
-- que se encuentran en tablas de Oracle ya que se necesita realizar un reporte
-- donde se pueda visualizar la cantidad de taxis por marca y nombre del acopio
-- donde se pueda visualizar mejor la preferencias de marcas por los taxistas.
-- 

select * from taxis;

INSERT INTO TaxiS (id_taxi, marca, modelo, placa,id_acopio) VALUES
(5, 'Toyota', 'Corolla', 'ABC123',3);
INSERT INTO TaxiS (id_taxi, marca, modelo, placa,id_acopio) VALUES
(6, 'Chevrolet', 'Accent', 'DEF456',4);
INSERT INTO TaxiS (id_taxi, marca, modelo, placa,id_acopio) VALUES
(7, 'Chevrolet', 'Spark', 'GHI789',1);

SELECT * FROM (
  SELECT t.marca, a.nombre
  FROM Taxis t JOIN Acopios a 
  ON t.id_acopio = a.id_acopio
)
PIVOT (
  COUNT(marca)
  FOR marca IN ('Hyundai' AS Hyundai, 'Toyota' AS Toyota, 'Chevrolet' AS Chevrolet,  'Ford' AS Ford)
);

-- debemos entender que normalmente las vistas materializadas no son actualizables
-- directamente. Sin embargo, bajo ciertas condiciones y con la utilización 
-- de técnicas específicas, es posible modificar los datos subyacentes 
-- que afectan una vista materializada.

-- Primero, crearé una vista materializada simple que 
-- junta información de las tablas Taxis y Conductores:

CREATE MATERIALIZED VIEW LOG ON Taxis
WITH ROWID, SEQUENCE (id_taxi, marca, modelo, placa, id_acopio)
INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON Conductores
WITH ROWID, SEQUENCE (id_conductor, nombre, edad, experiencia_anios, id_taxi)
INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW VwTaxisConductores
REFRESH FAST ON COMMIT
AS
SELECT c.id_conductor, c.nombre, t.marca, t.modelo, t.placa
FROM Conductores c
JOIN Taxis t ON c.id_taxi = t.id_taxi;

INSERT INTO Taxis VALUES (1, 'Toyota', 'Corolla', 'XYZ123', 1);
INSERT INTO Conductores VALUES (1, 'Juan Pérez', 35, 10, 1);
COMMIT;

SELECT * FROM VwTaxisConductores;

UPDATE Conductores SET nombre = 'Juan P. Martínez' WHERE id_conductor = 1;
COMMIT;

SELECT * FROM VwTaxisConductores;




---------

CREATE USER CAMILO IDENTIFIED BY 1234
QUOTA 50M ON USERS;

CREATE USER SEBASTIAN IDENTIFIED BY 1234
QUOTA 50M ON USERS;


CREATE USER KEVIN IDENTIFIED BY 1234
QUOTA 50M ON USERS;

CREATE PROFILE admin_profile LIMIT
    SESSIONS_PER_USER 10
    CPU_PER_SESSION UNLIMITED
    CPU_PER_CALL UNLIMITED
    CONNECT_TIME UNLIMITED
    IDLE_TIME UNLIMITED;

CREATE PROFILE coordinator_profile LIMIT
    SESSIONS_PER_USER 5
    CPU_PER_SESSION UNLIMITED
    CPU_PER_CALL UNLIMITED
    CONNECT_TIME 100
    IDLE_TIME 30;

CREATE PROFILE accountant_profile LIMIT
    SESSIONS_PER_USER 5
    CPU_PER_SESSION UNLIMITED
    CPU_PER_CALL UNLIMITED
    CONNECT_TIME 130
    IDLE_TIME 30;

-- Crear roles para agrupar permisos comunes
CREATE ROLE fleet_manager;
CREATE ROLE coordinator;
CREATE ROLE accountant
GRANT ALL PRIVILEGES TO CAMILO;
-- Otorgar permisos a los roles
GRANT SELECT, INSERT, UPDATE, DELETE ON taxis TO fleet_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON acopios TO fleet_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON conductores TO fleet_manager;

-- Otorgar permisos específicos a los roles
GRANT SELECT, UPDATE ON taxis TO coordinator;
GRANT SELECT,  UPDATE ON acopios TO coordinator;
GRANT SELECT, UPDATE ON conductores TO coordinator;


GRANT SELECT ON taxis TO accountant;
GRANT SELECT ON acopios TO accountant;
GRANT SELECT ON conductores TO accountant;


GRANT fleet_manager TO CAMILO;
GRANT coordinator TO SEBASTIAN;
GRANT accountant TO KEVIN;

ALTER USER CAMILO PROFILE admin_profile;
ALTER USER SEBASTIAN PROFILE coordinator_profile;
ALTER USER KEVIN PROFILE accountant_profile;

CONNECT CAMILO/1234;

