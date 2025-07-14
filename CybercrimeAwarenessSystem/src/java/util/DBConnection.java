package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // This is the embedded Derby connection string
        String dbURL = "jdbc:derby://localhost:1527/cybercrime_db";
        String username = "app";  // Your DB username
        String password = "app";  // Your DB password

        Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
        return DriverManager.getConnection(dbURL, username, password);
    }
}


