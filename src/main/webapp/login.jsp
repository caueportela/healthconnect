<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8" />
    <title>Login - HealthConnect</title>

    <!-- Fonte Roboto com suporte total a acentos -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap&subset=latin-ext" rel="stylesheet" />

    <style>
        body {

          background:
              linear-gradient(rgba(0,0,0,0.35), rgba(0,0,0,0.35)),
              url("imageLogin.jpg");
          background-size: cover;
          background-position: center;

          font-family: 'Roboto', sans-serif;
          background-color: #f5f7fb;
          margin: 0;
          height: 100vh;

          display: flex;
          justify-content: center;
          align-items: center;
        }

        .login-container {
            background-color: #ffffff;
            padding: 2.5rem;
            border-radius: 12px;
            width: 350px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid #e3e6ef;
            text-align: center;
        }

        .logo {
            font-size: 26px;
            font-weight: bold;
            color: #4FA58F;
            margin-bottom: 10px;
        }

        h2 {
            margin: 0;
            margin-bottom: 20px;
            font-size: 18px;
            font-weight: 500;
            color: #333;
        }

        .input-group {
            text-align: left;
            margin-bottom: 18px;
        }

        .input-group label {
            display: block;
            margin-bottom: 6px;
            color: #555;
            font-size: 14px;
            font-weight: 500;
        }

        .input-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #cfd4df;
            border-radius: 6px;
            font-size: 14px;
            background-color: #ffffff;
        }

        .input-group input:focus {
            border-color: #4FA58F;
            outline: none;
            box-shadow: 0 0 4px rgba(79,165,143,0.3);
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #4484b4;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s ease;
            margin-top: 5px;
        }

        button:hover {
            background-color: #3a739e;
            transform: translateY(-1px);
        }

        .links {
            margin-top: 20px;
            font-size: 14px;
            color: #555;
        }

        .links a {
            color: #4484b4;
            font-weight: 600;
            text-decoration: none;
        }

        .links a:hover {
            text-decoration: underline;
        }

        #msg-erro {
            display: none;
            background-color: #ffebee;
            color: #c62828;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 14px;
            border: 1px solid #ef9a9a;
            text-align: left;
        }
    </style>
</head>
<body>

    <div class="login-container">
        <div class="logo">HealthConnect</div>
        <h2>Acesse sua conta</h2>

        <div id="msg-erro"></div>

        <form onsubmit="fazerLogin(event)">
            <div class="input-group">
                <label for="email">E-mail</label>
                <input type="email" id="email" name="email" placeholder="seu@email.com" required>
            </div>

            <div class="input-group">
                <label for="senha">Senha</label>
                <input type="password" id="senha" name="senha" placeholder="Sua senha" required>
            </div>

            <button type="submit" id="btn-entrar">Entrar</button>
        </form>

        <div class="links">
            <p>Não tem conta? <a href="cadastro.jsp">Cadastre-se</a></p>
        </div>
    </div>

    <script>
        async function fazerLogin(event) {
            event.preventDefault();

            const email = document.getElementById("email").value;
            const senha = document.getElementById("senha").value;
            const btn = document.getElementById("btn-entrar");
            const msgErro = document.getElementById("msg-erro");

            msgErro.style.display = 'none';
            btn.disabled = true;
            btn.innerText = "Entrando...";

            try {
                const response = await fetch('login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ email: email, senha: senha })
                });

                const dados = await response.json();

                if (response.ok) {
                    window.location.href = dados.redirectUrl;
                } else {
                    msgErro.innerText = dados.erro || "Erro ao fazer login";
                    msgErro.style.display = 'block';
                    btn.disabled = false;
                    btn.innerText = "Entrar";
                }

            } catch (error) {
                msgErro.innerText = "Erro de conexão com o servidor.";
                msgErro.style.display = 'block';
                btn.disabled = false;
                btn.innerText = "Entrar";
            }
        }
    </script>

</body>
</html>
