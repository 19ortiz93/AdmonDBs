-- *************************************************************** --
-- **                  DATA MASKING                             ** --
-- *************************************************************** --
-- Linea que permite realizar operaciones de usuario
ALTER SESSION SET "_oracle_script" = true;
-- CREAR UN USUARIO LLAMADO ENCRIPTADO

CREATE USER ENCRIPTADO IDENTIFIES BY 123;

GRANT ALL PRIVILEGES TO ENCRIPTADO;

-- CONECTADOS CON EL USUARIO RECIEN CREADO:

CREATE TABLE EMPLEADO
(NOMBRE VARCHAR2(30),
APELLIDO VARCHAR2(30),
FECHACON DATE,
SUELDO NUMBER;

INSERT INTO EMPLEADO VALUES ('JORGE','BEDOYA','20-08-1967',340000);
INSERT INTO EMPLEADO VALUES ('PAULA','BETANCUR','20-08-1967',347888);
INSERT INTO EMPLEADO VALUES ('CRISTINA','GALEANO','20-08-1967',55555);
INSERT INTO EMPLEADO VALUES ('ESMERALDA','PORRAS','20-08-1967',678888);
INSERT INTO EMPLEADO VALUES ('MANUELA','TENGANAN','20-08-1967',123333);
INSERT INTO EMPLEADO VALUES ('LUIS','SUAREZ','20-08-1967',33333);

SELECT * FROM EMPLEADO;

-- ***************************************************************** --
-- **              POLITICA DE REDACCI N TOTAL                    ** --
-- ***************************************************************** --

-- LUEGO VAMOS A CREAR UNA POLITICA DE REDACCION FULL, DESDE EL USUARIO
-- ADMINISTRADOR

-- LA SIGUIENTE POLITICA APLICA PARA TODOS LOS USUARIOS, INCLUIDO EL DUE O
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
object_name => 'BIN$uU9m8JBdQfqyngXsAQ2PvA==$0',
policy_name => 'DMSK_FECHACON');
END;

-- LA SIGUIENTE POLITICA APLICA PARA TODOS LOS USUARIOS, MENOS PARA EL DUE O
-- DE LA TABLA, EL USUARIO ENCRIPTADO.

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

-- HACER UN SELECT DE LA TABLA DESDE OTRO USUARIO. QU  SUCEDE?


-- COMO VER LAS POLITICAS DE REDACCION CREADAS?

SELECT * FROM redaction_policies;

-- COMO VER LOS VALORES, POR DEFECTO, DE LOS CAMPOS REDACTADOS?

SELECT * 
FROM REDACTION_VALUES_FOR_TYPE_FULL 

-- COMO CAMBIAR UN VALOR POR DEFECTO?

exec dbms_redact.UPDATE_FULL_REDACTION_VALUES ( varchar_val => 'X' );

-- ***************************************************************** --
-- **              POLITICA DE REDACCI N PARCIAL                  ** --
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
    object_schema       => 'PAULABETANCUR',
    object_name         => 'credit_card',
    policy_name         => 'CARD_PARCIAL',
    action              => DBMS_REDACT.add_column,
    column_name         => 'IDCLIENTE',
    function_type       => DBMS_REDACT.partial,
    function_parameters => 'VVVFVVVFVVVV,VVV-VVV-VVVV,#,1,6'
  );
END;

-- CREAR EL SIGUIENTE USUARIO:

CREATE USER ADAN  IDENTIFIED BY 123;
GRANT CREATE SESSION TO ADAN;
GRANT SELECT ON ENCRIPTADO.PERSONAL TO ADAN;
GRANT SELECT ON ENCRIPTADO.PERSONAL TO MATIAS;

-- ***************************************************************** --
-- **              POLITICA DE REDACCI N ALEATORIA                ** --
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
 
 -- DESDE EL USUARIO ADAN, HACER UN SELECT A LA TABLA. QUE SUCEDE?
 -- Y DESDE MATIAS?
 

