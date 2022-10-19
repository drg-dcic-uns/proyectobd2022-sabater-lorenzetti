package vuelos.modelo.empleado;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.ModeloImpl;
import vuelos.utils.Conexion;
import vuelos.modelo.empleado.beans.DetalleVueloBean;
import vuelos.modelo.empleado.beans.EmpleadoBean;
import vuelos.modelo.empleado.beans.InstanciaVueloBean;
import vuelos.modelo.empleado.beans.PasajeroBean;
import vuelos.modelo.empleado.beans.ReservaBean;
import vuelos.modelo.empleado.beans.UbicacionesBean;
import vuelos.modelo.empleado.beans.UbicacionesBeanImpl;
import vuelos.modelo.empleado.dao.DAOEmpleado;
import vuelos.modelo.empleado.dao.DAOEmpleadoImpl;
import vuelos.modelo.empleado.dao.DAOPasajero;
import vuelos.modelo.empleado.dao.DAOPasajeroImpl;
import vuelos.modelo.empleado.dao.DAOReserva;
import vuelos.modelo.empleado.dao.DAOReservaImpl;
import vuelos.modelo.empleado.dao.DAOVuelos;
import vuelos.modelo.empleado.dao.DAOVuelosImpl;
import vuelos.modelo.empleado.dao.datosprueba.DAOUbicacionesDatosPrueba;

public class ModeloEmpleadoImpl extends ModeloImpl implements ModeloEmpleado {

	private static Logger logger = LoggerFactory.getLogger(ModeloEmpleadoImpl.class);	
	
	private Integer legajo = null;
	
	
	public ModeloEmpleadoImpl(){
		logger.debug("Se crea el modelo Empleado.");
		   try
	        {
			   Conexion.inicializar("cfg/conexionBD.properties");
	        }
	        catch  (Exception ex) {
	            logger.error("Error al recuperar el archivo de propiedades de la BD y no se pudo establecer la conexion");
	        }
	}
	

	/** 
	 * TODO (Hecho?)(Código que autentica que exista un legajo de empleado y que el password corresponda a ese legajo
	 *      (recuerde que el password guardado en la BD está encriptado con MD5) 
	 *      En caso exitoso deberá registrar el legajo en la propiedad legajo y retornar true.
	 *      Si la autenticación no es exitosa porque el legajo no es válido o el password es incorrecto
	 *      deberá retornar falso y si hubo algún otro error deberá producir y propagar una excepción.
	 */
	
	@Override
	public boolean autenticarUsuarioAplicacion(String legajo, String password) throws Exception {
		logger.info("Se intenta autenticar el legajo {} con password {}", legajo, password);
		ResultSet rs = null;
		int l = Integer.valueOf(legajo);
		String sql = "SELECT legajo,password FROM empleados where legajo = "+l+" AND password='"+password+"';";
		Statement select = conexion.createStatement();
		rs = select.executeQuery(sql);
		return rs.next();
	}
	/** 
	 * TODO(Hecho?) Debe retornar una lista de strings con los tipos de documentos. 
	 *      Deberia propagar una excepción si hay algún error en la consulta.
	 * @throws SQLException 
	 */
	
	/*
	 * Datos estáticos de prueba. Quitar y reemplazar por código que recupera los datos reales. 
	 * 
	 *  Como no hay una tabla con los tipos de documento, se deberán recuperar todos los tipos validos
	 *  de la tabla de pasajeros
	 */
	@Override
	public ArrayList<String> obtenerTiposDocumento() throws SQLException  {
		logger.info("recupera los tipos de documentos.");
		ArrayList<String> tipos = new ArrayList<String>();
		ResultSet rs = null;
		String sql = "SELECT doc_tipo FROM empleados";
		Statement select = conexion.createStatement();
		rs = select.executeQuery(sql);
		while(rs.next()) {
			tipos.add(rs.getString("doc_tipo"));
		}
		//Datos prueba
		//tipos.add("DNI");
		//tipos.add("Pasaporte");
		// Fin datos estáticos de prueba.
		return tipos;
	}		
	
	@Override
	public EmpleadoBean obtenerEmpleadoLogueado() throws Exception {
		logger.info("Solicita al DAO un empleado con legajo {}", this.legajo);
		if (this.legajo == null) {
			logger.info("No hay un empleado logueado.");
			throw new Exception("No hay un empleado logueado. La sesión terminó.");
		}
		
		DAOEmpleado dao = new DAOEmpleadoImpl(this.conexion);
		return dao.recuperarEmpleado(this.legajo);
	}		
	/** 
	 * TODO(Hecho?)Debe retornar una lista de UbicacionesBean con todas las ubicaciones almacenadas en la B.D. 
	 *      Deberia propagar una excepción si hay algún error en la consulta.
	 *      
	 *      Reemplazar el siguiente código de prueba por los datos obtenidos desde la BD.
	 */	
	@Override
	public ArrayList<UbicacionesBean> recuperarUbicaciones() throws Exception {
		logger.info("recupera las ciudades que tienen aeropuertos.");	
		ArrayList<UbicacionesBean> ubicaciones = new ArrayList<UbicacionesBean>();
		ResultSet rs = null;
		String sql = "SELECT doc_tipo FROM empleados";
		Statement select = conexion.createStatement();
		rs = select.executeQuery(sql);
		while(rs.next()) {
			UbicacionesBean aux = new UbicacionesBeanImpl();
			aux.setPais(rs.getString("pais"));
			aux.setEstado(rs.getString("estado"));
			aux.setCiudad(rs.getString("ciudad"));
			aux.setHuso(rs.getInt("huso"));
			ubicaciones.add(aux);
		}
		// Datos estáticos de prueba. Quitar y reemplazar por código que recupera las ubicaciones de la B.D. en una lista de UbicacionesBean		 
		DAOUbicacionesDatosPrueba.poblar();
		ubicaciones.add(DAOUbicacionesDatosPrueba.obtenerUbicacion("bsas"));
		ubicaciones.add(DAOUbicacionesDatosPrueba.obtenerUbicacion("chicago"));
		ubicaciones.add(DAOUbicacionesDatosPrueba.obtenerUbicacion("barcelona"));
		ubicaciones.add(DAOUbicacionesDatosPrueba.obtenerUbicacion("cordoba"));	
		// Fin datos estáticos de prueba.
	
		return ubicaciones;
	}


	@Override
	public ArrayList<InstanciaVueloBean> obtenerVuelosDisponibles(Date fechaVuelo, UbicacionesBean origen, UbicacionesBean destino) throws Exception {
		
		logger.info("Recupera la lista de vuelos disponibles para la fecha {} desde {} a {}.", fechaVuelo, origen, destino);

		DAOVuelos dao = new DAOVuelosImpl(this.conexion);		
		return dao.recuperarVuelosDisponibles(fechaVuelo, origen, destino);
	}
	
	@Override
	public ArrayList<DetalleVueloBean> obtenerDetalleVuelo(InstanciaVueloBean vuelo) throws Exception {

		logger.info("Recupera la cantidad de asientos y precio del vuelo {} .", vuelo.getNroVuelo());
		
		DAOVuelos dao = new DAOVuelosImpl(this.conexion);		
		return dao.recuperarDetalleVuelo(vuelo);
	}


	@Override
	public PasajeroBean obtenerPasajero(String tipoDoc, int nroDoc) throws Exception {
		logger.info("Solicita al DAO un pasajero con tipo {} y nro {}", tipoDoc, nroDoc);
		
		DAOPasajero dao = new DAOPasajeroImpl(this.conexion);
		return dao.recuperarPasajero(tipoDoc, nroDoc);
	}


	@Override
	public ReservaBean reservarSoloIda(PasajeroBean pasajero, InstanciaVueloBean vuelo, DetalleVueloBean detalleVuelo)
			throws Exception {
		logger.info("Se solicita al modelo realizar una reserva solo ida");

		EmpleadoBean empleadoLogueado = this.obtenerEmpleadoLogueado();
		
		DAOReserva dao = new DAOReservaImpl(this.conexion);
		int nroReserva = dao.reservarSoloIda(pasajero, vuelo, detalleVuelo, empleadoLogueado);
		
		ReservaBean reserva = dao.recuperarReserva(nroReserva); 
		return reserva;
	}


	@Override
	public ReservaBean reservarIdaVuelta(PasajeroBean pasajeroSeleccionado, 
									 InstanciaVueloBean vueloIdaSeleccionado,
									 DetalleVueloBean detalleVueloIdaSeleccionado, 
									 InstanciaVueloBean vueloVueltaSeleccionado,
									 DetalleVueloBean detalleVueloVueltaSeleccionado) throws Exception {
		
		logger.info("Se solicita al modelo realizar una reserva de ida y vuelta");
		
		EmpleadoBean empleadoLogueado = this.obtenerEmpleadoLogueado();
		
		DAOReserva dao = new DAOReservaImpl(this.conexion);
		
		int nroReserva = dao.reservarIdaVuelta(pasajeroSeleccionado, 
									 vueloIdaSeleccionado, 
									 detalleVueloIdaSeleccionado, 
									 vueloVueltaSeleccionado, 
									 detalleVueloVueltaSeleccionado, 
									 empleadoLogueado);
		
		ReservaBean reserva = dao.recuperarReserva(nroReserva); 
		return reserva;		
	}
}
