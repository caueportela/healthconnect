package controller;

import dao.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Usuario;

import java.io.IOException;

@WebServlet("/perfil")
public class PerfilServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("usuarioLogado") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");

        // Aqui estava o erro — era "usuario"
        req.setAttribute("usuarioLogado", usuarioLogado);

        req.getRequestDispatcher("perfil.jsp").forward(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Usuario user = (Usuario) session.getAttribute("usuarioLogado");

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try {
            UsuarioDAO dao = new UsuarioDAO();
            boolean deletou = dao.deletarUsuario(user.getId());

            if (deletou) {
                session.invalidate(); // derruba login
                resp.sendRedirect("login.jsp?msg=contaDeletada");
            } else {
                resp.sendRedirect("perfil.jsp?erro=naoDeletou");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("perfil.jsp?erro=exception");
        }
    }
}
