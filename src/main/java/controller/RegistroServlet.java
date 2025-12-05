package controller;

import dao.PacienteDAO;
import dao.ProfissionalSaudeDAO;
import dao.UsuarioDAO;
import dto.RegistroRequestDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Paciente;
import model.ProfissionalSaude;
import model.Usuario;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/cadastro")
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Lê o JSON
        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String linha;
        while ((linha = reader.readLine()) != null) {
            sb.append(linha);
        }

        JSONObject json = new JSONObject(sb.toString());

        // 2. Cria DTO
        RegistroRequestDTO requestDTO = new RegistroRequestDTO(
                json.getString("nome"),
                json.getString("email"),
                json.getString("senha"),
                json.getString("tipo"),
                json.optString("registro")
        );

        // 3. Validação Básica
        if (!requestDTO.getTipo().equalsIgnoreCase("paciente") && !requestDTO.getTipo().equalsIgnoreCase("profissional")) {
            // Opcional: validar se o tipo é válido
        }

        if (!requestDTO.getTipo().equalsIgnoreCase("paciente")) {
            if (requestDTO.getRegistro() == null || requestDTO.getRegistro().isEmpty()) {
                response.setStatus(400);
                response.setContentType("application/json");
                response.getWriter().write("{\"erro\":\"Registro profissional é obrigatório\"}");
                return;
            }
        }

        // 4. Monta o Usuário Base
        Usuario usuario = new Usuario();
        usuario.setNome(requestDTO.getNome());
        usuario.setEmail(requestDTO.getEmail());
        usuario.setSenha(requestDTO.getSenha());
        if (!requestDTO.getTipo().equalsIgnoreCase("PACIENTE")) {
            usuario.setTipo("PROFISSIONAL");
        } else {
            usuario.setTipo("PACIENTE");
        }

        UsuarioDAO usuarioDAO = new UsuarioDAO();

        try {
            // AQUI É O PULO DO GATO:
            // O usuarioDAO.createUsuario(usuario) DEVE retornar o objeto com o ID preenchido
            // (Conforme ajustamos na resposta anterior com 'RETURNING id')
            Usuario usuarioSalvo = usuarioDAO.createUsuario(usuario);

            // 5. Verifica o tipo e salva na tabela específica usando o ID gerado
            if (usuarioSalvo.getTipo().equalsIgnoreCase("PACIENTE")) {

                Paciente paciente = new Paciente();
                paciente.setUsuario(usuarioSalvo); // Passa o usuário COM ID

                PacienteDAO pacienteDAO = new PacienteDAO();
                pacienteDAO.createPaciente(paciente);

            } else if (usuarioSalvo.getTipo().equalsIgnoreCase("PROFISSIONAL")) {

                ProfissionalSaude profissional = new ProfissionalSaude();
                profissional.setUsuario(usuarioSalvo); // Passa o usuário COM ID
                profissional.setRegistro(requestDTO.getRegistro());

                ProfissionalSaudeDAO profissionalDAO = new ProfissionalSaudeDAO();
                profissionalDAO.createProfissionalSaude(profissional);
            }

        } catch (Exception e) {
            // mas por enquanto vamos só avisar o erro.
            response.setStatus(500);
            response.setContentType("application/json");
            response.getWriter().write("{\"erro\":\"Erro ao salvar no banco: " + e.getMessage() + "\"}");
            e.printStackTrace();
            return;
        }

        // Sucesso
        response.setStatus(201);
        response.setContentType("application/json");
        response.getWriter().write("{\"mensagem\":\"Cadastro realizado com sucesso!\"}");
    }
}