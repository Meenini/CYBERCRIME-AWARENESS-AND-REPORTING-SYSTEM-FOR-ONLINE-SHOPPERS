<%@ page import="java.sql.*, util.DBConnection" %>
<%@ page session="true" %>
<%
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement psUser = null;
    ResultSet rsUser = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<html>
    
<head>
    <title>Your Reports</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
    

    <!-- Top Bar -->
    <div class="navbar">
    <div class="nav-brand">Crime Slayers</div>
    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="dashboard.jsp#awareness">Awareness</a>
        <a href="viewReports.jsp">View Reports</a>
        <a href="logout.jsp" class="logout-btn">Logout</a>
    </div>
    </div>


    <!-- Main Content -->
    <div class="center-box">
        <h2>Your Scam/Fraud Reports</h2>

        <div class="form-box">
        <form action="ReportServlet" method="post">
            <input type="hidden" name="action" value="create">
            <label for="title">Title:</label><br>
            <input type="text" name="title" required><br>

            <label for="description">Description:</label><br>
            <textarea name="description" rows="5" cols="40" required></textarea><br>

            <input type="submit" value="Submit Report">
        </form>
        </div>
        <hr>

        <!-- User Report List -->
        <%
            try {
                con = DBConnection.getConnection();

                // Get user ID
                psUser = con.prepareStatement("SELECT id FROM users WHERE email = ?");
                psUser.setString(1, email);
                rsUser = psUser.executeQuery();

                int userId = -1;
                if (rsUser.next()) {
                    userId = rsUser.getInt("id");
                }

                ps = con.prepareStatement("SELECT * FROM reports WHERE user_id = ? ORDER BY date_reported DESC");
                ps.setInt(1, userId);
                rs = ps.executeQuery();

                while (rs.next()) {
        %>
                    <div class="report-card">
                        <strong>Title:</strong> <%= rs.getString("title") %><br>
                        <strong>Description:</strong> <%= rs.getString("description") %><br>
                        <strong>Date:</strong> <%= rs.getTimestamp("date_reported") %><br>

                        <form action="ReportServlet" method="post" style="margin-top:10px;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                            <input type="submit" value="Delete">
                        </form>
                    </div>
        <%
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (con != null) con.close(); } catch (Exception e) {}
            }
        %>

        <br>
        <a href="dashboard.jsp">Back to Dashboard</a>
    </div>
    <footer>
    <p>© 2025 Crime Slayers - Cybercrime Awareness</p>
    </footer>
</body>
</html>
