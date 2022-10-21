package vuelos.modelo.empleado.dao;

import java.sql.Connection;
import java.sql.ResultSet;
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

public class DAOVuelosImpl implements DAOVuelos {

	private static Logger logger = LoggerFactory.getLogger(DAOVuelosImpl.class);
	
	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOVuelosImpl(Connection conexion) {
		this.conexion = conexion;
	}
	/** 
	 * TODO Debe retornar una lista de vuelos disponibles para ese día con origen y destino según los parámetros. 
	 *      Debe propagar una excepción si hay algún error en la consulta.    
	 *      
	 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
	 *      establecida con el servidor de B.D. (inicializada en el constructor DAOVuelosImpl(...)).  
	 */
	@Override
	public ArrayList<InstanciaVueloBean> recuperarVuelosDisponibles(Date fechaVuelo, UbicacionesBean origen, UbicacionesBean destino)  throws Exception {		
		//Datos estáticos de prueba. Quitar y reemplazar por código que recupera los datos reales.
		ArrayList<InstanciaVueloBean> resultado = new ArrayList<InstanciaVueloBean>();  
		ResultSet rs = null;
		ResultSet rsa = null;
		String sql = "";
		Statement select = conexion.createStatement();
		rs = select.executeQuery(sql);
		while(rs.next()) {
			InstanciaVueloBean aux = new InstanciaVueloBeanImpl();
			//Aeropuerto de Salida
			AeropuertoBean salida = new AeropuertoBeanImpl();
			salida.setCodigo(rs.getString("codigo_aero_sale"));
			salida.setNombre(rs.getString("nombre_aero_sale"));
			String aeropuertos = ""; //Consigo telefo y direccion
			rsa = select.executeQuery(aeropuertos);
			salida.setTelefono(rsa.getString("telefono"));
			salida.setDireccion(rsa.getString("direccion"));
			salida.setUbicacion(origen);
			//Aeropuerto de llegada
			AeropuertoBean llegada = new AeropuertoBeanImpl();
			llegada.setCodigo(rs.getString("codigo_aero_sale"));
			llegada.setNombre(rs.getString("nombre_aero_sale"));
			aeropuertos = ""; //Consigo telefo y direccion
			rsa = select.executeQuery(aeropuertos);
			llegada.setTelefono(rsa.getString("telefono"));
			llegada.setDireccion(rsa.getString("direccion"));
			llegada.setUbicacion(destino);
			//Instancia de vuelos
			aux.setNroVuelo(rs.getString("nro_vuelo"));
			aux.setModelo(rs.getString("modelo"));
			aux.setDiaSalida(rs.getString("dia_sale"));
			aux.setHoraSalida(rs.getTime("hora_sale"));
			aux.setHoraLlegada(rs.getTime("hora_llega"));
			aux.setTiempoEstimado(rs.getTime("tiempo_estimado"));
			aux.setFechaVuelo(rs.getDate("fecha"));
			aux.setAeropuertoLlegada(llegada);
			aux.setAeropuertoSalida(salida);
			resultado.add(aux);
		}
		return resultado;
		// Fin datos estáticos de prueba.
	}
	
	/** 
	 * TODO Debe retornar una lista de clases, precios y asientos disponibles de dicho vuelo.		   
	 *      Debe propagar una excepción si hay algún error en la consulta.    
	 *      
	 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
	 *      establecida con el servidor de B.D. (inicializada en el constructor DAOVuelosImpl(...)).
	 */
	@Override
	public ArrayList<DetalleVueloBean> recuperarDetalleVuelo(InstanciaVueloBean vuelo) throws Exception {
		//Datos estáticos de prueba. Quitar y reemplazar por código que recupera los datos reales.
		ArrayList<DetalleVueloBean> resultado = new ArrayList<DetalleVueloBean>();
		ResultSet rs = null;
		String sql = "";
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
		return resultado; 
		// Fin datos estáticos de prueba.
	}
}
