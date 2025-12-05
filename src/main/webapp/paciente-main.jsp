<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="dao.ConsultaDAO" %>
<%@ page import="dao.PacienteDAO" %>
<%@ page import="model.Consulta" %>
<%@ page import="model.Usuario" %>

<%
    // 1. SEGURANÇA: Verifica se tem usuário na sessão
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null || !"PACIENTE".equalsIgnoreCase(usuarioLogado.getTipo())) {
        response.sendRedirect("login.jsp"); // Chuta o usuário para fora se não for paciente
        return;
    }

    // 2. BUSCAR DADOS: Pega o ID do Paciente e lista as consultas
    List<Consulta> minhasConsultas = null;
    try {
        PacienteDAO pacienteDAO = new PacienteDAO();
        Long idPaciente = pacienteDAO.getPacienteIdByUsuarioId(usuarioLogado.getId());

        if (idPaciente != null) {
            ConsultaDAO consultaDAO = new ConsultaDAO();
            minhasConsultas = consultaDAO.listarPorPaciente(idPaciente);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Formatador de data para ficar bonito na tela (Ex: 20/11/2025 14:00)
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Consultas - HealthConnect</title>

  <style>
      body { font-family: "Poppins", sans-serif; background: #F5F9F8; color: #333; margin: 0; }
      header { background: #4FA58F; color: #fff; padding: 20px 60px; display: flex; justify-content: space-between; align-items: center; }
      .logo { font-size: 24px; font-weight: bold; }
      nav a { margin-left: 20px; text-decoration: none; color: #fff; transition: 0.3s; }
      nav a:hover { color: #FF7043; }
      .consultas { padding: 40px 20px; max-width: 1000px; margin: 0 auto; }
      .consultas h1 { font-size: 32px; color: #2E8B57; margin-bottom: 10px; }
      .consultas p { font-size: 18px; margin-bottom: 30px; color: #555; }
      table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 6px 12px rgba(0,0,0,0.1); }
      thead { background: #4FA58F; color: #fff; }
      th, td { padding: 15px; text-align: left; border-bottom: 1px solid #ddd; }
      tbody tr:hover { background: #f0f0f0; }
      footer { background: #4FA58F; color: #fff; text-align: center; padding: 15px; margin-top: 40px; }

      /* Classes de status para dar cor */
      .status-agendada { color: green; font-weight: bold; }
      .status-cancelada { color: red; font-weight: bold; }
  </style>
</head>
<body>

  <header>
    <div class="logo">HealthConnect</div>
    <nav>
      <a href="paciente-main.jsp">Início</a>
      <a href="lista-profissionais.jsp">Nova Consulta</a>
      <a href="perfil">Perfil</a>
      <a href="logout">Sair</a>
    </nav>
  </header>

  <section class="consultas">
    <h1>Olá, <%= usuarioLogado.getNome() %>!</h1>
    <p>Abaixo estão listadas suas consultas agendadas:</p>

    <table>
      <thead>
        <tr>
          <th>Data e Hora</th>
          <th>Profissional</th>
          <th>Registro</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <%
        // 3. LOOP: Gera o HTML dinamicamente baseado na lista do banco
        if (minhasConsultas != null && !minhasConsultas.isEmpty()) {
            for (Consulta c : minhasConsultas) {
        %>
            <tr>
              <td><%= c.getDataHora().format(formatter) %></td>
              <td>Dr(a). <%= c.getProfissionalSaude().getUsuario().getNome() %></td>
              <td><%= c.getProfissionalSaude().getRegistro() %></td>
              <td class="<%= c.getStatus().equalsIgnoreCase("CANCELADA") ? "status-cancelada" : "status-agendada" %>">
                  <%= c.getStatus() %>
              </td>
            </tr>
        <%
            }
        } else {
        %>
            <tr>
                <td colspan="4" style="text-align:center; padding: 20px;">
                    Você ainda não tem consultas agendadas.
                </td>
            </tr>
        <% } %>
      </tbody>
    </table>
  </section>

  <footer>
    <p>&copy; 2025 HealthConnect - Todos os direitos reservados</p>
  </footer>

</body>
</html>