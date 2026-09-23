🩺 HealthConnect

Sistema web de agendamento de consultas que conecta pacientes a profissionais de saúde. O paciente se cadastra, escolhe um profissional e marca a consulta; o profissional acompanha a agenda e pode cancelar atendimentos.

Desenvolvido para a disciplina de Integração de Aplicações e Arquitetura de Sistemas da Universidade Católica de Pelotas (UCPel).


✨ Funcionalidades

Paciente

Cadastro e login
Lista de profissionais disponíveis
Agendamento de consulta com data, hora e descrição
Visualização das próprias consultas

Profissional de saúde

Cadastro com registro profissional obrigatório (CRM, CRP etc.)
Dashboard com as consultas agendadas
Cancelamento de consultas

Ambos

Sessão autenticada com logout
Página de perfil com exclusão de conta (remove usuário e consultas vinculadas)
🛠️ Tecnologias
Camada	Stack
Backend	Java 24, Jakarta Servlet 6, JDBC
Frontend	JSP, CSS, JavaScript (Fetch API)
Banco de dados	PostgreSQL
Build / servidor	Maven, Apache Tomcat 10.1+
Bibliotecas	Lombok, org.json, Jackson
🏗️ Arquitetura

O projeto segue uma arquitetura em camadas. As páginas JSP se comunicam com os Servlets via requisições fetch trocando JSON; os Servlets validam a sessão e delegam a persistência aos DAOs.

JSP + JavaScript  ──JSON──▶  Servlets (controller)  ──▶  DAOs  ──▶  PostgreSQL
                                   │
                              DTOs / Models
src/main/java
├── connector/    # Conexão com o PostgreSQL (singleton)
├── controller/   # Servlets: login, cadastro, agendamento, cancelamento, perfil, logout
├── dao/          # Acesso a dados: Usuario, Paciente, ProfissionalSaude, Consulta
├── dto/          # Objetos de requisição/resposta
└── model/        # Entidades de domínio
src/main/webapp   # Páginas JSP, CSS e imagens
🔌 Endpoints
Método	Rota	Descrição	Autenticação
POST	/cadastro	Cria paciente ou profissional	—
POST	/login	Autentica e cria a sessão	—
GET	/logout	Encerra a sessão	Sessão
POST	/agendamento	Agenda uma consulta (apenas pacientes)	Sessão
POST	/cancelar-consulta	Cancela uma consulta	Sessão
GET / POST	/perfil	Exibe o perfil / exclui a conta	Sessão

Exemplo de agendamento:

json
POST /agendamento
{
  "profissionalId": 3,
  "dataHora": "2025-12-10T14:30",
  "descricao": "Consulta de rotina"
}
🚀 Como rodar
Pré-requisitos
JDK 24
Maven
PostgreSQL
Apache Tomcat 10.1 ou superior
1. Crie o banco
sql
CREATE DATABASE healthconnect;

CREATE TABLE usuario (
    id    SERIAL PRIMARY KEY,
    nome  VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipo  VARCHAR(20)  NOT NULL
);

CREATE TABLE paciente (
    id         SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL REFERENCES usuario(id)
);

CREATE TABLE profissional_saude (
    id         SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL REFERENCES usuario(id),
    registro   VARCHAR(50) NOT NULL
);

CREATE TABLE consulta (
    id_consulta     SERIAL PRIMARY KEY,
    paciente_id     INT NOT NULL REFERENCES paciente(id),
    profissional_id INT NOT NULL REFERENCES profissional_saude(id),
    data_hora       TIMESTAMP NOT NULL,
    descricao       TEXT,
    status          VARCHAR(20) NOT NULL DEFAULT 'AGENDADA'
);
2. Configure as variáveis de ambiente
bash
export DB_URL=jdbc:postgresql://localhost:5432/healthconnect
export DB_USER=postgres
export DB_PASSWORD=sua_senha
3. Compile e publique
bash
mvn clean package

Copie o .war gerado em target/ para a pasta webapps/ do Tomcat, inicie o servidor e acesse http://localhost:8080/<nome-do-war>/


👤 Autor

Cauê Portela · LinkedIn · GitHub
