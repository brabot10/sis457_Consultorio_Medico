﻿-- DDL
CREATE DATABASE BDcardiologia; 


USE master
GO
CREATE LOGIN usrcardiologia WITH PASSWORD=N'654321',
	DEFAULT_DATABASE=BDcardiologia,
	CHECK_EXPIRATION=OFF,
	CHECK_POLICY=ON
GO
USE BDcardiologia
GO        
CREATE USER usrcardiologia FOR LOGIN usrcardiologia
GO
ALTER ROLE db_owner ADD MEMBER usrcardiologia
GO



DROP TABLE Usuario;
DROP TABLE Personal;
DROP TABLE Paciente;
DROP TABLE Cita;
DROP TABLE Historial;

CREATE TABLE Personal (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  cedulaIdentidad VARCHAR(15) NOT NULL,
  nombres VARCHAR(20) NOT NULL,
  primerApellido VARCHAR(20) NULL,
  segundoApellido VARCHAR(20) NULL,
  direccion VARCHAR(250) NOT NULL,
  celular BIGINT NOT NULL,
  cargo VARCHAR(30) NOT NULL
);
CREATE TABLE Usuario (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  idPersonal INT NOT NULL,
  usuario VARCHAR(12) NOT NULL,
  clave VARCHAR(100) NOT NULL
  CONSTRAINT fk_Usuario_Personal FOREIGN KEY(idPersonal) REFERENCES Personal(id)
);

CREATE TABLE Paciente (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  idPersonal INT NOT NULL,
  nombres VARCHAR(20) NOT NULL,
  cedulaIdentidad VARCHAR(15) NOT NULL,
  alergias VARCHAR(250) NULL,
  fechaNacimiento DATE NOT NULL,
  celular BIGINT NOT NULL
  CONSTRAINT fk_Paciente_Personal FOREIGN KEY(idPersonal) REFERENCES Personal(id)
);

CREATE TABLE Cita (
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  idPaciente INT NOT NULL,
  fecha DATE NOT NULL,
  hora VARCHAR(20) NOT NULL,
  tratamiento VARCHAR(250) NOT NULL,
  pago VARCHAR(20) NOT NULL,
  aCuenta VARCHAR(15) NOT NULL
  CONSTRAINT fk_Cita_Paciente FOREIGN KEY(idPaciente) REFERENCES Paciente(id) 
);

CREATE TABLE Historial(
  id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  idPaciente INT NOT NULL,
  diagnostico VARCHAR(250) NOT NULL,
  observaciones VARCHAR(250) NOT NULL,
  fecha DATE NOT NULL
  CONSTRAINT fk_Historial_Paciente FOREIGN KEY(idPaciente) REFERENCES Paciente(id)
);
ALTER TABLE Personal ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Personal ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Personal ADD estado SMALLINT NOT NULL DEFAULT 1; -- -1: Eliminación lógica, 0: Inactivo, 1: Activo

ALTER TABLE Usuario ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Usuario ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Usuario ADD estado SMALLINT NOT NULL DEFAULT 1; -- -1: Eliminación lógica, 0: Inactivo, 1: Activo

ALTER TABLE Paciente ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Paciente ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Paciente ADD estado SMALLINT NOT NULL DEFAULT 1; -- -1: Eliminación lógica, 0: Inactivo, 1: Activo

ALTER TABLE Cita ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Cita ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Cita ADD estado SMALLINT NOT NULL DEFAULT 1; -- -1: Eliminación lógica, 0: Inactivo, 1: Activo

ALTER TABLE Historial ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Historial ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Historial ADD estado SMALLINT NOT NULL DEFAULT 1; -- -1: Eliminación lógica, 0: Inactivo, 1: Activo



CREATE PROC paPersonalListar @parametro1 VARCHAR(50) 
AS
  SELECT id, cedulaIdentidad, nombres, primerApellido, segundoApellido, direccion, celular, cargo, usuarioRegistro, fechaRegistro, estado 
  FROM Personal  
  WHERE estado<>-1 AND nombres LIKE '%'+REPLACE(@parametro1,' ','%')+'%';

EXEC paPersonalListar 'Juan';


--DML

INSERT INTO Personal (cedulaIdentidad, nombres, primerApellido, segundoApellido, direccion, celular, cargo)
VALUES ('123456789', 'Jose', 'Lopez', 'Guzman', 'Calle loa', 7987678, 'Médico');

INSERT INTO Personal (cedulaIdentidad, nombres, primerApellido, segundoApellido, direccion, celular, cargo)
VALUES ('987654321', 'Andrea', 'Gomez', 'Serrudo', 'Calle Junin', 6768689, 'Secretaria');



SELECT * FROM Personal WHERE estado=1;

SELECT * FROM Usuario;

INSERT INTO Usuario(usuario, clave, idPersonal)
VALUES ('daniela', '1234', 1),
       ('Jose', '1234', 2);

SELECT * FROM Usuario;

-- PROCEDIMIENTOS ALTERADOS FUNCIONALES
CREATE PROC paCitaListar 
  @parametro3 VARCHAR(50)
AS
BEGIN
  -- Mostrar resultados
  SELECT 
    Cita.id, 
    Paciente.nombres AS nombresPaciente,
    Cita.fecha, 
    Cita.hora, 
    Cita.tratamiento, 
    Cita.pago, 
    Cita.aCuenta, 
    Cita.usuarioRegistro, 
    Cita.fechaRegistro, 
    Cita.estado
  FROM Cita
  INNER JOIN Paciente ON Cita.idPaciente = Paciente.id
  WHERE Cita.estado <> -1 AND Paciente.nombres LIKE '%' + REPLACE(@parametro3, ' ', '%') + '%';
END;

 	-- Doctor Asignado Pacientes

CREATE PROC paPacienteListar 
  @parametro2 VARCHAR(50)
AS
BEGIN
  -- Mostrar resultados
  SELECT 
    Paciente.id, 
    Paciente.idPersonal, 
    Personal.nombres AS nombresPersonal,
    Paciente.cedulaIdentidad, 
    Paciente.nombres, 
    Paciente.alergias, 
    Paciente.fechaNacimiento, 
    Paciente.celular, 
    Paciente.usuarioRegistro, 
    Paciente.fechaRegistro, 
    Paciente.estado
  FROM Paciente
  INNER JOIN Personal ON Paciente.idPersonal = Personal.id
  WHERE Paciente.estado <> -1 AND Paciente.nombres LIKE '%' + REPLACE(@parametro2, ' ', '%') + '%';
END;

-- Ejecutar el procedimiento almacenado
EXEC paPacienteListar 'María';





 	-- Encargado  Usuario

CREATE PROC paUsuarioListar 
  @parametro VARCHAR(50)
AS
BEGIN
  -- Mostrar resultados
  SELECT 
    Usuario.id, 
    Usuario.idPersonal, 
    Personal.nombres AS nombresPersonal,
    Usuario.usuario, 
    Usuario.clave, 
    Usuario.usuarioRegistro, 
    Usuario.fechaRegistro, 
    Usuario.estado
  FROM Usuario
  INNER JOIN Personal ON Usuario.idPersonal = Personal.id
  WHERE Usuario.estado <> -1 AND Usuario.usuario LIKE '%' + REPLACE(@parametro, ' ', '%') + '%';
END;

-- Ejecutar el procedimiento almacenado
EXEC paUsuarioListar 'daniela';


	-- Nombre del pac

    
CREATE PROC paHistorialListar 
  @parametro4 VARCHAR(50)
AS
BEGIN
  SELECT 
    Historial.id, 
    Historial.idPaciente, 
    Paciente.nombres AS nombresPaciente,
    Historial.diagnostico, 
    Historial.observaciones, 
    Historial.fecha, 
    Historial.usuarioRegistro, 
    Historial.fechaRegistro, 
    Historial.estado
FROM Historial
INNER JOIN Paciente ON Historial.idPaciente = Paciente.id
WHERE Historial.estado <> -1 AND Paciente.nombres LIKE '%' + REPLACE(@parametro4, ' ', '%') + '%';
END;

-- Ejecutar el procedimiento almacenado
EXEC paHistorialListar 'Marcapaso';