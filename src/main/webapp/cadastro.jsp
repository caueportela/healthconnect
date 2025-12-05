<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <title>Cadastro</title>

    <!-- Fonte Roboto, mesmo padrão do login -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap&subset=latin-ext" rel="stylesheet" />

    <style>
        body {
            background:
                linear-gradient(rgba(0,0,0,0.35), rgba(0,0,0,0.35)),
                url("ImagemCadastro.png");
            background-size: cover;
            background-position: center;

            font-family: 'Roboto', sans-serif;
            margin: 0;
            height: 100vh;

            display: flex;
            justify-content: center;
            align-items: center;
        }

        .container {
            background-color: #ffffff;
            width: 360px;
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid #e3e6ef;
        }

        h2, h3 {
            text-align: center;
            margin: 0 0 15px 0;
            font-weight: 500;
        }

        h2 span {
            color: #4FA58F;
            font-weight: 700;
        }

        input, select, button {
            width: 100%;
            padding: 12px;
            margin-bottom: 16px;
            border: 1px solid #cfd4df;
            border-radius: 6px;
            font-size: 14px;
            background-color: #fff;
        }

        input:focus, select:focus {
            border-color: #4FA58F;
            outline: none;
            box-shadow: 0 0 4px rgba(79,165,143,0.3);
        }

        button {
            background-color: #4484b4;
            color: white;
            border: none;
            font-weight: 600;
            cursor: pointer;
            border-radius: 6px;
            transition: 0.2s ease;
        }

        button:hover {
            background-color: #3a739e;
            transform: translateY(-1px);
        }

        a {
            color: #4484b4;
            text-decoration: none;
            font-weight: 600;
        }

        a:hover {
            text-decoration: underline;
        }

        #registroDiv {
            display: none;
        }

        p {
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Cadastro no <span>healthconnect</span></h2>
    <h3>Preencha os dados</h3>

    <form id="cadastroForm">
        <input type="text" id="nome" placeholder="Nome" required />
        <input type="email" id="email" placeholder="Email" required />
        <input type="password" id="senha" placeholder="Senha" required />

        <select id="tipo" required>
            <option value="">Selecione o tipo</option>
            <option value="paciente">Paciente</option>
            <option value="medico">Médico</option>
            <option value="psicologo">Psicólogo</option>
            <option value="fisioterapeuta">Fisioterapeuta</option>
            <option value="dentista">Dentista</option>
            <option value="nutricionista">Nutricionista</option>
        </select>

        <div id="registroDiv">
            <input type="text" id="registro" placeholder="Registro Profissional" />
        </div>

        <button type="submit">Cadastrar</button>
    </form>

    <p>Já tem conta? <a href="login.jsp">Login</a></p>
</div>


<script>
    const tipoSelect = document.getElementById("tipo");
    const registroDiv = document.getElementById("registroDiv");
    const registroInput = document.getElementById("registro");

    tipoSelect.addEventListener("change", () => {
        if (tipoSelect.value === "paciente") {
            registroDiv.style.display = "none";
            registroInput.required = false;
            registroInput.value = "";
        } else if (tipoSelect.value !== "") {
            registroDiv.style.display = "block";
            registroInput.required = true;
        } else {
            registroDiv.style.display = "none";
            registroInput.required = false;
            registroInput.value = "";
        }
    });

    document.getElementById("cadastroForm").addEventListener("submit", async (e) => {
        e.preventDefault();

        const data = {
            nome: document.getElementById("nome").value,
            email: document.getElementById("email").value,
            senha: document.getElementById("senha").value,
            tipo: document.getElementById("tipo").value,
            registro: registroInput.value
        };

        const res = await fetch("cadastro", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data)
        });

        const result = await res.json();
        if (res.ok) {
            alert(result.mensagem);
            window.location.href = "login.jsp";
        } else {
            alert(result.erro);
        }
    });
</script>

</body>
</html>
