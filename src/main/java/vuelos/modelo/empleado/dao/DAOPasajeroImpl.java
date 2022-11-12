package vuelos.modelo.empleado.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.empleado.beans.*;
import vuelos.modelo.empleado.dao.datosprueba.DAOPasajeroDatosPrueba;
import vuelos.utils.Fechas;

public class DAOPasajeroImpl implements DAOPasajero {

	private static Logger logger = LoggerFactory.getLogger(DAOPasajeroImpl.class);
	
	private static final long serialVersionUID = 1L;

	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOPasajeroImpl(Connection conexion) {
		this.conexion = conexion;
	}


	/**
	 * TODO (parte 2) Deberá recuperar de la B.D. los datos de un pasajero que tenga el tipo de documento y 
	 *      numero pasados como parámetro y devolver los datos en un objeto EmpleadoBean. 
	 *      Si no existe el pasajero deberá retornar null y si ocurre algun error deberá 
	 *      generar y propagar una excepción.
	 *
	 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
	 *      establecida con el servidor de B.D. (inicializada en el constructor DAOPasajeroImpl(...)). 
	 * @throws Exception 
	 */		
	/*
	 * Datos estáticos de prueba. Quitar y reemplazar por código que recupera los datos reales.  
	 */ 
	
	@Override
	public PasajeroBean recuperarPasajero(String tipoDoc, int nroDoc) throws Exception  {
		PasajeroBean pasajero = new PasajeroBeanImpl();
		logger.info("El DAO retorna al pasajero {} {}", pasajero.getApellido(), pasajero.getNombre());
		try {
			ResultSet rs = null;
			String sql = "SELECT doc_nro,doc_tipo,apellido,nombre,direccion,telefono,nacionalidad FROM pasajeros WHERE doc_nro='"+nroDoc+"' AND doc_tipo='"+tipoDoc+"';";
			Statement select = conexion.createStatement();
			rs = select.executeQuery(sql);
			if(rs.next()) {
				pasajero.setTipoDocumento(tipoDoc);
				pasajero.setNroDocumento(nroDoc);
				pasajero.setApellido(rs.getString("apellido"));
				pasajero.setNombre(rs.getString("nombre"));
				pasajero.setDireccion(rs.getString("direccion"));
				pasajero.setTelefono(rs.getString("telefono"));
				pasajero.setNacionalidad(rs.getString("nacionalidad"));
			}else {
				pasajero = null;
			}
		} catch (SQLException e) {
			logger.error("SQLException: " + e.getMessage());
			logger.error("SQLState: " + e.getSQLState());
			logger.error("VendorError: " + e.getErrorCode());		   
			throw new Exception("Error al recuperar un pasajero");
		}		
		return pasajero;
	}
	
	

}
