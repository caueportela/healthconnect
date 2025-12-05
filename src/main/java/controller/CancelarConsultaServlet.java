package controller;

import dao.ConsultaDAO;
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

@WebServlet("/cancelar-consulta")
public class CancelarConsultaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // 1. Segurança: Verifica se existe sessão e se o usuário é PROFISSIONAL
        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;

        if (usuario == null || !"PROFISSIONAL".equalsIgnoreCase(usuario.getTipo())) {
            resp.setStatus(403);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"erro\": \"Acesso negado. Apenas profissionais podem realizar esta ação.\"}");
            return;
        }

        // 2. Lê o corpo da requisição (JSON)
        BufferedReader reader = req.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        try {
            JSONObject json = new JSONObject(sb.toString());

            // O frontend deve enviar algo como: { "idConsulta": 55 }
            if (!json.has("idConsulta")) {
                resp.setStatus(400);
                resp.getWriter().write("{\"erro\": \"ID da consulta não fornecido.\"}");
                return;
            }

            long idConsulta = json.getLong("idConsulta");

            // 3. Chama o DAO para executar a exclusão/cancelamento no banco
            ConsultaDAO dao = new ConsultaDAO();
            dao.cancelar(idConsulta);

            // 4. Retorna sucesso
            resp.setStatus(200);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"mensagem\": \"Consulta cancelada com sucesso.\"}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"erro\": \"Erro interno ao cancelar: " + e.getMessage() + "\"}");
        }
    }
}