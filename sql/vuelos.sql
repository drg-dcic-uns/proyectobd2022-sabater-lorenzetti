#Archivo batch (vuelos.sql) para la creación de la
#Base de datos del práctico de SQL

#Lo que esta después del "#" es un comentario

# Creo de la Base de Datos
CREATE DATABASE vuelos;

# selecciono la base de datos sobre la cual voy a hacer modificaciones
USE vuelos;

#-------------------------------------------------------------------------
# Creación Tablas para las entidades

CREATE TABLE ubicaciones(
	pais VARCHAR(20) NOT NULL,
	estado VARCHAR(20) NOT NULL,
	ciudad VARCHAR(20) NOT NULL,
	huso INT CHECK(huso >= -12 and huso<=12) NOT NULL,
	PRIMARY KEY(pais,estado,ciudad)
)ENGINE=InnoDB;

CREATE TABLE aeropuertos(
	codigo VARCHAR(3) NOT NULL,
	nombre VARCHAR(40) NOT NULL,
	telefono VARCHAR(15) NOT NULL,
	direccion VARCHAR(30) NOT NULL,
	pais VARCHAR(20) NOT NULL,
	estado VARCHAR(20) NOT NULL,
	ciudad VARCHAR(20) NOT NULL,
	
	PRIMARY KEY(codigo),
	
	CONSTRAINT FK_aeropuerto_ubicaciones_pais_estado_ciudad
	FOREIGN KEY (pais,estado,ciudad) REFERENCES ubicaciones (pais,estado,ciudad)
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE comodidades(
	codigo INT unsigned NOT NULL,
	descripcion TEXT NOT NULL,
	PRIMARY KEY(codigo)
)ENGINE=InnoDB;

CREATE TABLE modelos_avion (
	modelo VARCHAR(20) NOT NULL,
	fabricante VARCHAR(20) NOT NULL,
	cabinas INT unsigned NOT NULL,
	cant_asientos INT unsigned NOT NULL,
	PRIMARY KEY(modelo)
)ENGINE=InnoDB;

CREATE TABLE pasajeros(
	doc_nro INT unsigned NOT NULL,
	doc_tipo VARCHAR(30) NOT NULL,
	apellido VARCHAR(20) NOT NULL,
	nombre VARCHAR(20) NOT NULL,
	direccion VARCHAR(40) NOT NULL,
	telefono VARCHAR(15) NOT NULL,
	nacionalidad VARCHAR(20) NOT NULL,

	PRIMARY KEY(doc_tipo,doc_nro)
)ENGINE=InnoDB;

CREATE TABLE empleados(
	legajo INT unsigned NOT NULL,
	password VARCHAR(32) NOT NULL,
	doc_nro INT unsigned NOT NULL,
	doc_tipo VARCHAR(30) NOT NULL,
	apellido VARCHAR(20) NOT NULL,
	nombre VARCHAR(20) NOT NULL,
	direccion VARCHAR(40) NOT NULL,
	telefono VARCHAR(15) NOT NULL,
	
	PRIMARY KEY(legajo)
)ENGINE=InnoDB;

CREATE TABLE reservas(
	numero INT unsigned NOT NULL AUTO_INCREMENT,
	fecha DATE NOT NULL,
	vencimiento DATE NOT NULL,
	estado VARCHAR(15) NOT NULL,
	doc_nro INT unsigned NOT NULL,
	doc_tipo VARCHAR(30) NOT NULL,
	legajo INT unsigned NOT NULL,
	
	PRIMARY KEY(numero),

	CONSTRAINT FK_reservas_doc_pasajeros
	FOREIGN KEY (doc_tipo,doc_nro) REFERENCES pasajeros (doc_tipo,doc_nro)
		ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT FK_reservas_legajo_empleados
	FOREIGN KEY (legajo) REFERENCES empleados (legajo)
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE clases (
	nombre VARCHAR(20) NOT NULL,
	porcentaje decimal (2,2) unsigned NOT NULL,
	check(porcentaje >= 0.0 and porcentaje <= 0.99),
	PRIMARY KEY (nombre)
)ENGINE=InnoDB;

CREATE TABLE vuelos_programados (
	numero VARCHAR(10) NOT NULL,
 	aeropuerto_salida VARCHAR(45) NOT NULL,
 	aeropuerto_llegada VARCHAR(45) NOT NULL,
 
 	CONSTRAINT pk_numero
 	PRIMARY KEY (numero),

 	CONSTRAINT FK_aeropuerto_salida
 	FOREIGN KEY (aeropuerto_salida) REFERENCES aeropuertos(codigo) 
 	ON DELETE RESTRICT ON UPDATE CASCADE,

 	CONSTRAINT FK_aeropuerto_llegada
 	FOREIGN KEY (aeropuerto_llegada) REFERENCES aeropuertos(codigo) 
 	ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE salidas (
	hora_sale TIME NOT NULL,
	hora_llega TIME NOT NULL,
	dia ENUM('Do','Lu','Ma','Mi','Ju','Vi','Sa'),
	vuelo VARCHAR(10) NOT NULL,
	modelo_avion VARCHAR(20) NOT NULL,
	PRIMARY KEY (vuelo,dia),
	CONSTRAINT FK_llega_vuelos_programados_numero_salidas
	FOREIGN KEY (vuelo) REFERENCES vuelos_programados (numero)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT FK_modelos_avion
 	FOREIGN KEY (modelo_avion) REFERENCES modelos_avion(modelo) 
 	ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

#Relaciones

CREATE TABLE instancias_vuelo(
	vuelo VARCHAR(10) NOT NULL,
	fecha DATE NOT NULL,
	dia ENUM('Do','Lu','Ma','Mi','Ju','Vi','Sa') NOT NULL,
	estado VARCHAR(15),
	PRIMARY KEY(vuelo,fecha),
	CONSTRAINT FK_instancias_vuelo_salidas_dia
	FOREIGN KEY (vuelo,dia) REFERENCES salidas (vuelo,dia)
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE ubicado_en(
	codigo VARCHAR(3) NOT NULL,
	pais VARCHAR(30) NOT NULL,
	estado VARCHAR(30) NOT NULL,
	ciudad VARCHAR(30) NOT NULL,
	PRIMARY KEY(codigo),
	CONSTRAINT FK_ubicado_en_aeropuerto_codigo
	FOREIGN KEY (codigo) REFERENCES aeropuertos (codigo)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT FK_ubicado_en_ubicaciones_pais_estado_ciudad
	FOREIGN KEY (pais,estado,ciudad) REFERENCES ubicaciones (pais,estado,ciudad)
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE sale(
	numero VARCHAR(10) NOT NULL,
	codigo VARCHAR(3) NOT NULL,
	PRIMARY KEY(numero),
	CONSTRAINT FK_sale_vuelos_programados_numero
	FOREIGN KEY (numero) REFERENCES vuelos_programados (numero)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT FK_sale_aeropuerto_codigo
	FOREIGN KEY (codigo) REFERENCES aeropuertos (codigo)
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE llega(
	numero VARCHAR(10) NOT NULL,
	codigo VARCHAR(3) NOT NULL,
	PRIMARY KEY(numero),
	CONSTRAINT FK_llega_vuelos_programados_numero
	FOREIGN KEY (numero) REFERENCES vuelos_programados (numero)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT FK_llega_aeropuerto_codigo
	FOREIGN KEY (codigo) REFERENCES aeropuertos (codigo)
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE asignado(
	numero VARCHAR(10) NOT NULL,
	modelo VARCHAR(30) NOT NULL,
	PRIMARY KEY(numero),
	CONSTRAINT FK_asignado_salidas
	FOREIGN KEY (numero) REFERENCES salidas (vuelo)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT FK_asignado_modelos_avion
	FOREIGN KEY (modelo) REFERENCES modelos_avion (modelo)
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE asociada(
	numero INT unsigned NOT NULL,
	legajo INT unsigned NOT NULL,
	doc_nro INT unsigned NOT NULL,
	doc_tipo VARCHAR(30) NOT NULL,
	
	CONSTRAINT FK_asociada_numero_reservas
	FOREIGN KEY (numero) REFERENCES reservas (numero)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_asociada_legajo_empleados
	FOREIGN KEY (legajo) REFERENCES empleados (legajo)
		ON DELETE RESTRICT ON UPDATE CASCADE,
		
	CONSTRAINT FK_asociada_doc_pasajeros
	FOREIGN KEY (doc_tipo,doc_nro) REFERENCES pasajeros (doc_tipo,doc_nro)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT PK_asociada
	PRIMARY KEY(numero)
)ENGINE=InnoDB;

CREATE TABLE asientos_reservados(
	vuelo VARCHAR(10) NOT NULL,
	fecha DATE NOT NULL,
	clase VARCHAR(20) NOT NULL,
	cantidad INT unsigned NOT NULL,
	PRIMARY KEY(vuelo,fecha,clase),
	CONSTRAINT FK_asientos_reservados_instancias_vuelo_vuelo
	FOREIGN KEY (vuelo,fecha) REFERENCES instancias_vuelo (vuelo,fecha)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT FK_asientos_reservados_clases_nombre
	FOREIGN KEY (clase) REFERENCES clases (nombre)
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE posee(
	clase VARCHAR(20) NOT NULL,
	comodidad INT unsigned NOT NULL,
	PRIMARY KEY (clase,comodidad),
	CONSTRAINT FK_posee_clases_nombre
	FOREIGN KEY (clase) REFERENCES clases (nombre)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT FK_posee_comodidades_codigo
	FOREIGN KEY (comodidad) REFERENCES comodidades (codigo)
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE brinda(
	precio decimal(7,2) unsigned NOT NULL,
	cant_asientos INT unsigned NOT NULL,
	clase VARCHAR(20) NOT NULL,
	vuelo VARCHAR(10) NOT NULL,
	dia ENUM('Do','Lu','Ma','Mi','Ju','Vi','Sa'),
	PRIMARY KEY (clase,vuelo,dia),

	CONSTRAINT FK_brinda_clases_nombre
	FOREIGN KEY (clase) REFERENCES clases (nombre)
		ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT FK_brinda_salidas_dia
	FOREIGN KEY (vuelo,dia) REFERENCES salidas (vuelo,dia)
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE reserva_vuelo_clase(
	numero INT unsigned NOT NULL AUTO_INCREMENT,
	vuelo VARCHAR(10) NOT NULL,
	fecha_vuelo DATE NOT NULL,
	clase VARCHAR(20) NOT NULL,

	CONSTRAINT PK_reserva_vuelo_clase
	PRIMARY KEY(vuelo,fecha_vuelo,numero),
	
	CONSTRAINT FK_reserva_vuelo_clase_numero_reserva
	FOREIGN KEY (numero) REFERENCES reservas (numero)
		ON DELETE RESTRICT ON UPDATE CASCADE,
		
	CONSTRAINT FK_reserva_vuelo_clase_vuelo_instancias_vuelo
	FOREIGN KEY (vuelo,fecha_vuelo) REFERENCES instancias_vuelo (vuelo,fecha)
		ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT FK_reserva_vuelo_clase_clase
 	FOREIGN KEY (clase) REFERENCES clases(nombre)
 		ON DELETE RESTRICT ON UPDATE RESTRICT
)ENGINE=InnoDB;

#---------------------------------------------------------------------------------------------------------------------
#VISTAS
CREATE VIEW vuelos_disponibles AS 
SELECT 	salidas.vuelo AS "nro_vuelo",
		salidas.modelo_avion AS "modelo",
		instancias_vuelo.fecha AS "fecha",
		salidas.dia AS "dia_sale",
		salidas.hora_sale AS "hora_sale",
		salidas.hora_llega AS "hora_llega",
		
		TIMEDIFF(salidas.hora_llega,salidas.hora_sale) AS "tiempo_estimado",

		s.codigo AS "codigo_aero_sale",
		s.nombre AS "nombre_aero_sale",
		s.ciudad AS "ciudad_sale",
		s.estado  AS "estado_sale",
		s.pais AS "pais_sale",

		l.codigo AS "codigo_aero_llega",
		l.nombre AS "nombre_aero_llega",
		l.ciudad AS "ciudad_llega",
		l.estado  AS "estado_llega",
		l.pais AS "pais_llega",

		brinda.precio AS "precio",
		round(((brinda.cant_asientos + clases.porcentaje*brinda.cant_asientos)-asientos_reservados.cantidad)) AS "asientos_disponibles",
		clases.nombre AS "clase"

FROM 	(((((instancias_vuelo NATURAL JOIN salidas) JOIN vuelos_programados on vuelos_programados.numero=salidas.vuelo)
			JOIN aeropuertos as s on s.codigo = vuelos_programados.aeropuerto_salida) JOIN aeropuertos as l on l.codigo = vuelos_programados.aeropuerto_llegada)
			NATURAL JOIN brinda JOIN clases on clases.nombre = brinda.clase) NATURAL JOIN asientos_reservados;
#---------------------------------------------------------------------------------------------------------------------
#USUARIOS 

#Admimn
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON vuelos.* TO 'admin'@'localhost' WITH GRANT OPTION;

#Empleado
CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';
GRANT SELECT ON vuelos.* TO 'empleado'@'%';
GRANT INSERT, UPDATE, DELETE ON vuelos.reservas TO 'empleado'@'%';
GRANT INSERT, UPDATE, DELETE ON vuelos.pasajeros TO 'empleado'@'%';
GRANT INSERT, UPDATE, DELETE ON vuelos.reserva_vuelo_clase TO 'empleado'@'%';

#Cliente
CREATE USER 'cliente'@'%'  IDENTIFIED BY 'cliente';
GRANT SELECT ON vuelos.vuelos_disponibles TO 'cliente'@'%';

