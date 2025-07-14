package controller;

import dao.UserDAO;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // "admin" or "user"

        try {
            UserDAO userDAO = new UserDAO();

            boolean isValid = userDAO.checkLogin(email, password, role); // using plain password
            if (isValid) {
                String username = userDAO.getUsernameByEmail(email);

                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("email", email);
                session.setAttribute("role", role);

                // ✅ Debug logs:
                System.out.println("Login successful!");
                System.out.println("Email: " + email);
                System.out.println("Role: " + role);
                System.out.println("Redirecting to: " + ("admin".equals(role) ? "adminDashboard.jsp" : "dashboard.jsp"));

                // Redirect based on role
                if ("admin".equals(role)) {
                    response.sendRedirect("adminDashboard.jsp");
                } else {
                    response.sendRedirect("dashboard.jsp");
                }
            } else {
                System.out.println("Login failed for email: " + email + " with role: " + role);
                request.setAttribute("error", "Invalid email or password");
                RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
