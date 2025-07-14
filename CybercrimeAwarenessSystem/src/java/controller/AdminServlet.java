package controller;

import util.DBConnection;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class AdminServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT r.id, u.username, r.title, r.description, r.category, r.date_reported " +
                "FROM reports r JOIN users u ON r.user_id = u.id ORDER BY r.date_reported DESC");
            ResultSet rs = ps.executeQuery();
            request.setAttribute("reportList", rs);
            RequestDispatcher rd = request.getRequestDispatcher("adminPanel.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Admin Panel Error: " + e.getMessage());
        }
    }
}