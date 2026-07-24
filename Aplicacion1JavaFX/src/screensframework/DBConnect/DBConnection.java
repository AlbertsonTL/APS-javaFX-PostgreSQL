package screensframework.DBConnect;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static Connection conn;

    private static final String URL = "jdbc:postgresql://dpg-d9h5tdj7uimc73dhgbf0-a.virginia-postgres.render.com:5432/punto_ventas_javax?sslmode=require";
    private static final String USER = "admin_postgres";
    private static final String PASS = "yKQmdOqMi17KN1vKTvIKsU8HeGKAYZDg";

    /*
    // Configuración para MySQL
    private static final String URL = "jdbc:mysql://localhost:3306/sysventas";
    private static final String USER = "root";
    private static final String PASS = "";
    */

    public static Connection connect() throws SQLException {
        try {
            // Carga el driver (opcional en JDBC 4+)
            Class.forName("org.postgresql.Driver");
            // Para MySQL:
            // Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("No se encontró el driver JDBC.", e);
        }

        conn = DriverManager.getConnection(URL, USER, PASS);
        return conn;
    }

    public static Connection getConnection() throws SQLException {
        if (conn == null || conn.isClosed()) {
            connect();
        }
        return conn;
    }
}