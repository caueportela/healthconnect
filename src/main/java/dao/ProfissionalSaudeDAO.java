package dao;

import connector.PostgresConnector;
import model.ProfissionalSaude;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProfissionalSaudeDAO {

    public void createProfissionalSaude(ProfissionalSaude ps) throws Exception {
        String sql = "INSERT INTO profissional_saude (usuario_id, registro) VALUES (?, ?)";

        PreparedStatement stmt = PostgresConnector.getInstance().prepareStatement(sql);

        stmt.setLong(1, ps.getUsuario().getId());
        stmt.setString(2, ps.getRegistro());

        stmt.executeUpdate();
        stmt.close();
    }

    // Método auxiliar para listar os médicos na hora de agendar
    public List<ProfissionalSaude> listarTodos() throws Exception {
        String sql = "SELECT p.*, u.nome, u.email FROM profissional_saude p " +
                "JOIN usuario u ON p.usuario_id = u.id";

        PreparedStatement stmt = PostgresConnector.getInstance().prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();

        List<ProfissionalSaude> lista = new ArrayList<>();

        while(rs.next()) {
            ProfissionalSaude ps = new ProfissionalSaude();
            ps.setId(rs.getLong("id"));
            ps.setRegistro(rs.getString("registro"));

            model.Usuario u = new model.Usuario();
            u.setId(rs.getLong("usuario_id"));
            u.setNome(rs.getString("nome"));
            u.setEmail(rs.getString("email"));

            ps.setUsuario(u);
            lista.add(ps);
        }
        rs.close();
        stmt.close();
        return lista;
    }

    // --- ESTE É O MÉTODO QUE ESTAVA FALTANDO E CAUSOU O ERRO ---
    public Long getIdByUsuarioId(Long usuarioId) throws Exception {
        String sql = "SELECT id FROM profissional_saude WHERE usuario_id = ?";

        PreparedStatement stmt = PostgresConnector.getInstance().prepareStatement(sql);
        stmt.setLong(1, usuarioId);

        ResultSet rs = stmt.executeQuery();

        Long id = null;
        if (rs.next()) {
            id = rs.getLong("id");
        }

        rs.close();
        stmt.close();

        return id; // Retorna null se não encontrar (ex: login de admin ou erro)
    }
}