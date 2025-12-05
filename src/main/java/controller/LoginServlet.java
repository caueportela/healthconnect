package controller;

import dao.UsuarioDAO;
import dto.LoginRequestDTO;
import model.Usuario;
import org.json.JSONObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Importante para o login funcionar

import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Se tentar acessar /login direto pelo navegador, manda pra tela de login
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Ler o JSON (Igual você já tinha)
        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String linha;

        while ((linha = reader.readLine()) != null) {
            sb.append(linha);
        }

        JSONObject json = new JSONObject(sb.toString());
        LoginRequestDTO LoginRequest = new LoginRequestDTO(
                json.getString("email"),
                json.getString("senha")
        );

        // 2. Tentar Logar
        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuario;
        try {
            usuario = dao.login(LoginRequest.getEmail(), LoginRequest.getSenha());
        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write("{\"erro\":\"Erro interno no servidor\"}");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 3. Verifica se achou usuário
        if (usuario == null) {
            response.setStatus(401);
            response.getWriter().write("{\"erro\":\"Email ou senha incorretos\"}");
            return;
        }

        // --- AQUI ESTÁ A CORREÇÃO ---

        // 4. CRIA A SESSÃO (Essencial para o JSP funcionar)
        HttpSession session = request.getSession();
        session.setAttribute("usuarioLogado", usuario); // Grava o usuário na memória do servidor

        // 5. Define para onde ele vai
        String urlDestino;
        if (usuario.getTipo().equalsIgnoreCase("PROFISSIONAL")) {
            urlDestino = "dashboard-profissional.jsp";
        } else {
            urlDestino = "paciente-main.jsp";
        }

        // 6. Retorna o JSON com a URL de destino
        JSONObject responseJson = new JSONObject();
        responseJson.put("id", usuario.getId());
        responseJson.put("email", usuario.getEmail());
        responseJson.put("tipo", usuario.getTipo());
        responseJson.put("redirectUrl", urlDestino); // O Front vai ler isso e redirecionar

        response.getWriter().write(responseJson.toString());
    }
}