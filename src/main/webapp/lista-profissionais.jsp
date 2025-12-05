<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="dao.ProfissionalSaudeDAO" %>
<%@ page import="model.ProfissionalSaude" %>
<%@ page import="model.Usuario" %>

<%

    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<ProfissionalSaude> listaMedicos = null;
    try {
        ProfissionalSaudeDAO dao = new ProfissionalSaudeDAO();
        listaMedicos = dao.listarTodos();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Agendar com Médico - HealthConnect</title>

  <style>
    /* --- SEU CSS ORIGINAL --- */
    body { font-family: "Poppins", sans-serif; background: #F5F9F8; color: #333; margin: 0; }

    header { background: #4FA58F; color: #fff; padding: 20px 60px; display: flex; justify-content: space-between; align-items: center; }
    .logo { font-size: 24px; font-weight: bold; }
    nav a { margin-left: 20px; text-decoration: none; color: #fff; transition: 0.3s; }
    nav a:hover { color: #FF7043; }

    .agendamento { padding: 40px 20px; text-align: center; }
    .agendamento h1 { font-size: 32px; color: #2E8B57; margin-bottom: 30px; }

    /* Grid Responsivo para os Cards */
    .profissionais { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px; max-width: 1000px; margin: 0 auto; }

    .card { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 6px 12px rgba(0,0,0,0.1); text-align: left; display: flex; flex-direction: column; justify-content: space-between; }

    .card h2 { font-size: 22px; color: #4FA58F; margin-bottom: 5px; margin-top: 0; }
    .card p { font-size: 16px; margin-bottom: 10px; color: #555; }

    /* Estilo para o input de data dentro do card */
    .input-data {
        width: 100%;
        padding: 10px;
        margin: 10px 0;
        border: 1px solid #ccc;
        border-radius: 6px;
        box-sizing: border-box;
    }

    .btn { display: block; width: 100%; text-align: center; padding: 12px 0; background: #4FA58F; color: #fff; border-radius: 6px; text-decoration: none; transition: background 0.3s; border: none; font-size: 16px; cursor: pointer; box-sizing: border-box; }
    .btn:hover { background: #3C7A6F; }
    .btn:disabled { background: #ccc; cursor: not-allowed; }

    footer { background: #4FA58F; color: #fff; text-align: center; padding: 15px; margin-top: 40px; }
  </style>
</head>
<body>

  <header>
    <div class="logo">HealthConnect</div>
    <nav>
      <a href="paciente-main.jsp">Minhas Consultas</a>
      <a href="perfil">Perfil</a>
      <a href="logout">Sair</a>
    </nav>
  </header>

  <section class="agendamento">
    <h1>Escolha um profisisonal e agende</h1>

    <div class="profissionais">

      <%

      if (listaMedicos != null && !listaMedicos.isEmpty()) {
          for (ProfissionalSaude p : listaMedicos) {
      %>

          <!-- CARD DINÂMICO -->
          <div class="card">
            <div>

                <h2>Dr(a). <%= p.getUsuario().getNome() %></h2>


                <p><strong>CRM:</strong> <%= p.getRegistro() %></p>
                <p>Selecione o melhor horário:</p>
            </div>

            <!-- Input único para este card (usamos o ID do médico para diferenciar) -->
            <input type="datetime-local" class="input-data" id="data-<%= p.getId() %>">

            <!-- Botão chama a função passando o ID e o Nome deste médico -->
            <button class="btn" onclick="agendarConsulta(<%= p.getId() %>, '<%= p.getUsuario().getNome() %>')">
                Confirmar Agendamento
            </button>
          </div>

      <%
          }
      } else {
      %>
          <p>Nenhum profissional encontrado no sistema.</p>
      <% } %>

    </div>
  </section>

  <footer>
    <p>&copy; 2025 HealthConnect - Todos os direitos reservados</p>
  </footer>

  <!-- LÓGICA JAVASCRIPT PARA ENVIAR AO BACKEND -->
  <script>
    async function agendarConsulta(idProfissional, nomeMedico) {

        // 1. Pega a data específica do card que foi clicado
        const inputData = document.getElementById("data-" + idProfissional);
        const dataHora = inputData.value;

        if (!dataHora) {
            alert("Por favor, selecione uma data e hora para o Dr(a). " + nomeMedico);
            return;
        }

        if (!confirm("Confirmar agendamento com Dr(a). " + nomeMedico + " para " + dataHora + "?")) {
            return;
        }

        // 2. Envia para o Backend (AgendamentoServlet)
        try {
            const response = await fetch('agendamento', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    profissionalId: idProfissional,
                    dataHora: dataHora,
                    descricao: "Agendado via Lista de Profissionais"
                })
            });

            const result = await response.json();

            if (response.ok) {
                alert("✅ Consulta agendada com sucesso!");
                window.location.href = "paciente-main.jsp"; // Redireciona para ver a consulta na lista
            } else {
                alert("❌ Erro: " + (result.erro || "Não foi possível agendar."));
            }

        } catch (error) {
            console.error(error);
            alert("Erro de conexão com o servidor.");
        }
    }
  </script>

</body>
</html>