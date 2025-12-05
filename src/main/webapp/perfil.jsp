<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>

<%
    Usuario usuarioLogado = (Usuario) request.getAttribute("usuarioLogado");

    if (usuarioLogado == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Perfil - HealthConnect</title>

    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: #F5F9F8;
            color: #333;
            margin: 0;
        }

        header {
            background: #4FA58F;
            color: #fff;
            padding: 20px 60px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo { font-size: 24px; font-weight: bold; }
        nav a { margin-left: 20px; text-decoration: none; color: #fff; transition: 0.3s; }
        nav a:hover { color: #FF7043; }

        .perfil-container {
            max-width: 700px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
        }

        h1 {
            color: #2E8B57;
            font-size: 30px;
            margin-bottom: 20px;
        }

        .info-box {
            background: #F0F7F6;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 25px;
        }

        .info-item {
            margin-bottom: 10px;
            font-size: 18px;
        }

        .info-item span {
            font-weight: bold;
            color: #2E8B57;
        }

        .btn-delete {
            background: #D9534F;
            color: white;
            padding: 14px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 18px;
            width: 100%;
            transition: 0.3s;
        }

        .btn-delete:hover {
            background: #B52B27;
        }

        footer {
            background: #4FA58F;
            color: #fff;
            text-align: center;
            padding: 15px;
            margin-top: 40px;
        }
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

<div class="perfil-container">

    <h1>Meu Perfil</h1>

    <div class="info-box">
        <div class="info-item">
            <span>Nome:</span> <%= usuarioLogado.getNome() %>
        </div>

        <div class="info-item">
            <span>E-mail:</span> <%= usuarioLogado.getEmail() %>
        </div>

        <div class="info-item">
            <span>Tipo:</span> <%= usuarioLogado.getTipo() %>
        </div>
    </div>

    <form method="post" onsubmit="return confirmar()">
        <button class="btn-delete">Excluir Conta</button>
    </form>

</div>

<footer>
    © 2025 HealthConnect - Todos os direitos reservados
</footer>

<script>
    function confirmar() {
        return confirm("Tem certeza que deseja excluir sua conta?");
    }
</script>

</body>
</html>
