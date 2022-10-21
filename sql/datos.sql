#---------------------------------------------------------------------------------------------------------------------
#DATOS

#Ubicaciones
INSERT INTO vuelos.ubicaciones (pais,estado,ciudad,huso) VALUES ("Argentina","Buenos Aires","Mar del Plata",2);
INSERT INTO vuelos.ubicaciones (pais,estado,ciudad,huso) VALUES ("Argentina","Chubut","Puerto Madryn",2);
INSERT INTO vuelos.ubicaciones (pais,estado,ciudad,huso) VALUES ("Argentina","San Juan","San Juan",2);
INSERT INTO vuelos.ubicaciones (pais,estado,ciudad,huso) VALUES ("Argentina","Mendoza","San Rafael",2);
INSERT INTO vuelos.ubicaciones (pais,estado,ciudad,huso) VALUES ("Argentina","Cordoba","Cosquin",2);
INSERT INTO vuelos.ubicaciones (pais,estado,ciudad,huso) VALUES ("Argentina","Buenos Aires","Bahia Blanca",2);

#Aeropuertos
INSERT INTO vuelos.aeropuertos (codigo,nombre,telefono,direccion,pais,estado,ciudad) VALUES("291","El Plumerillo","155897645","9 de Julio 1810","Argentina","Mendoza","San Rafael");
INSERT INTO vuelos.aeropuertos (codigo,nombre,telefono,direccion,pais,estado,ciudad) VALUES("292","Ezeiza","155995238","Pablo Riccheri Km 33","Argentina","Buenos Aires","Bahia Blanca");
INSERT INTO vuelos.aeropuertos (codigo,nombre,telefono,direccion,pais,estado,ciudad) VALUES("293","Domingo Faustino Sarmiento","154238945","Roca 5089","Argentina","San Juan","San Juan");
INSERT INTO vuelos.aeropuertos (codigo,nombre,telefono,direccion,pais,estado,ciudad) VALUES("294","Ing. Aer. Ambrosio Taravella","154667289","Av. Voz del Interior 8500","Argentina","Cordoba","Cosquin");
INSERT INTO vuelos.aeropuertos (codigo,nombre,telefono,direccion,pais,estado,ciudad) VALUES("295","Astor Piazzolla","155111934","Autovia 2 Km 398.5","Argentina","Buenos Aires","Mar del Plata");
INSERT INTO vuelos.aeropuertos (codigo,nombre,telefono,direccion,pais,estado,ciudad) VALUES("296","Aeropuerto Puerto Madryn","156901020","Acceso Puerto Madryn U9120","Argentina","Chubut","Puerto Madryn");

#Comodidades
INSERT INTO vuelos.comodidades (codigo,descripcion) VALUES(55,"Pantalla en todos los asientos y bebidas");
INSERT INTO vuelos.comodidades (codigo,descripcion) VALUES(33,"Pantalla en todos los asientos");
INSERT INTO vuelos.comodidades (codigo,descripcion) VALUES(11,"Basico");

#Modelos Avion
INSERT INTO vuelos.modelos_avion (modelo,fabricante,cabinas,cant_asientos) VALUES('A320','Airbus','1','220');
INSERT INTO vuelos.modelos_avion (modelo,fabricante,cabinas,cant_asientos) VALUES('Boeing 777','Boeing','2','550');
INSERT INTO vuelos.modelos_avion (modelo,fabricante,cabinas,cant_asientos) VALUES('A380','Airbus','2','600');
INSERT INTO vuelos.modelos_avion (modelo,fabricante,cabinas,cant_asientos) VALUES('Boeing 787','Boeing','1','400');

#Pasajeros
INSERT INTO vuelos.pasajeros (doc_nro,doc_tipo,apellido,nombre,direccion,telefono,nacionalidad) VALUES(42293176,"DNI","Perez","Jose Fernando","Los Patos 1154","154275725","Argentina");
INSERT INTO vuelos.pasajeros (doc_nro,doc_tipo,apellido,nombre,direccion,telefono,nacionalidad) VALUES(41789543,"DNI","Sabater","Francisco","Paunero 756","154761212","Argentina");
INSERT INTO vuelos.pasajeros (doc_nro,doc_tipo,apellido,nombre,direccion,telefono,nacionalidad) VALUES(39483268,"DNI","Neglia","Juan Gabriel","Bolivia 765","155148944","Argentina");
INSERT INTO vuelos.pasajeros (doc_nro,doc_tipo,apellido,nombre,direccion,telefono,nacionalidad) VALUES(37283456,"DNI","Gonzales","Dana Lucia","San Lorenzo 2874","155316198","Argentina");
INSERT INTO vuelos.pasajeros (doc_nro,doc_tipo,apellido,nombre,direccion,telefono,nacionalidad) VALUES(42123789,"DNI","Perez","Sofia Belen","Los Patos 1154","155675243","Argentina");
INSERT INTO vuelos.pasajeros (doc_nro,doc_tipo,apellido,nombre,direccion,telefono,nacionalidad) VALUES(45719256,"DNI","Lopez","Jose Luis","Don Bosco 974","154662908","Argentina");
INSERT INTO vuelos.pasajeros (doc_nro,doc_tipo,apellido,nombre,direccion,telefono,nacionalidad) VALUES(21527214,"DNI","Garcia","Gonzalo Alfredo","Motevideo 689","154785634","Argentina");
INSERT INTO vuelos.pasajeros (doc_nro,doc_tipo,apellido,nombre,direccion,telefono,nacionalidad) VALUES(22745667,"DNI","Alvarez","Francisca","Alvarado 1084","156771927","Argentina");
INSERT INTO vuelos.pasajeros (doc_nro,doc_tipo,apellido,nombre,direccion,telefono,nacionalidad) VALUES(44461982,"DNI","Garcia Rossi","Solana","Misioneros 1154","155727552","Argentina");

#Empleados
INSERT INTO vuelos.empleados (legajo,password,doc_nro,doc_tipo,apellido,nombre,direccion,telefono) VALUES(126691,md5("ps-empleado-01"),23567189,"DNI","Perez","Jose Esteban","Gonzales Chaves 345","156787842");
INSERT INTO vuelos.empleados (legajo,password,doc_nro,doc_tipo,apellido,nombre,direccion,telefono) VALUES(126692,md5("ps-empleado-02"),24517190,"DNI","Fernandez","Facundo","Ing. Luigi 29","154236789");
INSERT INTO vuelos.empleados (legajo,password,doc_nro,doc_tipo,apellido,nombre,direccion,telefono) VALUES(126693,md5("ps-empleado-03"),25537191,"DNI","Gil","German","Charcas 5426","154927589");
INSERT INTO vuelos.empleados (legajo,password,doc_nro,doc_tipo,apellido,nombre,direccion,telefono) VALUES(126694,md5("ps-empleado-04"),26557192,"DNI","Gutierrez","Laura Maria","Yrigoyen 74","156117788");
INSERT INTO vuelos.empleados (legajo,password,doc_nro,doc_tipo,apellido,nombre,direccion,telefono) VALUES(126695,md5("ps-empleado-05"),27577193,"DNI","Alfonso","Mariela","Paunero 244","154285826");

#Reservas
INSERT INTO vuelos.reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo) VALUES("2022/1/2","2022/2/2","confirmada",42293176,"DNI",126691);
INSERT INTO vuelos.reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo) VALUES("2022/2/5","2022/4/5","pagada",41789543,"DNI",126692);
INSERT INTO vuelos.reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo) VALUES("2022/5/27","2022/7/27","en espera",39483268,"DNI",126693);
INSERT INTO vuelos.reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo) VALUES("2022/6/12","2022/8/12","confirmada",37283456,"DNI",126691);
INSERT INTO vuelos.reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo) VALUES("2022/6/22","2022/8/22","pagada",42123789,"DNI",126695);
INSERT INTO vuelos.reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo) VALUES("2022/9/8","2022/11/8","en espera",45719256,"DNI",126694);
INSERT INTO vuelos.reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo) VALUES("2022/9/9","2022/11/9","en espera",21527214,"DNI",126692);
INSERT INTO vuelos.reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo) VALUES("2022/10/29","2022/12/29","confirmada",22745667,"DNI",126695);
INSERT INTO vuelos.reservas (fecha, vencimiento, estado, doc_nro, doc_tipo, legajo) VALUES("2022/10/29","2022/12/29","confirmada",44461982,"DNI",126693);

#Clases
INSERT INTO vuelos.clases (nombre,porcentaje) VALUES("Primera Clase",0.25);
INSERT INTO vuelos.clases (nombre,porcentaje) VALUES("Segunda Clase",0.50);
INSERT INTO vuelos.clases (nombre,porcentaje) VALUES("Tercera Clase",0.25);

#Vuelos Programados
INSERT INTO vuelos.vuelos_programados (numero,aeropuerto_salida,aeropuerto_llegada) VALUES("M01","291","296");
INSERT INTO vuelos.vuelos_programados (numero,aeropuerto_salida,aeropuerto_llegada) VALUES("BA01","294","293");
INSERT INTO vuelos.vuelos_programados (numero,aeropuerto_salida,aeropuerto_llegada) VALUES("SJ01","293","296");
INSERT INTO vuelos.vuelos_programados (numero,aeropuerto_salida,aeropuerto_llegada) VALUES("M02","291","295");
INSERT INTO vuelos.vuelos_programados (numero,aeropuerto_salida,aeropuerto_llegada) VALUES("PM01","296","292");

#Salidas
INSERT INTO vuelos.salidas (hora_sale,hora_llega,dia,vuelo,modelo_avion) VALUES("03:00:00","08:30:00","Do","M01","A320");
INSERT INTO vuelos.salidas (hora_sale,hora_llega,dia,vuelo,modelo_avion) VALUES("01:00:00","06:45:00","Do","BA01","Boeing 777");
INSERT INTO vuelos.salidas (hora_sale,hora_llega,dia,vuelo,modelo_avion) VALUES("07:30:00","12:20:00","Ma","SJ01","Boeing 787");
INSERT INTO vuelos.salidas (hora_sale,hora_llega,dia,vuelo,modelo_avion) VALUES("05:00:00","09:30:00","Ju","M02","A320");
INSERT INTO vuelos.salidas (hora_sale,hora_llega,dia,vuelo,modelo_avion) VALUES("02:15:00","10:30:00","Vi","PM01","A380");

#Instancia
INSERT INTO vuelos.instancias_vuelo (vuelo,fecha,dia,estado) VALUES("M01","2022/3/6","Do","A tiempo");
INSERT INTO vuelos.instancias_vuelo (vuelo,fecha,dia,estado) VALUES("BA01","2022/3/6","Do","Demorado");
INSERT INTO vuelos.instancias_vuelo (vuelo,fecha,dia,estado) VALUES("SJ01","2022/5/17","Ma","A tiempo");
INSERT INTO vuelos.instancias_vuelo (vuelo,fecha,dia,estado) VALUES("M02","2022/9/22","Ju","Demorado");
INSERT INTO vuelos.instancias_vuelo (vuelo,fecha,dia,estado) VALUES("PM01","2022/10/28","Vi","Cancelado");

#Asientos
INSERT INTO vuelos.asientos_reservados (vuelo,fecha,clase,cantidad) VALUES("M02","2022/9/22","Primera Clase",9);
INSERT INTO vuelos.asientos_reservados (vuelo,fecha,clase,cantidad) VALUES("PM01","2022/10/28","Tercera Clase",20);
INSERT INTO vuelos.asientos_reservados (vuelo,fecha,clase,cantidad) VALUES("M01","2022/3/6","Segunda Clase",10);
INSERT INTO vuelos.asientos_reservados (vuelo,fecha,clase,cantidad) VALUES("BA01","2022/3/6","Primera Clase",3);
INSERT INTO vuelos.asientos_reservados (vuelo,fecha,clase,cantidad) VALUES("SJ01","2022/5/17","Segunda Clase",37);

#Posee 
INSERT INTO vuelos.posee (clase,comodidad) VALUES("Primera Clase",55);
INSERT INTO vuelos.posee (clase,comodidad) VALUES("Segunda Clase",33);
INSERT INTO vuelos.posee (clase,comodidad) VALUES("Tercera Clase",11);

#Brinda
INSERT INTO vuelos.brinda (precio,cant_asientos,clase,vuelo,dia) VALUES(57350.00,90,"Segunda Clase","M01","Do");
INSERT INTO vuelos.brinda (precio,cant_asientos,clase,vuelo,dia) VALUES(79439.00,180,"Primera Clase","BA01","Do");
INSERT INTO vuelos.brinda (precio,cant_asientos,clase,vuelo,dia) VALUES(52000.00,90,"Segunda Clase","SJ01","Ma");
INSERT INTO vuelos.brinda (precio,cant_asientos,clase,vuelo,dia) VALUES(83590.00,18,"Primera Clase","M02","Ju");
INSERT INTO vuelos.brinda (precio,cant_asientos,clase,vuelo,dia) VALUES(32000.00,200,"Tercera Clase","PM01","Vi");

#Reserva Vuelos
INSERT INTO vuelos.reserva_vuelo_clase (vuelo,fecha_vuelo,clase) VALUES("M01","2022/3/6","Segunda Clase");
INSERT INTO vuelos.reserva_vuelo_clase (vuelo,fecha_vuelo,clase) VALUES("BA01","2022/3/6","Primera Clase");
INSERT INTO vuelos.reserva_vuelo_clase (vuelo,fecha_vuelo,clase) VALUES("SJ01","2022/5/17","Segunda Clase");
INSERT INTO vuelos.reserva_vuelo_clase (vuelo,fecha_vuelo,clase) VALUES("M02","2022/9/22","Primera Clase");
INSERT INTO vuelos.reserva_vuelo_clase (vuelo,fecha_vuelo,clase) VALUES("PM01","2022/10/28","Tercera Clase");

#---------------------------------------------------------------------------------------------------------------------

