package dao;

import connector.PostgresConnector;
import model.Usuario;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UsuarioDAO { // <--- Faltava essa linha aqui!

    public Usuario createUsuario(Usuario usuario) throws Exception {
        // SQL ajustado para retornar o ID gerado automaticamente
        String sql = "INSERT into usuario (nome, email, senha, tipo) values (?,?,?,?) RETURNING id";

        PreparedStatement stmt = PostgresConnector.getInstance().prepareStatement(sql);

        stmt.setString(1, usuario.getNome());
        stmt.setString(2, usuario.getEmail());
        stmt.setString(3, usuario.getSenha());
        stmt.setString(4, usuario.getTipo());

        // Usamos executeQuery porque o INSERT agora retorna uma "tabela" com o ID
        ResultSet rs = stmt.executeQuery();

        // Pegamos o ID retornado e colocamos no objeto
        if (rs.next()) {
            usuario.setId(rs.getLong("id"));
        }

        rs.close();
        stmt.close();

        return usuario;
    }

    public Usuario findByEmail(String email) throws Exception {
        String sql = "SELECT * FROM usuario WHERE email = ?";
        PreparedStatement stmt = PostgresConnector.getInstance().prepareStatement(sql);

        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();

        Usuario usuario = null;

        if(rs.next()) {
            usuario = new Usuario();
            usuario.setId(rs.getLong("id"));
            usuario.setNome(rs.getString("nome"));
            usuario.setEmail(rs.getString("email"));
            usuario.setSenha(rs.getString("senha"));
            usuario.setTipo(rs.getString("tipo"));
        }
        rs.close();
        stmt.close();
        return usuario;
    }


    public Usuario login(String email, String senha) throws Exception {
        if (email == null || senha == null) {
            return null;
        }

        Usuario usuario = findByEmail(email.trim());
        if (usuario == null){
            return null;
        }

        // Logs para debug no console do servidor
        System.out.println("Senha no banco: [" + usuario.getSenha() + "]");
        System.out.println("Senha recebida: [" + senha + "]");

        if (usuario.getSenha() != null && usuario.getSenha().trim().equals(senha.trim())) {
            return usuario;
        }

        return null;
    }
    public boolean deletarUsuario(long usuarioId) throws Exception {

        // 1) Deletar consultas onde o paciente pertence ao usuário
        String sql1 = "DELETE FROM consulta WHERE paciente_id IN " +
                "(SELECT id FROM paciente WHERE usuario_id = ?)";
        PreparedStatement stmt1 = PostgresConnector.getInstance().prepareStatement(sql1);
        stmt1.setLong(1, usuarioId);
        stmt1.executeUpdate();
        stmt1.close();

        // 2) Deletar consultas onde o profissional pertence ao usuário
        String sql2 = "DELETE FROM consulta WHERE profissional_id IN " +
                "(SELECT id FROM profissional_saude WHERE usuario_id = ?)";
        PreparedStatement stmt2 = PostgresConnector.getInstance().prepareStatement(sql2);
        stmt2.setLong(1, usuarioId);
        stmt2.executeUpdate();
        stmt2.close();

        // 3) Deletar paciente
        String sql3 = "DELETE FROM paciente WHERE usuario_id = ?";
        PreparedStatement stmt3 = PostgresConnector.getInstance().prepareStatement(sql3);
        stmt3.setLong(1, usuarioId);
        stmt3.executeUpdate();
        stmt3.close();

        // 4) Deletar profissional de saúde
        String sql4 = "DELETE FROM profissional_saude WHERE usuario_id = ?";
        PreparedStatement stmt4 = PostgresConnector.getInstance().prepareStatement(sql4);
        stmt4.setLong(1, usuarioId);
        stmt4.executeUpdate();
        stmt4.close();

        // 5) Finalmente deletar o usuário
        String sql5 = "DELETE FROM usuario WHERE id = ?";
        PreparedStatement stmt5 = PostgresConnector.getInstance().prepareStatement(sql5);
        stmt5.setLong(1, usuarioId);
        int linhas = stmt5.executeUpdate();
        stmt5.close();

        return linhas > 0; // true se deletou o usuário
    }



}