package connector;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class PostgresConnector {
    private Connection conn = null;
    private static PostgresConnector instance = null;

    private PostgresConnector() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");  // Carrega o driver JDBC explicitamente
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver PostgreSQL não encontrado!", e);
        }
        this.conn = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5434/healthconnect",
                "postgres",
                "250682"
        );
    }

    // Metodo getInstance, que vai ser usado na aplicação.
    public static PostgresConnector getInstance() {
        if (instance == null) {
            try {
                instance = new PostgresConnector();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
        return instance;
    }

    public static void close() {
        if (instance != null) {
            try {
                instance.conn.close();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
    }

    // Retorna o PreparedStatement
    public PreparedStatement prepareStatement(String sql) throws SQLException {
        return this.conn.prepareStatement(sql);
    }
}

