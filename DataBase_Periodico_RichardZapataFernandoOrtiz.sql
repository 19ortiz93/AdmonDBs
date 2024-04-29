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
    titulo VARCHAR2(500) NOT NULL,
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
    
INSERT INTO articulo VALUES (1, 'Venezuela: sigue la búsqueda de desaparecidos tras unos deslaves que dejaron al menos 20 muertos y miles de afectados', 1, 1);
INSERT INTO articulo VALUES (2, 'El Banco Sabadell anuncia un nuevo recorte de plantilla', 1, 2);    
INSERT INTO articulo VALUES (3, 'Un reactor que Corea del Norte usa para producir plutonio parece estar activo, dice organismo de la ONU', 2, 3);
INSERT INTO articulo VALUES (4, 'Cómo un virus marcó el cambio de una era: un año después, nada volverá a ser igual', 1, 4);
INSERT INTO articulo VALUES (5, 'Andy Murray, la leyenda que regresa a Wimbledon', 2, 1);    
INSERT INTO articulo VALUES (6, 'El día en que las mujeres dijeron basta', 4, 2);
INSERT INTO articulo VALUES (7, 'Luis Díaz y Dayro Moreno: ¡los goles son amores...! (Meluk le cuenta)', 3, 3);

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
-- **                   CONSULTAR TABLAS                         ** --
-- **************************************************************** --

SELECT * FROM ciudad;
SELECT * FROM presidente;
SELECT * FROM telefonoPresidente;
SELECT * FROM editorGeneral;
SELECT * FROM telefonoEditorGeneral;
SELECT * FROM periodico;
SELECT * FROM seccion;
SELECT * FROM articulo;
SELECT * FROM periodista;
SELECT * FROM periodista_articulo;
SELECT * FROM periodistaA;
SELECT * FROM periodistaB;
SELECT * FROM telefonoPeriodista;


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
-- **                        FUNCION                             ** --
-- **************************************************************** --
-- Crear funcióon que valida el numero de habitantes 
CREATE OR REPLACE FUNCTION validarNumeroHabitantes(id_ciudad IN NUMBER, nuevos_habitantes IN NUMBER)
RETURN BOOLEAN IS
    existeCiudad NUMBER;
BEGIN
    SELECT COUNT(*) INTO existeCiudad FROM CIUDAD WHERE IDCIUDAD = id_ciudad;
    
    IF (existeCiudad > 0) AND (nuevos_habitantes > 0 AND nuevos_habitantes <= 10000000) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;


-- **************************************************************** --
-- **                        TRIGGER                             ** --
-- **************************************************************** --
SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER actualizacion_habitantes_ciudad
AFTER UPDATE ON CIUDAD
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('El numero total de habitantes de la ciudad de ' || :OLD.NOMBRES || ' paso de ser ' || :OLD.NUMEROHABITANTES || ' ha ser ' || :NEW.NUMEROHABITANTES);
END;

CREATE OR REPLACE TRIGGER insertar_ciudad
BEFORE INSERT ON CIUDAD
FOR EACH ROW
BEGIN
    IF (:NEW.NUMEROHABITANTES < 1) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Número de habitantes inválido. Debe ser mayor de 0 y menor o igual a 10 millones.');
    END IF;
END;

-- **************************************************************** --
-- **          PROCEDIMIENTO ALMACENADO                          ** --
-- **************************************************************** --
/* procedimiento oara aumentar el numero de habitantes en una ciudad y evita
    que ingresado sea mayor a cero y menor a 10millones */
CREATE OR REPLACE PROCEDURE actualizaHabitantes(
    id_ciudad IN NUMBER,
    nuevos_habitantes IN NUMBER)
IS
    validacion BOOLEAN;
BEGIN
    -- Llama a la función para validar los nuevos habitantes
    validacion := validarNumeroHabitantes(id_ciudad, nuevos_habitantes);

    IF validacion THEN
        -- Si la validación es exitosa, actualiza el número de habitantes
        UPDATE ciudad
        SET numeroHabitantes = nuevos_habitantes 
        WHERE idCiudad = id_ciudad;
    ELSE
        -- Maneja el caso de validación fallida
        DBMS_OUTPUT.PUT_LINE('No se pudo actualizar el numero de habitantes de la ciudad. Verfique que el id de la ciudad exista y que el número de habitantes sea mayor que 0 y menor o igual a 10 millones.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- Aquí se manejan los errores no anticipados
        DBMS_OUTPUT.PUT_LINE('Error al actualizar los habitantes: ' || SQLERRM);
END;


-- **************************************************************** --
-- **          PRUEBA PROCEDIMIENTO ALMACENADO                   ** --
-- **************************************************************** --

-- verificamos los datos
SELECT * FROM ciudad;
-- Intentamos insertar una nueva ciudad.
INSERT INTO ciudad VALUES (5, 'Santa Marta', 0);
-- Insertamos la ciudad con datos validos.
INSERT INTO ciudad VALUES (5, 'Santa Marta', 1);
-- hactualizamos la ciudad.
EXEC actualizaHabitantes(5, 1213423);

