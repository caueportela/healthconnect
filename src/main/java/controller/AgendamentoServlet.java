package controller;

import dao.ConsultaDAO;
import dao.PacienteDAO;
import model.Consulta;
import model.Paciente;
import model.ProfissionalSaude;
import model.Usuario;
import org.json.JSONObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/agendamento")
public class AgendamentoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


        HttpSession session = req.getSession(false);
        Usuario usuarioLogado = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;

        if (usuarioLogado == null) {
            resp.setStatus(401);
            resp.getWriter().write("{\"erro\": \"Usuário não logado\"}");
            return;
        }

        // 2. Ler o JSON enviado pelo Frontend
        BufferedReader reader = req.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        try {
            JSONObject json = new JSONObject(sb.toString());

            // 3. Extrair dados do JSON
            long profissionalId = json.getLong("profissionalId");
            String dataString = json.getString("dataHora"); // Formato esperado: "2023-12-01T14:30"
            String descricao = json.optString("descricao", "");

            // 4. Converter String para LocalDateTime
            LocalDateTime dataHora = LocalDateTime.parse(dataString);

            // 5. Preparar os objetos para o DAO
            PacienteDAO pacienteDAO = new PacienteDAO();
            Long idPaciente = pacienteDAO.getPacienteIdByUsuarioId(usuarioLogado.getId());

            if (idPaciente == null) {
                resp.setStatus(403);
                resp.getWriter().write("{\"erro\": \"Apenas pacientes podem marcar consultas.\"}");
                return;
            }

            Paciente paciente = new Paciente();
            paciente.setId(idPaciente);

            ProfissionalSaude profissional = new ProfissionalSaude();
            profissional.setId(profissionalId);

            Consulta consulta = new Consulta();
            consulta.setPaciente(paciente);
            consulta.setProfissionalSaude(profissional);
            consulta.setDataHora(dataHora);
            consulta.setDescricao(descricao);

            // 6. Salvar no Banco
            ConsultaDAO consultaDAO = new ConsultaDAO();
            consultaDAO.agendar(consulta);

            // 7. Resposta de Sucesso
            resp.setStatus(201);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"mensagem\": \"Consulta agendada com sucesso!\"}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"erro\": \"Erro ao agendar: " + e.getMessage() + "\"}");
        }
    }
}