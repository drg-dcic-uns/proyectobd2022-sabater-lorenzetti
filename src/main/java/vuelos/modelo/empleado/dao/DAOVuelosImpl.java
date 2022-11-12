package vuelos.modelo.empleado.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.empleado.beans.AeropuertoBean;
import vuelos.modelo.empleado.beans.AeropuertoBeanImpl;
import vuelos.modelo.empleado.beans.DetalleVueloBean;
import vuelos.modelo.empleado.beans.DetalleVueloBeanImpl;
import vuelos.modelo.empleado.beans.InstanciaVueloBean;
import vuelos.modelo.empleado.beans.InstanciaVueloBeanImpl;
import vuelos.modelo.empleado.beans.UbicacionesBean;
import vuelos.modelo.empleado.beans.UbicacionesBeanImpl;
import vuelos.modelo.empleado.dao.datosprueba.DAOVuelosDatosPrueba;
import vuelos.utils.*;

public class DAOVuelosImpl implements DAOVuelos {

	private static Logger logger = LoggerFactory.getLogger(DAOVuelosImpl.class);
	
	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOVuelosImpl(Connection conexion) {
		this.conexion = conexion;
	}
	/** 
	 * TODO (Hecho?)Debe retornar una lista de vuelos disponibles para ese día con origen y destino según los parámetros. 
	 *      Debe propagar una excepción si hay algún error en la consulta.    
	 *      
	 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
	 *      establecida con el servidor de B.D. (inicializada en el constructor DAOVuelosImpl(...)).  
	 * @throws Exception 
	 * @throws SQLException 
	 */
	
	
	private AeropuertoBean conseguirAeropuerto(String codigo,UbicacionesBean ubi) throws Exception  {
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
	
	public ArrayList<InstanciaVueloBean> recuperarVuelosDisponibles(Date fechaVuelo, UbicacionesBean origen, UbicacionesBean destino) throws Exception   {		
		logger.info("Se recupera los datos de los vuelos disponibles");
		ArrayList<InstanciaVueloBean> resultado = new ArrayList<InstanciaVueloBean>();  
		try {
			ResultSet rs = null;
			String sql = "SELECT DISTINCT codigo_aero_sale,nombre_aero_sale,codigo_aero_llega,nombre_aero_llega,nro_vuelo,modelo,dia_sale,hora_sale,hora_llega,tiempo_estimado,fecha,ciudad_llega,ciudad_sale,estado_sale,estado_llega FROM vuelos_disponibles WHERE fecha='"+Fechas.convertirDateADateSQL(fechaVuelo)+"' AND ciudad_llega='"+destino.getCiudad()+"' AND ciudad_sale='"+origen.getCiudad()+"' AND estado_llega='"+destino.getEstado()+"' AND estado_sale='"+origen.getEstado()+"'";
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
				aux.setFechaVuelo(Fechas.convertirDateADateSQL(fechaVuelo));
				aux.setAeropuertoLlegada(conseguirAeropuerto(rs.getString("codigo_aero_llega"),destino));
				aux.setAeropuertoSalida(conseguirAeropuerto(rs.getString("codigo_aero_sale"),origen));
				resultado.add(aux);
			}
		} catch (SQLException e) {
			logger.error("SQLException: " + e.getMessage());
			logger.error("SQLState: " + e.getSQLState());
			logger.error("VendorError: " + e.getErrorCode());		   
			throw new Exception("Error al recuperar los vuelos disponibles");
		} 
		return resultado;
	}
	
	/** 
	 * TODO (Hecho?)Debe retornar una lista de clases, precios y asientos disponibles de dicho vuelo.		   
	 *      Debe propagar una excepción si hay algún error en la consulta.    
	 *      
	 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
	 *      establecida con el servidor de B.D. (inicializada en el constructor DAOVuelosImpl(...)).
	 * @throws Exception 
	 */
	@Override
	public ArrayList<DetalleVueloBean> recuperarDetalleVuelo(InstanciaVueloBean vuelo) throws Exception   {
		logger.info("recupera los detalles de vuelo pasados por parametros.");
		ArrayList<DetalleVueloBean> resultado = new ArrayList<DetalleVueloBean>();
		try {
			ResultSet rs = null;
			String sql = "SELECT precio,asientos_disponibles,clase,fecha FROM vuelos_disponibles WHERE fecha='"+Fechas.convertirDateADateSQL(vuelo.getFechaVuelo())+"' AND nro_vuelo='"+vuelo.getNroVuelo()+"'; ";
			Statement select = conexion.createStatement();
			rs = select.executeQuery(sql);
			while(rs.next()) {
				DetalleVueloBean aux = new DetalleVueloBeanImpl();
				aux.setVuelo(vuelo);
				aux.setAsientosDisponibles(rs.getInt("asientos_disponibles"));
				aux.setClase(rs.getString("clase"));
				aux.setPrecio(rs.getFloat("precio"));
				resultado.add(aux);
			}
		} catch (SQLException e) {
			logger.error("SQLException: " + e.getMessage());
			logger.error("SQLState: " + e.getSQLState());
			logger.error("VendorError: " + e.getErrorCode());		   
			throw new Exception("Error al recuperar los detalles de vuelo");
		}
		return resultado; 
	}
}
