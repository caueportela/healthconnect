package dao;

import connector.PostgresConnector;
import model.Consulta;
import model.Paciente;
import model.ProfissionalSaude;
import model.Usuario;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ConsultaDAO {

    // 1. MARCAR CONSULTA (Para o Paciente)
    public void agendar(Consulta consulta) throws Exception {
        String sql = "INSERT INTO consulta (paciente_id, profissional_id, data_hora, descricao, status) VALUES (?, ?, ?, ?, ?)";

        PreparedStatement stmt = PostgresConnector.getInstance().prepareStatement(sql);

        // Pega os IDs de dentro dos objetos
        stmt.setLong(1, consulta.getPaciente().getId());
        stmt.setLong(2, consulta.getProfissionalSaude().getId());

        // Conversão crítica: LocalDateTime (Java) -> Timestamp (Banco)
        stmt.setTimestamp(3, Timestamp.valueOf(consulta.getDataHora()));

        stmt.setString(4, consulta.getDescricao());
        stmt.setString(5, "AGENDADA"); // Status padrão

        stmt.executeUpdate();
        stmt.close();
    }


    public List<Consulta> listarPorProfissional(long idProfissional) throws Exception {
        String sql = "SELECT c.*, u.nome as nome_paciente, u.email as email_paciente " +
                "FROM consulta c " +
                "JOIN paciente p ON c.paciente_id = p.id " +
                "JOIN usuario u ON p.usuario_id = u.id " +
                "WHERE c.profissional_id = ?";

        PreparedStatement stmt = PostgresConnector.getInstance().prepareStatement(sql);
        stmt.setLong(1, idProfissional);
        ResultSet rs = stmt.executeQuery();

        List<Consulta> lista = new ArrayList<>();

        while (rs.next()) {
            Consulta c = new Consulta();
            c.setIdConsulta(rs.getLong("id_consulta"));
            c.setDataHora(rs.getTimestamp("data_hora").toLocalDateTime());
            c.setDescricao(rs.getString("descricao"));
            c.setStatus(rs.getString("status"));

            // Reconstrói o objeto Paciente apenas com os dados necessários para exibição
            Paciente p = new Paciente();
            p.setId(rs.getLong("paciente_id"));

            Usuario u = new Usuario();
            u.setNome(rs.getString("nome_paciente"));
            u.setEmail(rs.getString("email_paciente"));
            p.setUsuario(u);

            c.setPaciente(p); // Coloca o paciente dentro da consulta

            lista.add(c);
        }
        rs.close();
        stmt.close();
        return lista;
    }

    public List<Consulta> listarPorPaciente(long idPaciente) throws Exception {
        // Faz o JOIN para pegar o nome do Médico (Profissional)
        String sql = "SELECT c.*, u_medico.nome as nome_medico, ps.registro " +
                "FROM consulta c " +
                "JOIN profissional_saude ps ON c.profissional_id = ps.id " +
                "JOIN usuario u_medico ON ps.usuario_id = u_medico.id " +
                "WHERE c.paciente_id = ? " +
                "ORDER BY c.data_hora DESC"; // Ordena das mais recentes para as antigas

        PreparedStatement stmt = PostgresConnector.getInstance().prepareStatement(sql);
        stmt.setLong(1, idPaciente);
        ResultSet rs = stmt.executeQuery();

        List<Consulta> lista = new ArrayList<>();

        while (rs.next()) {
            Consulta c = new Consulta();
            c.setIdConsulta(rs.getLong("id_consulta"));
            c.setDataHora(rs.getTimestamp("data_hora").toLocalDateTime());
            c.setStatus(rs.getString("status"));

            // Monta o objeto Profissional para exibir na tabela
            ProfissionalSaude ps = new ProfissionalSaude();
            ps.setRegistro(rs.getString("registro")); // Pega o CRM/Registro

            Usuario uMedico = new Usuario();
            uMedico.setNome(rs.getString("nome_medico")); // Pega o nome do médico

            ps.setUsuario(uMedico);
            c.setProfissionalSaude(ps); // Coloca o médico dentro da consulta

            lista.add(c);
        }
        rs.close();
        stmt.close();
        return lista;
    }
    public void cancelar(long idConsulta) throws Exception {
        // Opção A: Delete físico (apaga do banco)
        String sql = "DELETE FROM consulta WHERE id_consulta = ?";

        // Opção B (Melhor): Apenas muda o status
        // String sql = "UPDATE consulta SET status = 'CANCELADA' WHERE id_consulta = ?";

        PreparedStatement stmt = PostgresConnector.getInstance().prepareStatement(sql);
        stmt.setLong(1, idConsulta);
        stmt.executeUpdate();
        stmt.close();
    }
}