-- **************************************************************** --
-- **                     Eliminar tablas                        ** --
-- **************************************************************** --

drop TABLE ciudad;
drop TABLE presidente;
drop TABLE telefonoPresidente;
drop TABLE editorGeneral;
drop TABLE telefonoEditorGeneral;
drop TABLE periodico;
drop TABLE seccion;
drop TABLE articulo;
drop TABLE periodista;
drop TABLE periodista_articulo;
drop TABLE periodistaA;
drop TABLE periodistaB;
drop TABLE telefonoPeriodista;

drop user FernandoOrtiz cascade;


-- **************************************************************** --
-- **                     CREACION DE TABLAS                     ** --
-- **************************************************************** --

CREATE TABLE ciudad(
    idCiudad NUMBER PRIMARY KEY,
    nombres VARCHAR2(30) NOT NULL,
    numeroHabitantes NUMBER NOT NULL);
    
CREATE TABLE presidente(
    idPresidente NUMBER PRIMARY KEY,
    nombres VARCHAR2(30) NOT NULL,
    apellidos VARCHAR2(30) NOT NULL);
    
CREATE TABLE telefonoPresidente(
    idTelefonoPresidente NUMBER PRIMARY KEY,
    telefono VARCHAR2(30) NOT NULL,
    idPresidente NUMBER NOT NULL);
    
CREATE TABLE editorGeneral(
    idEditorGeneral NUMBER PRIMARY KEY,
    nombres VARCHAR2(30) NOT NULL,
    apellidos VARCHAR2(30) NOT NULL);
    
CREATE TABLE telefonoEditorGeneral(
    idTelefonoEditorGenera NUMBER PRIMARY KEY,
    telefono VARCHAR2(30) NOT NULL,
    idEditorGeneral NUMBER NOT NULL);
    
CREATE TABLE periodico(
    idPeriodico NUMBER PRIMARY KEY,
    nombres VARCHAR2(30) NOT NULL,
    idCiudad NUMBER NOT NULL,
    idPresidente NUMBER NOT NULL,
    idEditorGeneral NUMBER NOT NULL);
    
CREATE TABLE seccion(
    idSeccion NUMBER PRIMARY KEY,
    añoFundacion NUMBER NOT NULL,
    nombre VARCHAR(30) NOT NULL,
    categoria VARCHAR(30) NOT NULL);
    
CREATE TABLE articulo(
    idArticulo NUMBER PRIMARY KEY,
    titulo VARCHAR2(100) NOT NULL,
    idSeccion NUMBER NOT NULL,
    idPeriodico NUMBER NOT NULL);

CREATE TABLE periodista(
    idPeriodista NUMBER PRIMARY KEY,
    nombres VARCHAR2(30) NOT NULL,
    apellidos VARCHAR2(30) NOT NULL);
    
CREATE TABLE periodista_articulo(
    idPeriodista NUMBER NOT NULL,
    idArticulo NUMBER NOT NULL,
    numeroHoras NUMBER NOT NULL);
    
CREATE TABLE periodistaA(
    idPeriodistaA NUMBER NOT NULL,
    añoPremio NUMBER NOT NULL,
    idPeriodista NUMBER NOT NULL);
       
CREATE TABLE periodistaB(
    idPeriodistaB NUMBER NOT NULL,
    valorRegalias NUMBER NOT NULL,
    idPeriodista NUMBER NOT NULL);
    
CREATE TABLE telefonoPeriodista(
    idTelefonoPeriodista NUMBER PRIMARY KEY,
    telefono NUMBER NOT NULL,
    idPeriodista NUMBER NOT NULL);
    
-- **************************************************************** --
-- **                 CREACION DE RELACIONES                     ** --
-- **************************************************************** --
    
ALTER TABLE telefonoPresidente
ADD CONSTRAINT FK_telefonoPresidente_presidente
FOREIGN KEY (idPresidente)
REFERENCES presidente(idPresidente);
    
ALTER TABLE periodico
ADD CONSTRAINT FK_periodico_ciudad
FOREIGN KEY (idCiudad)
REFERENCES ciudad(idCiudad);

ALTER TABLE periodico
ADD CONSTRAINT FK_periodico_presidente
FOREIGN KEY (idPresidente)
REFERENCES presidente(idPresidente);

ALTER TABLE periodico
ADD CONSTRAINT FK_periodico_editorGeneral
FOREIGN KEY (idEditorGeneral)
REFERENCES editorGeneral(idEditorGeneral);

ALTER TABLE articulo
ADD CONSTRAINT FK_articulo_periodico
FOREIGN KEY (idPeriodico)
REFERENCES periodico(idPeriodico);

ALTER TABLE telefonoEditorGeneral
ADD CONSTRAINT FK_telefonoEditorGeneral_editorGeneral
FOREIGN KEY (idEditorGeneral)
REFERENCES editorGeneral(idEditorGeneral);

ALTER TABLE articulo
ADD CONSTRAINT FK_articulo_seccion
FOREIGN KEY (idSeccion)
REFERENCES seccion(idSeccion);

ALTER TABLE periodista_articulo
ADD CONSTRAINT FK_periodista_articulo_articulo
FOREIGN KEY (idArticulo)
REFERENCES articulo(idArticulo);

ALTER TABLE periodista_articulo
ADD CONSTRAINT FK_periodista_articulo_periodista
FOREIGN KEY (idPeriodista)
REFERENCES periodista(idPeriodista);

ALTER TABLE periodistaA
ADD CONSTRAINT FK_periodistaA_periodista
FOREIGN KEY (idPeriodista)
REFERENCES periodista(idPeriodista);

ALTER TABLE periodistaB
ADD CONSTRAINT FK_periodistaB_periodista
FOREIGN KEY (idPeriodista)
REFERENCES periodista(idPeriodista);

ALTER TABLE telefonoPeriodista
ADD CONSTRAINT FK_telefonoPeriodista_periodista
FOREIGN KEY (idPeriodista)
REFERENCES periodista(idPeriodista);

-- **************************************************************** --
-- **                   INSERCION DE DATOS                       ** --
-- **************************************************************** --

INSERT INTO ciudad VALUES (1, 'Medellin', 2611104);
INSERT INTO ciudad VALUES (2, 'Bogota', 7936532);
INSERT INTO ciudad VALUES (3, 'Cali', 2250842);
INSERT INTO ciudad VALUES (4, 'Barranquilla', 1326588);
    
INSERT INTO presidente VALUES (1, 'Carlos', 'Padilla');
INSERT INTO presidente VALUES (2, 'Juan', 'Uribe');    
INSERT INTO presidente VALUES (3, 'Manuel', 'Petro');
INSERT INTO presidente VALUES (4, 'Daniel', 'Quintero');
    
INSERT INTO telefonoPresidente VALUES (5, 72635535, 1);
INSERT INTO telefonoPresidente VALUES (6, 87826353, 2);    
INSERT INTO telefonoPresidente VALUES (7, 87254253, 3);
INSERT INTO telefonoPresidente VALUES (8, 72534352, 4);
    
INSERT INTO editorGeneral VALUES (1, 'Santiago', 'Mesa');
INSERT INTO editorGeneral VALUES (2, 'David', 'Monsalve');    
INSERT INTO editorGeneral VALUES (3, 'Pedro', 'Sepulveda');
INSERT INTO editorGeneral VALUES (4, 'Mario', 'Hernandez');
    
INSERT INTO telefonoEditorGeneral VALUES (5, 61535376, 1);
INSERT INTO telefonoEditorGeneral VALUES (6, 62427821, 2);    
INSERT INTO telefonoEditorGeneral VALUES (7, 69273622, 3);
INSERT INTO telefonoEditorGeneral VALUES (8, 61373532, 4);
    
INSERT INTO periodico VALUES (1, 'El Colombiano', 1,1,1);
INSERT INTO periodico VALUES (2, 'El Tiempo', 2, 2, 2);
INSERT INTO periodico VALUES (3, 'El Espectador', 3, 3, 3);
INSERT INTO periodico VALUES (4, 'La Republica', 4, 4, 4);

INSERT INTO seccion VALUES (1, 1963, 'Opinion', 'Entrevistas');
INSERT INTO seccion VALUES (2, 1968, 'Entretenimiento', 'peliculas');
INSERT INTO seccion VALUES (3, 1964, 'Deportes', 'Futbol');
INSERT INTO seccion VALUES (4, 1967, 'Cultura', 'Arte');
    
INSERT INTO articulo VALUES (1, 'Venezuela: sigue la bús', 1, 1);
INSERT INTO articulo VALUES (2, 'El Banco Sabadell anunc', 1, 2);    
INSERT INTO articulo VALUES (3, 'Un reactor que Corea de', 2, 3);
INSERT INTO articulo VALUES (4, 'Cómo un virus marcó el', 1, 4);
INSERT INTO articulo VALUES (5, 'Andy Murray, la leyenda', 2, 1);    
INSERT INTO articulo VALUES (6, 'El día en que las mujeres', 4, 2);
INSERT INTO articulo VALUES (7, 'Luis Díaz y Dayro Moreno', 3, 3);

INSERT INTO periodista VALUES (1, 'Andres', 'Ubarguen');
INSERT INTO periodista VALUES (2, 'Messi', 'Guzman');
INSERT INTO periodista VALUES (3, 'Farid', 'Ortiz');
INSERT INTO periodista VALUES (4, 'Daniela', 'Pinto');
    
INSERT INTO periodista_articulo VALUES (1, 1, 84);
INSERT INTO periodista_articulo VALUES (2, 3, 163);    
INSERT INTO periodista_articulo VALUES (3, 5, 97);
INSERT INTO periodista_articulo VALUES (4, 7, 90);
INSERT INTO periodista_articulo VALUES (1, 2, 88);    
INSERT INTO periodista_articulo VALUES (2, 4, 105);
INSERT INTO periodista_articulo VALUES (4, 6, 70);
    
INSERT INTO periodistaA VALUES (1, 2002, 1);
INSERT INTO periodistaA VALUES (2, 2006, 2);    
       
INSERT INTO periodistaB VALUES (1, 3000000, 3);
INSERT INTO periodistaB VALUES (2, 4500000, 4);    
    
INSERT INTO telefonoPeriodista VALUES (1, 8463653, 1);
INSERT INTO telefonoPeriodista VALUES (2, 8225362, 2);
INSERT INTO telefonoPeriodista VALUES (3, 8361531, 3);
INSERT INTO telefonoPeriodista VALUES (4, 8934362, 4); 

-- **************************************************************** --
-- **                        CONSULTAS                           ** --
-- **************************************************************** --

-- ¿Cuáles son los nombres de los periodistas, el título de sus artículos, 
-- la sección a la que pertenecen dichos artículos, 
-- el nombre del periódico y la ciudad donde se publica el periódico?

SELECT p.nombres AS Periodista, a.titulo AS Articulo, s.nombre AS Seccion, pe.nombres AS Periodico, c.nombres AS Ciudad
FROM periodista p
JOIN periodista_articulo pa ON p.idPeriodista = pa.idPeriodista
JOIN articulo a ON pa.idArticulo = a.idArticulo
JOIN seccion s ON a.idSeccion = s.idSeccion
JOIN periodico pe ON a.idPeriodico = pe.idPeriodico
JOIN ciudad c ON pe.idCiudad = c.idCiudad;

-- ¿Cuál es la lista completa de periodistas y los artículos que han escrito,
-- incluyendo periodistas que no han escrito ningún artículo?

SELECT p.nombres, a.titulo
FROM periodista p
LEFT JOIN periodista_articulo pa ON p.idPeriodista = pa.idPeriodista
LEFT JOIN articulo a ON pa.idArticulo = a.idArticulo;

-- ¿Cuál es la lista de todos los periodistas que han 
-- escrito artículos en el "El Colombiano" pero no en el "El Espectador"?

select * from periodista;
select * from articulo;
-- Primero, obtenemos los periodistas de A
-- Luego, excluimos a los que también escribieron para B

SELECT p.nombres, p.apellidos 
FROM periodista p
JOIN periodista_articulo pa ON p.idPeriodista = pa.idPeriodista
JOIN articulo a ON pa.idArticulo = a.idArticulo
JOIN periodico pe ON a.idPeriodico = pe.idPeriodico
WHERE pe.nombres = 'El Colombiano'
MINUS
(SELECT p.nombres, p.apellidos 
FROM periodista p
JOIN periodista_articulo pa ON p.idPeriodista = pa.idPeriodista
JOIN articulo a ON pa.idArticulo = a.idArticulo
JOIN periodico pe ON a.idPeriodico = pe.idPeriodico
WHERE pe.nombres = 'El Espectador');

 -- ¿Cuáles son los nombres de los periódicos que tienen
 -- artículos escritos por periodistas premiados de categoría A?

SELECT p.nombres
FROM periodico p
WHERE EXISTS (
    SELECT 1
    FROM articulo a
    JOIN periodista_articulo pa ON pa.idArticulo = a.idArticulo
    JOIN periodistaA paA ON paA.idPeriodista = pa.idPeriodista
    WHERE a.idPeriodico = p.idPeriodico
);




SELECT p.nombres
FROM periodico p
WHERE p.idPeriodico IN (
    SELECT a.idPeriodico
    FROM articulo a
    WHERE a.idArticulo IN (
        SELECT pa.idArticulo
        FROM periodista_articulo pa
        WHERE pa.idPeriodista IN (
            SELECT paA.idPeriodista
            FROM periodistaA paA
        )
    )
);

-- **************************************************************** --
-- **          PROCEDIMIENTO ALMACENADO                          ** --
-- **************************************************************** --
-- procedimiento que evita que el el numero de habitantes 
-- ingresado sea mayor a cero y menor a 10millones

-- Crear funcióon que valida el numero de habitantes 
CREATE OR REPLACE FUNCTION validarNumeroHabitantes(nuevos_habitantes IN NUMBER)
RETURN BOOLEAN IS
BEGIN
    IF nuevos_habitantes > 0 AND nuevos_habitantes <= 10000000 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

-- Crear procedimiento almacenado
CREATE OR REPLACE PROCEDURE actualizaHabitantes(
    id_ciudad IN NUMBER,
    nuevos_habitantes IN NUMBER)
IS
    validacion BOOLEAN;
BEGIN
    -- Llama a la función para validar los nuevos habitantes
    validacion := validarNumeroHabitantes(NUMERO_HABITANTES);

    IF validacion THEN
        -- Si la validación es exitosa, actualiza el número de habitantes
        UPDATE ciudad
        SET numeroHabitantes = nuevos_habitantes 
        WHERE idCiudad = id_ciudad;
        
        -- Si se actualiza un registro, se asume éxito y se puede registrar o hacer algo adicional
        IF SQL%ROWCOUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Actualización exitosa.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('No se encontró la ciudad.');
        END IF;
    ELSE
        -- Maneja el caso de validación fallida
        RAISE_APPLICATION_ERROR(-20001, 'Número de habitantes inválido. Debe ser mayor que 0 y menor o igual a 10 millones.');
    END IF;
    
    -- Implementación simplificada del manejo de errores
EXCEPTION
    WHEN OTHERS THEN
        -- Aquí se manejan los errores no anticipados
        DBMS_OUTPUT.PUT_LINE('Error al actualizar los habitantes: ' || SQLERRM);
END;


--Prueba del procedimiento alamcenado.
-- ALTER SESSION SET "_oracle_script" = true;
SELECT * FROM ciudad;
INSERT INTO ciudad VALUES (5, 'Santa Marta', -12134232);

BEGIN
    actualizaHabitantes(1, 1213423);
END;

commit;

