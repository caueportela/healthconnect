<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="dao.ConsultaDAO" %>
<%@ page import="dao.ProfissionalSaudeDAO" %>
<%@ page import="model.Consulta" %>
<%@ page import="model.Usuario" %>

<%
    // --- LÓGICA JAVA (BACKEND NO FRONTEND) ---

    // 1. Segurança: Chuta para fora se não for médico
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
    if (usuario == null || !"PROFISSIONAL".equalsIgnoreCase(usuario.getTipo())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Busca os dados reais do banco
    List<Consulta> minhasConsultas = null;
    try {
        ProfissionalSaudeDAO profDao = new ProfissionalSaudeDAO();
        // Recupera o ID da tabela profissional_saude usando o ID do usuario logado
        Long idProfissional = profDao.getIdByUsuarioId(usuario.getId());

        if (idProfissional != null) {
            ConsultaDAO consultaDAO = new ConsultaDAO();
            // Busca as consultas agendadas para este médico
            minhasConsultas = consultaDAO.listarPorProfissional(idProfissional);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Formatadores para deixar a data bonita (Ex: "12" para o dia, "14:30" para a hora)
    DateTimeFormatter diaFormat = DateTimeFormatter.ofPattern("dd");
    DateTimeFormatter mesAnoFormat = DateTimeFormatter.ofPattern("MMMM yyyy");
    DateTimeFormatter horaFormat = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter dataCompleta = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>HealthConnect - Painel do Profissional</title>

  <style>
    /* --- SEU CSS ORIGINAL (INCLUÍDO AQUI PARA GARANTIR O FUNCIONAMENTO) --- */

    /* Reset */
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Poppins", sans-serif; }
    body { background: #F5F9F8; color: #333; }

    /* Header */
    header { background: #4FA58F; color: #fff; padding: 20px 60px; display: flex; justify-content: space-between; align-items: center; }
    .logo { font-size: 24px; font-weight: bold; }
    nav a { margin-left: 20px; text-decoration: none; color: #fff; transition: 0.3s; }
    nav a:hover { color: #FF7043; }

    /* Dashboard */
    .dashboard { padding: 40px 20px; text-align: center; }
    .dashboard h1 { font-size: 32px; color: #2E8B57; margin-bottom: 10px; }
    .dashboard p { font-size: 18px; margin-bottom: 30px; }

    /* Calendar */
    .calendar { max-width: 1000px; margin: 0 auto; background: #fff; border-radius: 12px; padding: 30px; box-shadow: 0 6px 12px rgba(0,0,0,0.1); }
    .calendar-header h2 { font-size: 24px; margin-bottom: 20px; color: #4FA58F; text-transform: capitalize; }

    /* Grid adaptado para mostrar cards de consulta */
    .calendar-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; }

    .day { background: #F0F0F0; border-radius: 8px; padding: 15px; min-height: 140px; position: relative; display: flex; flex-direction: column; justify-content: space-between; text-align: left; transition: transform 0.2s; }
    .day:hover { transform: translateY(-3px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }

    .date { font-size: 24px; font-weight: bold; color: #2E8B57; display: block; margin-bottom: 10px; border-bottom: 2px solid #ddd; padding-bottom: 5px; }

    .consultas p { font-size: 13px; margin: 5px 0; background: #fff; padding: 6px; border-radius: 4px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }

    /* Botão de Cancelar (Estilo novo para funcionalidade) */
    .btn-cancelar {
        background-color: #ff5252; color: white; border: none; padding: 6px;
        border-radius: 4px; cursor: pointer; font-size: 12px; font-weight: bold;
        width: 100%; margin-top: 8px; text-align: center;
    }
    .btn-cancelar:hover { background-color: #d32f2f; }

    .empty-msg { grid-column: 1 / -1; color: #888; padding: 20px; }

    /* Footer */
    footer { background: #4FA58F; color: #fff; text-align: center; padding: 15px; margin-top: 40px; }
  </style>
</head>
<body>

  <!-- Cabeçalho -->
  <header>
    <div class="logo">HealthConnect</div>
    <nav>
      <a href="dashboard-profissional.jsp">Agenda</a>
      <a href="perfil.jsp">Perfil</a>
      <a href="logout.jsp">Sair</a>
    </nav>
  </header>

  <!-- Painel principal -->
  <section class="dashboard">
    <h1>Olá, Dr(a). <%= usuario.getNome() %>!</h1>
    <p>Veja abaixo sua agenda de atendimentos futuros:</p>

    <div class="calendar">
      <div class="calendar-header">
        <!-- Mostra mês atual dinamicamente ou fixo se preferir -->
        <h2>Agenda de Consultas</h2>
      </div>

      <div class="calendar-grid">

        <%
        if (minhasConsultas != null && !minhasConsultas.isEmpty()) {
            for (Consulta c : minhasConsultas) {
        %>
            <!-- CARD DE CONSULTA -->
            <div class="day" id="consulta-<%= c.getIdConsulta() %>">
              <!-- Dia do mês em destaque -->
              <span class="date"><%= c.getDataHora().format(diaFormat) %> <small style="font-size:12px; color:#666;">/ <%= c.getDataHora().getMonthValue() %></small></span>

              <div class="consultas">
                <p><strong><%= c.getDataHora().format(horaFormat) %></strong> - <%= c.getPaciente().getUsuario().getNome() %></p>
                <p>Motivo: <%= c.getDescricao() != null && !c.getDescricao().isEmpty() ? c.getDescricao() : "Rotina" %></p>

                <button class="btn-cancelar" onclick="cancelarConsulta(<%= c.getIdConsulta() %>)">
                    Cancelar
                </button>
              </div>
            </div>
        <%
            }
        } else {
        %>
            <!-- Mensagem se não tiver consultas -->
            <div class="empty-msg">
                <h3>Nenhuma consulta agendada.</h3>
                <p>Aguarde novos agendamentos dos pacientes.</p>
            </div>
        <% } %>

      </div>
    </div>
  </section>

  <!-- Rodapé -->
  <footer>
    <p>&copy; 2025 HealthConnect - Todos os direitos reservados</p>
  </footer>

  <!-- SCRIPT LÓGICO PARA CANCELAR -->
  <script>
    async function cancelarConsulta(idConsulta) {
        if (!confirm("Tem certeza que deseja cancelar este atendimento? Esta ação não pode ser desfeita.")) {
            return;
        }

        try {
            const response = await fetch('cancelar-consulta', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ idConsulta: idConsulta })
            });

            const result = await response.json();

            if (response.ok) {
                // Sucesso: Remove o card da tela visualmente
                const card = document.getElementById("consulta-" + idConsulta);
                if (card) {
                    card.style.opacity = "0";
                    setTimeout(() => card.remove(), 500); // Aguarda fade out
                }
                alert("Consulta cancelada.");
            } else {
                alert("Erro: " + result.erro);
            }
        } catch (error) {
            console.error(error);
            alert("Erro de conexão com o servidor.");
        }
    }
  </script>

</body>
</html>