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
#TRANSACCIONES Y STORED PROCEDURES
delimiter !

CREATE PROCEDURE reserva_ida (IN numeroVuelo VARCHAR (10), IN fechaVuelo DATE, IN claseVuelo VARCHAR (20), 
							  IN tipoDocPas VARCHAR (30), IN numDocPas INT,
							  IN legajoEmp INT)

	BEGIN
		
		DECLARE asientosR INT;
		DECLARE asientosD INT;
		DECLARE asientosF INT;
		DECLARE diaVencimiento DATE;

		DECLARE codigo_SQL  CHAR(5) DEFAULT '00000';	 
		DECLARE codigo_MYSQL INT DEFAULT 0;
	 	DECLARE mensaje_error TEXT;
	 	DECLARE numero_error INT DEFAULT 0;
		DECLARE EXIT HANDLER FOR SQLEXCEPTION 	 	 
	  	BEGIN 
	    	GET DIAGNOSTICS CONDITION 1 codigo_MYSQL= MYSQL_ERRNO, codigo_SQL= RETURNED_SQLSTATE, mensaje_error= MESSAGE_TEXT;
	    	SELECT -2 INTO numero_error;
	    	SELECT 'SQLEXCEPTION!, transaccion abortada' AS resultado, codigo_MySQL, codigo_SQL,  mensaje_error;		
        	ROLLBACK;
	 	END;	      
	 	START TRANSACTION;
	 		IF EXISTS (SELECT doc_tipo, doc_nro FROM pasajeros WHERE pasajeros.doc_tipo = tipoDocPas AND pasajeros.doc_nro = numDocPas) AND
	 		   EXISTS (SELECT legajo FROM empleados WHERE empleados.legajo = legajoEmp) AND
	 		   EXISTS (SELECT nro_vuelo, fecha, clase FROM vuelos_disponibles WHERE vuelos_disponibles.nro_vuelo = numeroVuelo AND vuelos_disponibles.fecha = fechaVuelo AND vuelos_disponibles.clase = claseVuelo)
	 		   
	 				
	 		 THEN
	   			SELECT cantidad FROM asientos_reservados WHERE asientos_reservados.vuelo = numeroVuelo AND asientos_reservados.fecha = fechaVuelo AND asientos_reservados.clase = claseVuelo FOR UPDATE;

	   			SELECT cantidad INTO asientosR FROM asientos_reservados WHERE asientos_reservados.vuelo = numeroVuelo AND asientos_reservados.fecha = fechaVuelo AND asientos_reservados.clase = claseVuelo;

	   			SELECT cant_asientos INTO asientosF FROM brinda NATURAL JOIN instancias_vuelo WHERE instancias_vuelo.vuelo = numeroVuelo AND instancias_vuelo.fecha = fechaVuelo AND brinda.clase = claseVuelo; 	

	   			SELECT asientos_disponibles INTO asientosD FROM vuelos_disponibles
	   				WHERE vuelos_disponibles.nro_vuelo = numeroVuelo AND vuelos_disponibles.fecha = fechaVuelo AND vuelos_disponibles.clase = claseVuelo;

	   			SELECT DATE_SUB(fechaVuelo, INTERVAL 15 DAY) INTO diaVencimiento;

	   			IF (asientosD > 0) THEN
	   				IF (asientosF > asientosR) THEN 	   		
	   					INSERT INTO reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo)
	   						VALUES (CURDATE(), diaVencimiento,"Confirmada", numDocPas, tipoDocPas, legajoEmp);
	   				ELSE	   		
	   					INSERT INTO reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo)
	   						VALUES (CURDATE(), diaVencimiento,"En Espera", numDocPas, tipoDocPas, legajoEmp);
	   				END IF;
	   				UPDATE asientos_reservados SET cantidad = cantidad + 1
	   					WHERE asientos_reservados.vuelo = numeroVuelo AND
	   					 	  asientos_reservados.fecha = fechaVuelo AND
	   					  	  asientos_reservados.clase = claseVuelo;

	   				INSERT INTO reserva_vuelo_clase (numero, vuelo, fecha_vuelo, clase)
	   					VALUES (LAST_INSERT_ID(), numeroVuelo, fechaVuelo, claseVuelo);
	   			
	   				SELECT LAST_INSERT_ID() AS numeroDeReserva, "La reserva se realizo con exitos" AS resultado;
	   			ELSE
	   				SELECT -1 INTO numero_error;
	   				SELECT numero_error, "No se realizo con exitos la reserva, falta de asientos disponibles" AS resultado;
	   			END IF;

	   		ELSE
	   			SELECT -1 INTO numero_error;
	   			SELECT numero_error, "No se realizo con exitos la reserva, datos inexistentes" AS resultado;
	   		END IF;	   		
	   		
	 	COMMIT;   
	END !
delimiter ;
delimiter !
CREATE PROCEDURE reserva_ida_vuelta (IN numeroVueloIda VARCHAR (10), IN fechaVueloIda DATE, IN claseVueloIda VARCHAR (20),
								     IN numeroVueloVuelta VARCHAR (10), IN fechaVueloVuelta DATE, IN claseVueloVuelta VARCHAR (20), 
							 	     IN tipoDocPas VARCHAR (30), IN numDocPas INT,
							 	     IN legajoEmp INT)
	BEGIN
		
		DECLARE asientosRIda INT;
		DECLARE asientosDIda INT;
		DECLARE asientosRVuelta INT;
		DECLARE asientosDVuelta INT;
		DECLARE diaVencimientoIda DATE;
		DECLARE diaVencimientoVuelta DATE;
		DECLARE asientosFIda INT;
		DECLARE asientosFVuelta INT;

		DECLARE codigo_SQL  CHAR(5) DEFAULT '00000';	 
	 	DECLARE codigo_MYSQL INT;
	 	DECLARE mensaje_error TEXT;
	 	DECLARE numero_error INT;
		DECLARE EXIT HANDLER FOR SQLEXCEPTION 	 	 
	  	BEGIN 
	    	GET DIAGNOSTICS CONDITION 1 codigo_MYSQL= MYSQL_ERRNO, codigo_SQL= RETURNED_SQLSTATE, mensaje_error= MESSAGE_TEXT;
	    	SELECT -2 INTO numero_error;
	    	SELECT 'SQLEXCEPTION!, transaccion abortada' AS resultado, codigo_MySQL, codigo_SQL,  mensaje_error;		
        	ROLLBACK;
	 	END;

	 	START TRANSACTION;
	 		IF EXISTS (SELECT doc_tipo, doc_nro FROM pasajeros WHERE doc_tipo = tipoDocPas AND doc_nro = numDocPas) AND
	 		   EXISTS (SELECT legajo FROM empleados WHERE empleados.legajo = legajoEmp) AND
	 		   EXISTS (SELECT nro_vuelo, fecha, clase FROM vuelos_disponibles WHERE nro_vuelo = numeroVueloIda AND fecha = fechaVueloIda AND clase = claseVueloIda) AND
	 		   EXISTS (SELECT nro_vuelo, fecha, clase FROM vuelos_disponibles WHERE nro_vuelo = numeroVueloVuelta AND fecha = fechaVueloVuelta AND clase = claseVueloVuelta)
	 		 THEN
	 			SELECT cantidad FROM asientos_reservados WHERE asientos_reservados.vuelo = numeroVueloIda AND fecha = fechaVueloIda AND clase = claseVueloIda FOR UPDATE;
				SELECT cantidad FROM asientos_reservados WHERE asientos_reservados.vuelo = numeroVueloVuelta AND fecha = fechaVueloVuelta AND clase = claseVueloVuelta FOR UPDATE;	 		

	   			SELECT cantidad INTO asientosRIda FROM asientos_reservados 
	   				WHERE asientos_reservados.vuelo = numeroVueloIda AND fecha = fechaVueloIda AND clase = claseVueloIda;

	   			SELECT cant_asientos INTO asientosFIda FROM brinda NATURAL JOIN instancias_vuelo 
	   				WHERE instancias_vuelo.vuelo = numeroVueloIda AND fecha = fechaVueloIda AND clase = claseVueloIda; 	

	   			SELECT asientos_disponibles INTO asientosDIda FROM vuelos_disponibles
	   				WHERE vuelos_disponibles.nro_vuelo = numeroVueloIda AND vuelos_disponibles.fecha = fechaVueloIda AND clase = claseVueloIda;

	   			SELECT cantidad INTO asientosRVuelta FROM asientos_reservados
	   				WHERE vuelo = numeroVueloVuelta AND fecha = fechaVueloVuelta AND clase = claseVueloVuelta; 	

	   			SELECT cant_asientos INTO asientosFVuelta FROM brinda NATURAL JOIN instancias_vuelo
	   				WHERE instancias_vuelo.vuelo = numeroVueloVuelta AND fecha = fechaVueloVuelta AND clase = claseVueloVuelta;

	   			SELECT asientos_disponibles INTO asientosDVuelta FROM vuelos_disponibles
	   				WHERE vuelos_disponibles.nro_vuelo = numeroVueloVuelta AND vuelos_disponibles.fecha = fechaVueloVuelta AND clase = claseVueloVuelta;

	   			SELECT DATE_SUB(fechaVueloIda, INTERVAL 15 DAY) INTO diaVencimientoIda;
	   			SELECT DATE_SUB(fechaVueloVuelta, INTERVAL 15 DAY) INTO diaVencimientoVuelta;
	 
	   			IF (asientosDIda > 0) AND (asientosDVuelta > 0) THEN
	   				IF (asientosFIda > asientosRIda) AND (asientosFVuelta > asientosRVuelta) THEN
	   					INSERT INTO reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo)
	   						VALUES (CURDATE(), diaVencimientoIda, "Confirmada", numDocPas, tipoDocPas, legajoEmp);	   		
	   			
	   					INSERT INTO reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo)
	   						VALUES (CURDATE(), diaVencimientoVuelta, "Confirmada", numDocPas, tipoDocPas, legajoEmp);
	   				ELSE
	   					INSERT INTO reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo)
	   						VALUES (CURDATE(), diaVencimientoIda, "En Espera", numDocPas, tipoDocPas, legajoEmp);	   		
	   			
	   					INSERT INTO reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo)
	   						VALUES (CURDATE(), diaVencimientoVuelta, "En Espera", numDocPas, tipoDocPas, legajoEmp);
	   				END IF; 
	
	   				

	   				UPDATE asientos_reservados SET cantidad = cantidad + 1
	   					WHERE asientos_reservados.vuelo = numeroVueloIda AND
	   					 	asientos_reservados.fecha = fechaVueloIda AND
	   					 	asientos_reservados.clase = claseVueloIda;

	   				UPDATE asientos_reservados SET cantidad = cantidad + 1
	   					WHERE asientos_reservados.vuelo = numeroVueloVuelta AND
	   					  	asientos_reservados.fecha = fechaVueloVuelta AND
	   					  	asientos_reservados.clase = claseVueloVuelta;
	   			
	   				INSERT INTO reserva_vuelo_clase (numero, vuelo, fecha_vuelo, clase)
	   					VALUES (LAST_INSERT_ID(), numeroVueloIda, fechaVueloIda, claseVueloIda); 

	   				INSERT INTO reserva_vuelo_clase (numero, vuelo, fecha_vuelo, clase)
	   					VALUES (LAST_INSERT_ID(), numeroVueloVuelta, fechaVueloVuelta, claseVueloVuelta); 

	   				SELECT LAST_INSERT_ID() AS numeroDeReserva, "La reserva se realizo con exitos" AS resultado;
	   			ELSE
	   				IF (asientosDIda < 0) THEN
	   					SELECT -1 INTO numero_error;
	   					SELECT numero_error, "No se realizo con exitos la reserva, falta de asientos disponibles para el viaje de ida" AS resultado;
	   				ELSE
	   					SELECT -1 INTO numero_error;
	   					SELECT numero_error, "No se realizo con exitos la reserva, falta de asientos disponibles para el viaje de vuelta" AS resultado;

	   				END IF;

	   			END IF;
	   		ELSE
	   			SELECT -1 INTO numero_error;
	   			SELECT numero_error, "No se realizo con exitos la reserva, datos inexistentes" AS resultado;
	   		END IF;

	 	COMMIT;   

	END; !
delimiter ;
#---------------------------------------------------------------------------------------------------------------------
#TRIGGER 
delimiter !

CREATE TRIGGER inicializarAsientosReservados
	AFTER INSERT ON instancias_vuelo FOR EACH ROW
	BEGIN
  		
		DECLARE done INT DEFAULT FALSE;
    	DECLARE claseVuelo VARCHAR(20);
    	DECLARE cur CURSOR FOR SELECT clase FROM brinda WHERE  brinda.vuelo = NEW.vuelo AND brinda.dia = NEW.dia;
    	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    	OPEN cur;
    		FETCH cur INTO claseVuelo;
    			while not done do
    				INSERT INTO asientos_reservados (vuelo, fecha, clase, cantidad)
            		VALUES (NEW.vuelo, NEW.fecha, claseVuelo, 0);
            		FETCH cur INTO claseVuelo;
    			end while;
    	CLOSE cur;	
	END; !

delimiter ;
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
GRANT EXECUTE ON PROCEDURE vuelos.reserva_ida TO 'empleado'@'%';
GRANT EXECUTE ON PROCEDURE vuelos.reserva_ida_vuelta TO 'empleado'@'%';

#Cliente
CREATE USER 'cliente'@'%'  IDENTIFIED BY 'cliente';
GRANT SELECT ON vuelos.vuelos_disponibles TO 'cliente'@'%';

