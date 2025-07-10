package controller;

import util.DBConnection;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import ejb.ReportBean;
import javax.ejb.EJB;

public class ReportServlet extends HttpServlet {

    @EJB
    private ReportBean reportBean;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        try {
            Connection con = DBConnection.getConnection();

            // Get user ID
            PreparedStatement psUser = con.prepareStatement("SELECT id FROM users WHERE email = ?");
            psUser.setString(1, email);
            ResultSet rsUser = psUser.executeQuery();
            int userId = -1;
            if (rsUser.next()) {
                userId = rsUser.getInt("id");
            }

            if ("create".equals(action)) {
                String title = request.getParameter("title");
                String description = request.getParameter("description");

                // ✅ Use EJB for insert
                reportBean.addReport(con, userId, title, description);

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PreparedStatement ps = con.prepareStatement("DELETE FROM reports WHERE id = ? AND user_id = ?");
                ps.setInt(1, id);
                ps.setInt(2, userId);
                ps.executeUpdate();
                ps.close();
            }

            rsUser.close();
            psUser.close();
            con.close();
            response.sendRedirect("viewReports.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String message = reportBean.sayHello();
        response.getWriter().println(message);
    }
}
