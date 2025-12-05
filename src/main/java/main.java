import dao.UsuarioDAO;
import model.Usuario;

public static void main(String[] args) throws Exception {
    UsuarioDAO dao = new UsuarioDAO();

    Usuario logado = dao.login("caue@gmail.com", "123");

    if (logado != null) {
        System.out.println("Login bem-sucedido! Bem-vindo, " + logado.getNome());
    } else {
        System.out.println("Email ou senha incorretos.");
    }
}
