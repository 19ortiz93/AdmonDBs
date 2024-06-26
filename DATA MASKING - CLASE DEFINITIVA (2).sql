-- *************************************************************** --
-- **                  DATA MASKING                             ** --
-- *************************************************************** --
-- Linea que permite realizar operaciones de usuario
ALTER SESSION SET "_oracle_script" = true;

-- CREAR UN USUARIO LLAMADO ENCRIPTADO
drop user ENCRIPTADO;
CREATE USER ENCRIPTADO IDENTIFIED BY 123;

GRANT ALL PRIVILEGES TO ENCRIPTADO;

-- CONECTADOS CON EL USUARIO RECIEN CREADO:

CREATE TABLE EMPLEADO
(NOMBRE VARCHAR2(30),
APELLIDO VARCHAR2(30),
FECHACON DATE,
SUELDO NUMBER)

INSERT INTO EMPLEADO VALUES ('JORGE','BEDOYA','20-08-1967',340000);
INSERT INTO EMPLEADO VALUES ('PAULA','BETANCUR','17-09-1976',347888);
INSERT INTO EMPLEADO VALUES ('CRISTINA','GALEANO','19-10-1989',55555);
INSERT INTO EMPLEADO VALUES ('ESMERALDA','PORRAS','12-08-1989',678888);
INSERT INTO EMPLEADO VALUES ('MANUELA','TENGANAN','31-12-1995',123333);
INSERT INTO EMPLEADO VALUES ('LUIS','SUAREZ','20-09-1968',33333);

SELECT * FROM EMPLEADO;

-- ***************************************************************** --
-- **              POLITICA DE REDACCI�N TOTAL                    ** --
-- ***************************************************************** --

-- LUEGO VAMOS A CREAR UNA POLITICA DE REDACCION FULL, DESDE EL USUARIO
-- ADMINISTRADOR

-- LA SIGUIENTE POLITICA APLICA PARA TODOS LOS USUARIOS, INCLUIDO EL DUE�O
-- DE LA TABLA, EL USUARIO ENCRIPTADO.

BEGIN
dbms_redact.add_policy
(object_schema => 'ENCRIPTADO',
object_name => 'EMPLEADO',
policy_name => 'DMSK_FECHACON',
column_name => 'FECHACON',
function_type => DBMS_REDACT.FULL,
expression => '1=1');
END;

-- CON EL USUARIO ENCRIPTADO, HACER UN SELECT A LA TABLA. QUE PASA CON EL
-- CAMPO FECHACON?

-- VAMOS A BORRAR LA POLITICA ANTERIOR, DESDE ADMINISTRADOR:

BEGIN
dbms_redact.drop_policy
(object_schema => 'ENCRIPTADO',
object_name => 'EMPLEADO',
policy_name => 'DMSK_FECHACON');
END;

-- LA SIGUIENTE POLITICA APLICA PARA TODOS LOS USUARIOS, MENOS PARA EL DUE�O
-- DE LA TABLA, EL USUARIO ENCRIPTADO.
drop table empleado;

BEGIN
dbms_redact.add_POLICY
(object_schema => 'ENCRIPTADO',
object_name => 'EMPLEADO',
policy_name => 'DMSK_FECHACON',
column_name => 'FECHACON',
function_type => DBMS_REDACT.FULL,
expression => 'SYS_CONTEXT(''USERENV'', 
                          ''SESSION_USER'') != ''ENCRIPTADO''');
END;

-- HACER UN SELECT DE LA TABLA DESDE EL USUARIO ENCRIPTADO. QUE SUCEDE?

-- HACER UN SELECT DE LA TABLA DESDE OTRO USUARIO. QU� SUCEDE?


-- COMO VER LAS POLITICAS DE REDACCION CREADAS?

SELECT * FROM redaction_policies;

-- COMO VER LOS VALORES, POR DEFECTO, DE LOS CAMPOS REDACTADOS?

SELECT * 
FROM REDACTION_VALUES_FOR_TYPE_FULL ;

-- COMO CAMBIAR UN VALOR POR DEFECTO?

exec dbms_redact.UPDATE_FULL_REDACTION_VALUES ( varchar_val => 'X' );

-- ***************************************************************** --
-- **              POLITICA DE REDACCI�N PARCIAL                  ** --
-- ***************************************************************** --

-- DESDE EL USUARIO ENCRIPTADO, CREAR LA SIGUIENTE TABLA E INSERTARLE LOS
-- SIGUIENTES DATOS:

CREATE TABLE CREDIT_CARD ( ID INTEGER , 
IDCLIENTE VARCHAR(10) , CARD VARCHAR(12) );

INSERT INTO CREDIT_CARD VALUES ( 1 , '5477815100' , '987234372687');
INSERT INTO CREDIT_CARD VALUES ( 2 , '2554783107' , '772534961873');
INSERT INTO CREDIT_CARD VALUES ( 3 , '9875424112' , '237498428852');
INSERT INTO CREDIT_CARD VALUES ( 4 , '2547458213' , '753298721630');
COMMIT;

SELECT * FROM CREDIT_CARD;

-- DESDE ADMINISTRADOR, CREAR LA SIGUIENTE POLITICA DE REDACCION

BEGIN
    DBMS_REDACT.ADD_POLICY(
    object_schema             => 'ENCRIPTADO',
    object_name                 => 'credit_card',
    column_name               => 'card',
    column_description     => 'Columna sensible',
    policy_name                  => 'CARD_PARCIAL',
    policy_description        => 'Enmascara campo CARD',
    function_type                => DBMS_REDACT.PARTIAL,
    function_parameters    => 'VVVFVVVFVVVVVV, VVV-VVV-VVVVVV, *, 1,6',
    expression                      => 'SYS_CONTEXT(
                                                  ''SYS_SESSION_ROLES'',
                                                  ''ROL_ADMINISTRADOR'') = 
                                                  ''FALSE''');
 END;
 
 -- CREAR LOS SIGUIENTES USUARIOS Y ROLES:
 
CREATE USER LUCAS  IDENTIFIED BY 123;
CREATE USER MATIAS IDENTIFIED BY 123;
GRANT CREATE SESSION TO LUCAS , MATIAS;
GRANT SELECT ON ENCRIPTADO.CREDIT_CARD TO LUCAS, MATIAS;

CREATE ROLE ROL_ADMINISTRADOR;
GRANT ROL_ADMINISTRADOR TO LUCAS;

 SELECT SYS_CONTEXT( 'SYS_SESSION_ROLES','ROL_ADMINISTRADOR')
FROM DUAL;

BEGIN
  DBMS_REDACT.alter_policy (
    object_schema       => 'ENCRIPTADO',
    object_name         => 'credit_card',
    policy_name         => 'CARD_PARCIAL',
    action              => DBMS_REDACT.add_column,
    column_name         => 'IDCLIENTE',
    function_type       => DBMS_REDACT.partial,
    function_parameters => 'VVVFVVVFVVVV,VVV-VVV-VVVV,#,1,6'
  );
END;


-- ***************************************************************** --
-- **              POLITICA DE REDACCI�N ALEATORIA                ** --
-- ***************************************************************** --

-- DESDE EL USUARIO ENCRIPTADO, CREAR LO SIGUIENTE:

CREATE TABLE PERSONAL  ( ID INTEGER , 
DATOS VARCHAR(100) , 
SUELDO  NUMERIC( 10)) ;

INSERT INTO PERSONAL  VALUES ( 1 , 'ROBERTO SINFUENTES ALVAREZ' , 8500 );
INSERT INTO PERSONAL  VALUES ( 2 , 'ALBERTO RAMIREZ HERRERA' ,    9300 );
INSERT INTO PERSONAL  VALUES ( 3 , 'SOFIA CARDENAS MORALES' ,     5800 );
INSERT INTO PERSONAL  VALUES ( 4 , 'LEOPOLDO MATA ROSALES' ,      4800 );
COMMIT;

-- CREAR EL SIGUIENTE USUARIO:

CREATE USER ADAN  IDENTIFIED BY 123;
GRANT CREATE SESSION TO ADAN;
GRANT SELECT ON ENCRIPTADO.PERSONAL TO ADAN;
GRANT SELECT ON ENCRIPTADO.PERSONAL TO MATIAS;

-- CREAR LA SIGUIENTE POLITICA DE REDACCION:

begin 
   dbms_redact.add_policy
   (object_schema => 'ENCRIPTADO',
   object_name => 'PERSONAL',
   policy_name => 'MASK_PERSONAL_SUELDO',
   column_name => 'SUELDO',
   function_type => DBMS_REDACT.RANDOM,
   expression => 'SYS_CONTEXT(''USERENV'', 
                          ''SESSION_USER'') = ''ADAN''');
 end;
 
 BEGIN
    DBMS_REDACT.ADD_POLICY(
        object_schema => 'ADMIN',
        object_name => 'Partidos',
        policy_name => 'redact_ubicacion',
        column_name => 'ubicacion',
        function_type => DBMS_REDACT.RANDOM
    );
END;

 
 -- DESDE EL USUARIO ADAN, HACER UN SELECT A LA TABLA. QUE SUCEDE?
 -- Y DESDE MATIAS?
 
 -- ****************************************************************** --
 -- **                  CONCEPTO DE FLASHBACK                       ** --
 -- ****************************************************************** --
 
 -- ** FLASHBACK DROP TABLE
 
 -- Usted puede utilizar Flashback Drop Table, para restaurar una tabla eliminada
 -- por error humano. Para ello hace uso de las funcionalidades de la 
 -- Papelera de Reciclaje.
--- ACTIVE LA PAPELERA DE RECICLAJE

ALTER SESSION SET RECYCLEBIN=ON;

-- CONSULTE LA PAPELERA DE RECICLAJE
SELECT * FROM RECYCLEBIN;

-- CREAR EL USUARIO �ACADEMICO� 
drop user academico;

CREATE USER ACADEMICO IDENTIFIED BY 123
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;

GRANT DBA TO ACADEMICO;

 -- CONECTARSE COMO ACADEMICO Y CREAR LA TABLA NOTAS

CREATE TABLE NOTAS ( ID INTEGER , N1 INTEGER , N2 INTEGER);
INSERT INTO NOTAS VALUES ( 1 , 12 , 15 );
INSERT INTO NOTAS VALUES ( 2 , 18 , 14 );
INSERT INTO NOTAS VALUES ( 3 , 12 , 12 );

COMMIT;

SELECT * FROM NOTAS;

-- ELIMINAR LA TABLA

DROP TABLE NOTAS;

-- CONSULTAR LA PAPELERA DE RECICLAJE

SELECT * FROM RECYCLEBIN;

-- Puede visualizar las tablas dropeadas con nuevo nombre..!!!!

-- CONSULTAR LA TABLA DROPEADA

SELECT * FROM 'BIN$iyK22aJTSsCuxJXcIzXMfA==$0';

-- RECUPERAR LA TABLA DROPEADA

FLASHBACK TABLE NOTAS TO BEFORE DROP;

SELECT * FROM NOTAS;

-- Tabla recuperada�!!!!! Y papelera de reciclaje vac�a.


-- DESDE ACADEMICO, DESACTIVAR LA PAPELERA DE RECICLAJE

ALTER SESSION SET RECYCLEBIN=OFF;

-- CREAR UNA NUEVA TABLA 

CREATE TABLE NOTAS_NEW AS SELECT * FROM NOTAS

SELECT * FROM NOTAS_NEW;

-- ELIMINAR LA TABLA NOTAS_NEW Y CONSULTE LA PAPELERA DE RECICLAJE

DROP TABLE NOTAS_NEW;

SELECT * FROM RECYCLEBIN;  

-- Debido a que la papelera esta desactivada, no es posible recuperar la tabla.

------------------------------------------------------------------------------
--- MANEJO DE 2 VERSIONES ELIMINADAS DE UNA TABLA
------------------------------------------------------------------------------

-- ACTIVAR LA PAPELERA DE RECICLAJE

ALTER SESSION SET RECYCLEBIN=ON;


-- ELIMINAR LA TABLA �NOTAS�

DROP TABLE NOTAS;

--- CONSULTAR LA PAPELERA DE RECICLAJE

SELECT * FROM RECYCLEBIN;

-- CREAR LA SIGUIENTE TABLA
CREATE TABLE EMPLEADO
(CEDULA NUMBER,
NOMBRE VARCHAR2(30),
EDAD NUMBER);

INSERT INTO EMPLEADO VALUES (100,'PAULA BETANCUR',46);
INSERT INTO EMPLEADO VALUES (200,'LINA MORALES',22);
INSERT INTO EMPLEADO VALUES (300,'MARTIN VELEZ',44);
COMMIT WORK;

--- CREAR UNA NUEVA TABLA �NOTAS�

CREATE TABLE NOTAS AS SELECT * FROM EMPLEADO;

SELECT * FROM NOTAS;

-- ELIMINAR LA TABLA �NOTAS�

DROP TABLE NOTAS;

SELECT * FROM RECYCLEBIN;

-- Se puede apreciar 2 elementos eliminados, consultemos cada versi�n

--- RECUPERAR LAS TABLAS DROPEADAS

FLASHBACK TABLE �BIN$IQtL04aFVkXgQDabvUJKEw==$0� TO BEFORE DROP
RENAME TO NOTAS01;

FLASHBACK TABLE �BIN$IQJS4aFVkXgQDabvUJKEw==$0� TO BEFORE DROP
RENAME TO NOTAS02;

SELECT * FROM NOTAS01;
SELECT * FROM NOTAS02;




 -- ** FLASHBACK TABLE
 
 -- Usando Flashback Table, se puede recuperar un conjunto de tablas a un punto 
 -- espec�fico en el tiempo sin necesidad de realizar operaciones de 
 -- recuperaci�n de punto en el tiempo tradicionales.
 
 CREATE TABLE ARTICULO  (ID  NUMBER(10) , NOMBRE CHAR(50) );
 
 ALTER TABLE ARTICULO  ENABLE ROW MOVEMENT;
 
 SELECT CURRENT_SCN FROM V$DATABASE;
 
 INSERT INTO ARTICULO   VALUES (100 , 'QUESOS' );
COMMIT;

SELECT CURRENT_SCN FROM V$DATABASE; 

INSERT INTO ARTICULO   VALUES (200 , 'FIDEOS' );
COMMIT;
SELECT CURRENT_SCN FROM V$DATABASE;

INSERT INTO ARTICULO   VALUES (300 , 'LICORES' );
COMMIT;
SELECT CURRENT_SCN FROM V$DATABASE; 

SELECT * FROM ARTICULO  ;

-- RESTAURANDO  

FLASHBACK TABLE ARTICULO   TO SCN 918960;
SELECT * FROM ARTICULO  ;

 -- ** FLASHBACK VERSION QUERY
 -- Usted puede utilizar Flashback Version Query para recuperar la historia de 
 -- una fila. La caracter�stica de Flashback Query versi�n permite utilizar 
 -- la cl�usula VERSIONES para recuperar todas las versiones de las filas que 
 -- hay entre dos puntos en el tiempo o dos SCN.
 
 CREATE TABLE CURSO 
 ( id integer, curso char(50), costo integer, FECHA DATE DEFAULT SYSDATE );

-- CAMBIO 1 
INSERT INTO CURSO VALUES ( 1 , 'ORACLE' , 350, SYSDATE ); 
COMMIT;

SELECT current_scn, TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') 
FROM v$database;

-- CAMBIO 2 Y 3
UPDATE CURSO SET CURSO = 'ORACLE 2' WHERE ID = 1 ; 
COMMIT;
UPDATE CURSO SET CURSO = 'ORACLE 3' WHERE ID = 1 ; 
COMMIT;

SELECT current_scn, TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') 
FROM v$database;

SELECT versions_startscn, versions_starttime, 
       versions_endscn, versions_endtime,
       versions_xid, versions_operation,
       curso  
FROM   curso 
       VERSIONS BETWEEN TIMESTAMP TO_TIMESTAMP('2022-05-04 16:28:09', 'YYYY-MM-DD HH24:MI:SS')
                        AND TO_TIMESTAMP('2022-05-04 16:31:10', 'YYYY-MM-DD HH24:MI:SS')
WHERE  id = 1;

SELECT versions_startscn, versions_starttime, 
       versions_endscn, versions_endtime,
       versions_xid, versions_operation,
       curso 
FROM   curso
       VERSIONS BETWEEN SCN 7802474 AND 7802475
WHERE  id = 1;


-- CONFIGURANDO MODO FLASHBACK

STARTUP MOUNT;
Alter database archivelog;
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE = 1G;
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST = '/u02/oracle/fra';
ALTER DATABASE FLASHBACK ON;
ALTER DATABASE OPEN;
-- CONSULTANDO MODO FLASHBACK
SELECT FLASHBACK_ON FROM V$DATABASE; -- ( NO/YES )
-- CONFIGURANDO TIEMPO DE RESGUARDO DE DATOS
ALTER SYSTEM SET DB_FLASHBACK_RETENTION_TARGET=2880;
-- TIEMPO DADO EN MINUTOS

-- GENERANDO ESCENARIO
-- CREANDO TABLE A RECUPERAR
CREATE TABLE PRUEBAFLASH AS SELECT * FROM scott.dept;
COMMIT;
SELECT COUNT(*) FROM PRUEBAFLASH:
-- CONSULTANDO EL SCN
SELECT DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER FROM DUAL;
--  SCN : 9999
-- BORRANDO LOS REGISTROS
DELETE FROM PRUEBAFLASH;
COMMIT;
SELECT DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER FROM DUAL;
-- SCN : 19999

-- FLASHBACK LA BD ( RESTAURACION EN UN PUNTO EN EL TIEMPO CON REFERENCIA A SCN )
STARTUP MOUNT:
FLASHBACK DATABASE TO SCN 9999;
ALTER DATABASE OPEN RESETLOGS;

-- TAREA: QUE ES RESETLOGS EN ESTA INSTRUCCI�N?
-- TAREA: Y COMO SE HACE EL FLASHBACK QUERY A UN PUNTO DEL TIEMPO?
-- QU� ES EL ROW MOVEMENT?
-- TAREA: Y QUE ES EL FLASHBACK A NIVEL DE BASE DE DATOS CON RESTORE POINT?


 








 -- ** FLASHBACK VERSION QUERY
 -- Usted puede utilizar Flashback Version Query para recuperar la historia de 
 -- una fila. La caracter stica de Flashback Query versi n permite utilizar 
 -- la cl usula VERSIONES para recuperar todas las versiones de las filas que 
 -- hay entre dos puntos en el tiempo o dos SCN.
 
 CREATE TABLE CURSO 
 ( id integer, curso char(50), costo integer, FECHA DATE DEFAULT SYSDATE );

-- CAMBIO 1 
INSERT INTO CURSO VALUES ( 1 , 'ORACLE' , 350, SYSDATE ); 
COMMIT;

SELECT current_scn, TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') 
FROM v$database;

-- CAMBIO 2 Y 3
UPDATE CURSO SET CURSO = 'ORACLE 2' WHERE ID = 1 ; 
COMMIT;
UPDATE CURSO SET CURSO = 'ORACLE 2' WHERE ID = 1 ; 
COMMIT;

SELECT current_scn, TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') 
FROM v$database;

SELECT versions_startscn, versions_starttime, 
       versions_endscn, versions_endtime,
       versions_xid, versions_operation,
       curso  
FROM   curso 
       VERSIONS BETWEEN TIMESTAMP TO_TIMESTAMP('2022-05-04 16:28:09', 'YYYY-MM-DD HH24:MI:SS')
                        AND TO_TIMESTAMP('2022-05-04 16:31:10', 'YYYY-MM-DD HH24:MI:SS')
WHERE  id = 1;

SELECT versions_startscn, versions_starttime, 
       versions_endscn, versions_endtime,
       versions_xid, versions_operation,
       curso 
FROM   curso
       VERSIONS BETWEEN SCN 7802474 AND 7802475
WHERE  id = 1;
