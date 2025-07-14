<%@ page import="java.sql.*, util.DBConnection" %>
<%@ page session="true" %>
<%
    String email = (String) session.getAttribute("email");
    String role = (String) session.getAttribute("role");

    if (email == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="no-bg">
    <div class="navbar">
        <div class="nav-brand">Crime Slayers - Admin</div>
        <div class="nav-links">
            <a href="adminDashboard.jsp">Dashboard</a>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </div>
    </div>

    <div class="center-box">
        <h2>All User Reports</h2>
<%
    try {
        con = DBConnection.getConnection();
        ps = con.prepareStatement("SELECT r.title, r.description, r.category, r.date_reported, u.username FROM reports r JOIN users u ON r.user_id = u.id ORDER BY r.date_reported DESC");
        rs = ps.executeQuery();

        while (rs.next()) {
%>
            <div class="report-card">
                <strong>User:</strong> <%= rs.getString("username") %><br>
                <strong>Title:</strong> <%= rs.getString("title") %><br>
                <strong>Description:</strong> <%= rs.getString("description") %><br>
                <strong>Category:</strong> <%= rs.getString("category") %><br>
                <strong>Date:</strong> <%= rs.getTimestamp("date_reported") %><br>
            </div>
<%
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
    </div>

    <footer>
        <p>© 2025 Crime Slayers - Admin Dashboard</p>
    </footer>
</body>
</html>