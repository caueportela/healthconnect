package dao;

import connector.PostgresConnector;
import model.Paciente;
import model.Usuario;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class PacienteDAO {

    // 1. Cria o vinculo na tabela PACIENTE logo após o cadastro
    public void createPaciente(Paciente paciente) throws Exception {
        String sql = "INSERT INTO paciente (usuario_id) VALUES (?)";

        PreparedStatement stmt = PostgresConnector.getInstance().prepareStatement(sql);

        // Pega o ID do Usuario que já foi salvo antes
        stmt.setLong(1, paciente.getUsuario().getId());

        stmt.executeUpdate();
        stmt.close();
    }

    public Long getPacienteIdByUsuarioId(Long usuarioId) throws Exception {
        String sql = "SELECT id FROM paciente WHERE usuario_id = ?";

        PreparedStatement stmt = PostgresConnector.getInstance().prepareStatement(sql);
        stmt.setLong(1, usuarioId);

        ResultSet rs = stmt.executeQuery();

        Long idPaciente = null;
        if (rs.next()) {
            idPaciente = rs.getLong("id");
        }

        rs.close();
        stmt.close();

        return idPaciente; // Retorna null se não encontrar
    }
}