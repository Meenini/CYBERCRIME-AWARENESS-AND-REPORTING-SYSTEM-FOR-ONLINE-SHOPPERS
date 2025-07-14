<%@ page import="java.sql.*, util.DBConnection" %>
<%@ page session="true" %>
<%
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String reportIdParam = request.getParameter("id");
    int reportId = -1;
    String title = "", description = "", category = "";
    boolean isValidReport = false;

    // Validate the id parameter
    if (reportIdParam == null || reportIdParam.trim().isEmpty()) {
        response.sendRedirect("viewReports.jsp?msg=error&reason=Invalid+report+ID");
        return;
    }

    try {
        reportId = Integer.parseInt(reportIdParam);
    } catch (NumberFormatException e) {
        response.sendRedirect("viewReports.jsp?msg=error&reason=Invalid+report+ID+format");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();
        // Ensure the report belongs to the user
        ps = con.prepareStatement(
            "SELECT r.title, r.description, r.category FROM reports r JOIN users u ON r.user_id = u.id WHERE r.id = ? AND u.email = ?"
        );
        ps.setInt(1, reportId);
        ps.setString(2, email);
        rs = ps.executeQuery();

        if (rs.next()) {
            isValidReport = true;
            title = rs.getString("title");
            description = rs.getString("description");
            category = rs.getString("category");
        } else {
            response.sendRedirect("viewReports.jsp?msg=error&reason=Report+not+found+or+not+authorized");
            return;
        }
    } catch (Exception e) {
        response.sendRedirect("viewReports.jsp?msg=error&reason=Database+error");
        return;
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
        try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
        try { if (con != null) con.close(); } catch (SQLException ignored) {}
    }
%>

<html>
<head>
    <title>Edit Report</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body class="no-bg">
    <div class="center-box">
        <h2>Edit Your Report</h2>
        <% if (isValidReport) { %>
            <form action="ReportServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= reportId %>">

                <label for="title">Title:</label><br>
                <input type="text" id="title" name="title" value="<%= title != null ? title : "" %>" required><br>

                <label for="description">Description:</label><br>
                <textarea id="description" name="description" rows="5" cols="40" required><%= description != null ? description : "" %></textarea><br>

                <label for="category">Category:</label><br>
                <select id="category" name="category" required>
                    <option value="">-- Select Scam Type --</option>
                    <option value="Phishing" <%= "Phishing".equals(category) ? "selected" : "" %>>Phishing</option>
                    <option value="Fake Seller" <%= "Fake Seller".equals(category) ? "selected" : "" %>>Fake Seller</option>
                    <option value="Payment Scam" <%= "Payment Scam".equals(category) ? "selected" : "" %>>Payment Scam</option>
                    <option value="Data Breach" <%= "Data Breach".equals(category) ? "selected" : "" %>>Data Breach</option>
                    <option value="Other" <%= "Other".equals(category) ? "selected" : "" %>>Other</option>
                </select><br><br>

                <input type="submit" value="Update Report">
            </form>
        <% } else { %>
            <p style="color:red;">Error: Unable to load report. Please try again.</p>
        <% } %>
        <br><a href="viewReports.jsp">Cancel / Back</a>
    </div>
        
     <footer>
    <p>© 2025 Crime Slayers - Cybercrime Awareness</p>
</footer>
        
</body>
</html>