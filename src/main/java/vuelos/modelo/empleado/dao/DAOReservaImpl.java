package vuelos.modelo.empleado.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.empleado.beans.AeropuertoBean;
import vuelos.modelo.empleado.beans.AeropuertoBeanImpl;
import vuelos.modelo.empleado.beans.DetalleVueloBean;
import vuelos.modelo.empleado.beans.DetalleVueloBeanImpl;
import vuelos.modelo.empleado.beans.EmpleadoBean;
import vuelos.modelo.empleado.beans.EmpleadoBeanImpl;
import vuelos.modelo.empleado.beans.InstanciaVueloBean;
import vuelos.modelo.empleado.beans.InstanciaVueloBeanImpl;
import vuelos.modelo.empleado.beans.InstanciaVueloClaseBean;
import vuelos.modelo.empleado.beans.InstanciaVueloClaseBeanImpl;
import vuelos.modelo.empleado.beans.PasajeroBean;
import vuelos.modelo.empleado.beans.ReservaBean;
import vuelos.modelo.empleado.beans.ReservaBeanImpl;
import vuelos.modelo.empleado.beans.UbicacionesBean;
import vuelos.modelo.empleado.beans.UbicacionesBeanImpl;
import vuelos.modelo.empleado.dao.datosprueba.DAOReservaDatosPrueba;
import vuelos.utils.Fechas;
import vuelos.modelo.empleado.dao.DAOPasajeroImpl.*;

public class DAOReservaImpl implements DAOReserva {

	private static Logger logger = LoggerFactory.getLogger(DAOReservaImpl.class);
	
	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOReservaImpl(Connection conexion) {
		this.conexion = conexion;
	}
		
	/**
	 * TODO (parte 2) Realizar una reserva de ida solamente llamando al Stored Procedure (S.P.) correspondiente. 
	 *      Si la reserva tuvo exito deberá retornar el número de reserva. Si la reserva no tuvo éxito o 
	 *      falla el S.P. deberá propagar un mensaje de error explicativo dentro de una excepción.
	 *      La demás excepciones generadas automáticamente por algun otro error simplemente se propagan.
	 *      
	 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
	 *      establecida con el servidor de B.D. (inicializada en el constructor DAOReservaImpl(...)).
	 *		
	 * 
	 * @throws Exception. Deberá propagar la excepción si ocurre alguna. Puede capturarla para loguear los errores
	 *		   pero luego deberá propagarla para que el controlador se encargue de manejarla.
	 *
	 * try (CallableStatement cstmt = conexion.prepareCall("CALL PROCEDURE reservaSoloIda(?, ?, ?, ?, ?, ?, ?)"))
	 * {
	 *  ...
	 * }
	 * catch (SQLException ex){
	 * 			logger.debug("Error al consultar la BD. SQLException: {}. SQLState: {}. VendorError: {}.", ex.getMessage(), ex.getSQLState(), ex.getErrorCode());
	 *  		throw ex;
	 * } 
	 */
	
	/*
	 * Datos estaticos de prueba: Quitar y reemplazar por código que invoca al S.P.
	 * 
	 * - Si pasajero tiene nro_doc igual a 1 retorna 101 codigo de reserva y si se pregunta por dicha reserva como dato de prueba resultado "Reserva confirmada"
	 * - Si pasajero tiene nro_doc igual a 2 retorna 102 codigo de reserva y si se pregunta por dicha reserva como dato de prueba resultado "Reserva en espera"
	 * - Si pasajero tiene nro_doc igual a 3 se genera una excepción, resultado "No hay asientos disponibles"
	 * - Si pasajero tiene nro_doc igual a 4 se genera una excepción, resultado "El empleado no es válido"
	 * - Si pasajero tiene nro_doc igual a 5 se genera una excepción, resultado "El pasajero no está registrado"
	 * - Si pasajero tiene nro_doc igual a 6 se genera una excepción, resultado "El vuelo no es válido"
	 * - Si pasajero tiene nro_doc igual a 7 se genera una excepción de conexión.
	 */
	
	@Override
	public int reservarSoloIda(PasajeroBean pasajero, 
							   InstanciaVueloBean vuelo, 
							   DetalleVueloBean detalleVuelo,
							   EmpleadoBean empleado) throws Exception {
		logger.info("Realiza la reserva de solo ida con pasajero {}", pasajero.getNroDocumento());
		int resultado = 0;
		try (CallableStatement cstmt = conexion.prepareCall("CALL reserva_ida(?, ?, ?, ?, ?, ?)"))
		{
			//Datos de entrada 
			cstmt.setString(1,vuelo.getNroVuelo());
			cstmt.setDate(2,Fechas.convertirDateADateSQL(vuelo.getFechaVuelo()));
			cstmt.setString(3,detalleVuelo.getClase());
			cstmt.setString(4, pasajero.getTipoDocumento());
			cstmt.setInt(5, pasajero.getNroDocumento());
			cstmt.setInt(6, empleado.getLegajo());

			cstmt.execute();	
			
			ResultSet rs = cstmt.getResultSet();
			
			if(rs.next()) {
				resultado = rs.getInt(1);
				System.out.print(resultado);
			}
			
		}
		catch (SQLException ex){
			logger.debug("Error al consultar la BD. SQLException: {}. SQLState: {}. VendorError: {}.", ex.getMessage(), ex.getSQLState(), ex.getErrorCode());
		   	throw ex;
		}
		//DAOReservaDatosPrueba.registrarReservaSoloIda(pasajero, vuelo, detalleVuelo, empleado);
		//ReservaBean r = DAOReservaDatosPrueba.getReserva();
		//logger.debug("Reserva: {}, {}", r.getNumero(), r.getEstado());
		//int resultado = DAOReservaDatosPrueba.getReserva().getNumero();
		
		return resultado;
	}
	
	/**
	 * TODO (parte 2) Realizar una reserva de ida y vuelta llamando al Stored Procedure (S.P.) correspondiente. 
	 *      Si la reserva tuvo exito deberá retornar el número de reserva. Si la reserva no tuvo éxito o 
	 *      falla el S.P. deberá propagar un mensaje de error explicativo dentro de una excepción.
	 *      La demás excepciones generadas automáticamente por algun otro error simplemente se propagan.
	 *      
	 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
	 *      establecida con el servidor de B.D. (inicializada en el constructor DAOReservaImpl(...)).
	 * 
	 * @throws Exception. Deberá propagar la excepción si ocurre alguna. Puede capturarla para loguear los errores
	 *		   pero luego deberá propagarla para que se encargue el controlador.
	 *
	 * try (CallableStatement ... )
	 * {
	 *  ...
	 * }
	 * catch (SQLException ex){
	 * 			logger.debug("Error al consultar la BD. SQLException: {}. SQLState: {}. VendorError: {}.", ex.getMessage(), ex.getSQLState(), ex.getErrorCode());
	 *  		throw ex;
	 * } 
	 */
	
	/*
	 * Datos státicos de prueba: Quitar y reemplazar por código que invoca al S.P.
	 * 
	 * - Si pasajero tiene nro_doc igual a 1 retorna 101 codigo de reserva y si se pregunta por dicha reserva como dato de prueba resultado "Reserva confirmada"
	 * - Si pasajero tiene nro_doc igual a 2 retorna 102 codigo de reserva y si se pregunta por dicha reserva como dato de prueba resultado "Reserva en espera"
	 * - Si pasajero tiene nro_doc igual a 3 se genera una excepción, resultado "No hay asientos disponibles"
	 * - Si pasajero tiene nro_doc igual a 4 se genera una excepción, resultado "El empleado no es válido"
	 * - Si pasajero tiene nro_doc igual a 5 se genera una excepción, resultado "El pasajero no está registrado"
	 * - Si pasajero tiene nro_doc igual a 6 se genera una excepción, resultado "El vuelo no es válido"
	 * - Si pasajero tiene nro_doc igual a 7 se genera una excepción de conexión.
	 */	
	
	@Override
	public int reservarIdaVuelta(PasajeroBean pasajero, 
				 				 InstanciaVueloBean vueloIda,
				 				 DetalleVueloBean detalleVueloIda,
				 				 InstanciaVueloBean vueloVuelta,
				 				 DetalleVueloBean detalleVueloVuelta,
				 				 EmpleadoBean empleado) throws Exception {
		logger.info("Realiza la reserva de solo ida con pasajero {}", pasajero.getNroDocumento());
		int resultado = 0;
		try (CallableStatement cstmt = conexion.prepareCall("CALL PROCEDURE reservaSoloIda(?, ?, ?, ?, ?, ?, ?,?, ?, ?)"))
		{
			//Datos de entrada 
			cstmt.setString("numeroVueloIda",vueloIda.getNroVuelo());
			cstmt.setDate("fechaVueloIda",Fechas.convertirDateADateSQL(vueloIda.getFechaVuelo()));
			cstmt.setString("claseVueloIda",detalleVueloIda.getClase());
			
			cstmt.setString("numeroVueloVuelta",vueloVuelta.getNroVuelo());
			cstmt.setDate("fechaVueloVuelta",Fechas.convertirDateADateSQL(vueloVuelta.getFechaVuelo()));
			cstmt.setString("claseVueloVuelta",detalleVueloVuelta.getClase());
			
			cstmt.setString("tipoDocPas", pasajero.getTipoDocumento());
			cstmt.setInt("numDocPas", pasajero.getNroDocumento());
			cstmt.setInt("legajoEmpIda", empleado.getLegajo());
			cstmt.setInt("legajoEmpVuelta", empleado.getLegajo());
			
			cstmt.execute();
			
			cstmt.registerOutParameter("numeroDeReserva", java.sql.Types.INTEGER);		
			
			resultado = cstmt.getInt("numeroDeReserva");
		}
		catch (SQLException ex){
			logger.debug("Error al consultar la BD. SQLException: {}. SQLState: {}. VendorError: {}.", ex.getMessage(), ex.getSQLState(), ex.getErrorCode());
		   	throw ex;
		}
		return resultado;
	}
	/**
	 * TODO (parte 2) Debe realizar una consulta que retorne un objeto ReservaBean donde tenga los datos de la
	 *      reserva que corresponda con el codigoReserva y en caso que no exista generar una excepción.
	 *
	 * 		Debe poblar la reserva con todas las instancias de vuelo asociadas a dicha reserva y 
	 * 		las clases correspondientes.
	 * 
	 * 		Los objetos ReservaBean además de las propiedades propias de una reserva tienen un arraylist
	 * 		con pares de instanciaVuelo y Clase. Si la reserva es solo de ida va a tener un unico
	 * 		elemento el arreglo, y si es de ida y vuelta tendrá dos elementos. 
	 * 
	 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
	 *      establecida con el servidor de B.D. (inicializada en el constructor DAOReservaImpl(...)).
	 */
	/*
	 * Importante, tenga en cuenta de setear correctamente el atributo IdaVuelta con el método setEsIdaVuelta en la ReservaBean
	 */
	
	public AeropuertoBean conseguirAeropuerto(String codigo,UbicacionesBean ubi) throws Exception  {
		logger.info("Se recupera los datos del aeropuerto.");
		AeropuertoBean aero = new AeropuertoBeanImpl();
		logger.info("{}", codigo);
		String sql = "SELECT telefono,direccion,nombre FROM aeropuertos WHERE codigo='"+codigo+"';";
		try {
			ResultSet r = null;
			Statement s = conexion.createStatement();
			r = s.executeQuery(sql);
			if(r.next()) {
				aero.setCodigo(codigo);
				aero.setNombre(r.getString("nombre"));
				aero.setDireccion(r.getString("direccion"));
				aero.setTelefono(r.getString("telefono"));
				aero.setUbicacion(ubi);
			}
		} catch (SQLException e) {
			logger.error("SQLException: " + e.getMessage());
			logger.error("SQLState: " + e.getSQLState());
			logger.error("VendorError: " + e.getErrorCode());		   
			throw new Exception("Error al recuperar las ubicaciones");
		}
		return aero;
	}
	
	public UbicacionesBean Conseguir_ubi(String pais,String estado,String ciudad) {
		UbicacionesBean ubi = new UbicacionesBeanImpl();
		try {
			logger.info("Se recupera los datos de la ubicacion.");
			ResultSet rs = null;
			String sql = "SELECT huso FROM ubicaciones WHERE pais='"+pais+"' AND estado='"+estado+"' AND ciudad='"+ciudad+"'";
			Statement select = conexion.createStatement();
			rs = select.executeQuery(sql);
			if(rs.next()) {
				ubi.setCiudad(ciudad);
				ubi.setEstado(estado);
				ubi.setPais(pais);
				ubi.setHuso(rs.getInt("huso"));
			}
		} catch (SQLException e) {
			logger.error("SQLException: " + e.getMessage());
			logger.error("SQLState: " + e.getSQLState());
			logger.error("VendorError: " + e.getErrorCode());		   
		} 
		return ubi;
	}
	
	public InstanciaVueloBean instancia_vuelo(String vuelo,Date d) throws Exception {
		try {
			logger.info("Se recupera los datos de la instancia de vuelo.");
			ResultSet rs = null;
			String sql = "SELECT DISTINCT pais_sale,pais_llega,codigo_aero_sale,nombre_aero_sale,codigo_aero_llega,nombre_aero_llega,nro_vuelo,modelo,dia_sale,hora_sale,hora_llega,tiempo_estimado,fecha,ciudad_llega,ciudad_sale,estado_sale,estado_llega FROM vuelos_disponibles WHERE fecha='"+Fechas.convertirDateADateSQL(d)+"' AND nro_vuelo='"+vuelo+"'";
			Statement select = conexion.createStatement();
			rs = select.executeQuery(sql);
			while(rs.next()) {
				InstanciaVueloBean aux = new InstanciaVueloBeanImpl();
				aux.setNroVuelo(rs.getString("nro_vuelo"));
				aux.setModelo(rs.getString("modelo"));
				aux.setDiaSalida(rs.getString("dia_sale"));
				aux.setHoraSalida(rs.getTime("hora_sale"));
				aux.setHoraLlegada(rs.getTime("hora_llega"));
				aux.setTiempoEstimado(rs.getTime("tiempo_estimado"));
				aux.setFechaVuelo(Fechas.convertirDateADateSQL(d));
				UbicacionesBean llega =  Conseguir_ubi(rs.getString("pais_llega"),rs.getString("estado_llega"),rs.getString("ciudad_llega"));
				UbicacionesBean sale =  Conseguir_ubi(rs.getString("pais_sale"),rs.getString("estado_sale"),rs.getString("ciudad_sale"));
				aux.setAeropuertoLlegada(conseguirAeropuerto(rs.getString("codigo_aero_llega"),llega));
				aux.setAeropuertoSalida(conseguirAeropuerto(rs.getString("codigo_aero_sale"),sale));
			}
		} catch (SQLException e) {
			logger.error("SQLException: " + e.getMessage());
			logger.error("SQLState: " + e.getSQLState());
			logger.error("VendorError: " + e.getErrorCode());		   
		} 
		return null;
	} 
	
	public DetalleVueloBean instacia_detalle(InstanciaVueloBean vuelo) throws Exception   {
		logger.info("recupera los detalles de vuelo pasados por parametros.");
		DetalleVueloBean resultado = new DetalleVueloBeanImpl();
		try {
			ResultSet rs = null;
			String sql = "SELECT precio,asientos_disponibles,clase,fecha FROM vuelos_disponibles WHERE fecha='"+Fechas.convertirDateADateSQL(vuelo.getFechaVuelo())+"' AND nro_vuelo='"+vuelo.getNroVuelo()+"'; ";
			Statement select = conexion.createStatement();
			rs = select.executeQuery(sql);
			if(rs.next()) {
				resultado.setVuelo(vuelo);
				resultado.setAsientosDisponibles(rs.getInt("asientos_disponibles"));
				resultado.setClase(rs.getString("clase"));
				resultado.setPrecio(rs.getFloat("precio"));
			}
		} catch (SQLException e) {
			logger.error("SQLException: " + e.getMessage());
			logger.error("SQLState: " + e.getSQLState());
			logger.error("VendorError: " + e.getErrorCode());		   
			throw new Exception("Error al recuperar los detalles de vuelo");
		}
		return resultado; 
	}
	
	public ArrayList<InstanciaVueloClaseBean> arregloInstancia(int codigo) throws Exception{
		ArrayList<InstanciaVueloClaseBean> resultado = new ArrayList<InstanciaVueloClaseBean>();
		try {
			logger.info("Se crea el arreglo de la instancias de vuelo");
			ResultSet rs = null;
			String sql = "SELECT vuelo,clase,fecha_vuelo FROM reserva_vuelo_clase WHERE numero = "+codigo+";";
			Statement select = conexion.createStatement();
			rs = select.executeQuery(sql);
			while(rs.next()) {
				InstanciaVueloClaseBean aux = new InstanciaVueloClaseBeanImpl();
				InstanciaVueloBean i = instancia_vuelo(rs.getString("vuelo"),Fechas.convertirDateADateSQL(rs.getDate("fecha_vuelo")));
				DetalleVueloBean d = instacia_detalle(i);
				aux.setClase(d);
				aux.setVuelo(i);
				resultado.add(aux);
			}
		} catch (SQLException e) {
			logger.error("SQLException: " + e.getMessage());
			logger.error("SQLState: " + e.getSQLState());
			logger.error("VendorError: " + e.getErrorCode());		   
			throw new Exception("Error al recuperar reserva");
		}	
		return resultado;
	}
	
	@Override
	public ReservaBean recuperarReserva(int codigoReserva) throws Exception {	
		logger.info("Solicita recuperar información de la reserva con codigo {}", codigoReserva);
		ReservaBean reserva = new ReservaBeanImpl();
		try {
			DAOEmpleado de = new DAOEmpleadoImpl(conexion);
			DAOPasajero dp = new DAOPasajeroImpl(conexion);
			ResultSet rs = null;
			String sql = "SELECT * FROM reservas WHERE numero = '"+codigoReserva+"'; ";
			Statement select = conexion.createStatement();
			rs = select.executeQuery(sql);
			Fechas f = new Fechas();
			PasajeroBean p = dp.recuperarPasajero(rs.getString("doc_tipo"),rs.getInt("doc_nro"));
			EmpleadoBean e = de.recuperarEmpleado(rs.getInt("legajo"));
			if (rs.next()) {
				reserva.setNumero(rs.getInt("numero"));
				reserva.setFecha(f.convertirDateADateSQL(rs.getDate("fecha")));
				reserva.setVencimiento(f.convertirDateADateSQL(rs.getDate("vencimiento")));
				reserva.setEstado(rs.getString("estado"));
				reserva.setPasajero(p);
				reserva.setEmpleado(e);	
				ArrayList<InstanciaVueloClaseBean> aux =  arregloInstancia(codigoReserva);
				if (aux.size()==2){reserva.setEsIdaVuelta(true);}
				if (aux.size()==1){reserva.setEsIdaVuelta(false);}
			}
			else {
				reserva = null;
			}
		} catch (SQLException e) {
			logger.error("SQLException: " + e.getMessage());
			logger.error("SQLState: " + e.getSQLState());
			logger.error("VendorError: " + e.getErrorCode());		   
			throw new Exception("Error al recuperar reserva");
		}
		return reserva;
	}
	

}
