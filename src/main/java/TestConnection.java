import connector.PostgresConnector;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TestConnection {
    public static void main(String[] args) {
        try {
            PostgresConnector db = PostgresConnector.getInstance();

            PreparedStatement stmt = db.prepareStatement("SELECT 1");
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) { // teste para saber se a conexão funciona, se for para else o banco ta vazio
                System.out.println("✅ Conexão com PostgreSQL funcionando!");
            } else {
                System.out.println(" Conexão falhou.");
            }

        } catch (Exception e) {
            System.out.println("Erro ao conectar:");
            e.printStackTrace();
        }
    }
}

