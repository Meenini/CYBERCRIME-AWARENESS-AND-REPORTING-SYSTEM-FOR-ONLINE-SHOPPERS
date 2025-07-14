package controller;

import util.DBConnection;
import dao.UserDAO;
import ejb.ReportBean;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import javax.ejb.EJB;

public class ReportServlet extends HttpServlet {

    @EJB
    private ReportBean reportBean;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String role = (String) session.getAttribute("role");

        try {
            int userId = new UserDAO().getUserIdByEmail(email);
            Connection con = DBConnection.getConnection();

            if ("create".equals(action)) {
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                String category = request.getParameter("category");
                reportBean.addReport(con, userId, title, description, category);

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PreparedStatement ps;
                if ("admin".equals(role)) {
                    ps = con.prepareStatement("DELETE FROM reports WHERE id = ?");
                    ps.setInt(1, id);
                } else {
                    ps = con.prepareStatement("DELETE FROM reports WHERE id = ? AND user_id = ?");
                    ps.setInt(1, id);
                    ps.setInt(2, userId);
                }
                ps.executeUpdate();
                ps.close();

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                String category = request.getParameter("category");

                PreparedStatement ps = con.prepareStatement(
                    "UPDATE reports SET title = ?, description = ?, category = ? WHERE id = ? AND user_id = ?");
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setString(3, category);
                ps.setInt(4, id);
                ps.setInt(5, userId);
                ps.executeUpdate();
                ps.close();
            }

            con.close();

            if ("create".equals(action)) {
                response.sendRedirect("viewReports.jsp?msg=created");
            } else if ("delete".equals(action)) {
                response.sendRedirect("viewReports.jsp?msg=deleted");
            } else if ("update".equals(action)) {
                response.sendRedirect("viewReports.jsp?msg=updated");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}