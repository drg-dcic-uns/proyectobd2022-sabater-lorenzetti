package vuelos.modelo.empleado.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.empleado.beans.EmpleadoBean;
import vuelos.modelo.empleado.beans.EmpleadoBeanImpl;

public class DAOEmpleadoImpl implements DAOEmpleado {

	private static Logger logger = LoggerFactory.getLogger(DAOEmpleadoImpl.class);
	
	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOEmpleadoImpl(Connection c) {
		this.conexion = c;
	}

	/**
	 * TODO (Hecho?)Debe recuperar de la B.D. los datos del empleado que corresponda al legajo pasado 
	 *      como parámetro y devolver los datos en un objeto EmpleadoBean. Si no existe el legajo 
	 *      deberá retornar null y si ocurre algun error deberá generar y propagar una excepción.	
	 *       
	 *      Nota: para acceder a la B.D. utilice la propiedad "conexion" que ya tiene una conexión
	 *      establecida con el servidor de B.D. (inicializada en el constructor DAOEmpleadoImpl(...)). 
	 * @throws Exception 
	 */	
	@Override
	public EmpleadoBean recuperarEmpleado(int legajo) throws Exception {
		logger.info("recupera el empleado que corresponde al legajo {}.", legajo);
		EmpleadoBean empleado = new EmpleadoBeanImpl();
		try {
			ResultSet rs = null;
			String sql = "SELECT * FROM empleados WHERE legajo='"+legajo+"'";
			Statement select = conexion.createStatement();
			rs = select.executeQuery(sql);
			if (rs.next()) {
				empleado.setLegajo(rs.getInt("legajo"));
				empleado.setPassword(rs.getString("password"));
				empleado.setNroDocumento(rs.getInt("doc_nro"));
				empleado.setTipoDocumento(rs.getString("doc_tipo"));
				empleado.setApellido(rs.getString("apellido"));
				empleado.setNombre(rs.getString("nombre"));
				empleado.setDireccion(rs.getString("direccion"));
				empleado.setTelefono(rs.getString("telefono"));
			}
			else {
				empleado = null;
			}
		} catch (SQLException e) {
			logger.error("SQLException: " + e.getMessage());
			logger.error("SQLState: " + e.getSQLState());
			logger.error("VendorError: " + e.getErrorCode());		   
			throw new Exception("Error al recuperar el empleado");
		}
		return empleado;
	}

}
