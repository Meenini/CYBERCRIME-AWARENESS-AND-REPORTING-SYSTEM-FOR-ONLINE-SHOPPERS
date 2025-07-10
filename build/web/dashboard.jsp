<%@ page import="java.sql.*, util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
    /* ----------------------------------------------------------
       ⬇️  BASIC USER / REPORT DATA (same logic as before)
    ---------------------------------------------------------- */
    String username = (String) session.getAttribute("username");
    String email    = (String) session.getAttribute("email");

    if (username == null || email == null) {   // Not logged‑in
        response.sendRedirect("login.jsp");
        return;
    }

    int reportCount = 0;
    String lastReported = "-";

    Connection con = null;
    PreparedStatement psUser = null, psCnt = null, psDate = null;
    ResultSet rsUser = null, rsCnt = null, rsDate = null;

    try {
        con = DBConnection.getConnection();

        psUser = con.prepareStatement("SELECT id FROM users WHERE email = ?");
        psUser.setString(1, email);
        rsUser = psUser.executeQuery();
        int userId = rsUser.next() ? rsUser.getInt("id") : -1;

        psCnt = con.prepareStatement("SELECT COUNT(*) FROM reports WHERE user_id = ?");
        psCnt.setInt(1, userId);
        rsCnt = psCnt.executeQuery();
        if (rsCnt.next()) reportCount = rsCnt.getInt(1);

        psDate = con.prepareStatement("SELECT MAX(date_reported) FROM reports WHERE user_id = ?");
        psDate.setInt(1, userId);
        rsDate = psDate.executeQuery();
        if (rsDate.next() && rsDate.getTimestamp(1) != null)
            lastReported = rsDate.getTimestamp(1).toString();

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rsDate != null) rsDate.close();
        if (rsCnt  != null) rsCnt.close();
        if (rsUser != null) rsUser.close();
        if (psDate != null) psDate.close();
        if (psCnt  != null) psCnt.close();
        if (psUser != null) psUser.close();
        if (con    != null) con.close();
    }

    /* Dummy awarenessTipsCount – replace with real query if desired */
    int awarenessTipsCount = 5;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>

<!-- ░░ TOP NAVBAR ░░ -->
<div class="navbar">
    <div class="nav-brand">Crime Slayers</div>
    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="#awareness">Awareness</a>
        <a href="viewReports.jsp">View Reports</a>
        <a href="logout.jsp" class="logout-btn">Logout</a>
    </div>
</div>

<div class="center-box">
    
    <h2>Welcome, <%= username %>!</h2>
    
    <p><strong>Total Reports:</strong> <%= reportCount %></p>
    <p><strong>Last Report Submitted:</strong> <%= lastReported %></p>                
    
    <!-- ░░ QUICK LINK ░░ -->
    <div class="center-link">
        <a href="viewReports.jsp" class="action-link">View / Manage Reports</a>
    </div>

    <hr>

    <!-- ░░ CYBERCRIME AWARENESS ░░ -->
    <h3 id="awareness">&#128274; Cybercrime Awareness</h3>
    
    <!-- ░░ MAIN CARD WRAPPER ░░ -->


    

    <!-- ███  INFOGRAPHIC CARDS  ███ -->
    <div class="card-row">
        <div class="flip-card info-blue" onclick="flip(this)">
            <div class="flip-card-inner">
                <!-- front -->
                <div class="flip-card-face flip-card-front">
                    <img src="phishing.png" alt="phishing">
                </div>
                <!-- back -->
                <div class="flip-card-face flip-card-back">
                    <p class="card-title">Phishing</p>
                    <p class="back-small">Deceptive emails, messages, or websites tricking users into revealing sensitive information like passwords or credit card details</p>
                </div>
            </div>
        </div>
    

        <!-- 🟢 LAST REPORT CARD -->
        <div class="flip-card info-green" onclick="flip(this)">
            <div class="flip-card-inner">
                <div class="flip-card-face flip-card-front">
                    <img src="cyberbully1.jpg" alt="cyberbully">
                </div>
                <div class="flip-card-face flip-card-back">
                    <p class="card-title">Cyberbully</p>
                    <p class="back-small">Online harassment, including insults, threats, and spreading rumors. </p>
                </div>
            </div>
        </div>

    <!-- 🟠 AWARENESS TIPS CARD -->
        <div class="flip-card info-orange" onclick="flip(this)">
            <div class="flip-card-inner">
                <div class="flip-card-face flip-card-front">
                    <img src="darkweb1.jpg" alt="darkweb">
                </div>
                <div class="flip-card-face flip-card-back">
                    <p class="card-title">Darkweb</p>
                    <p class="back-small">A hidden part of the internet that is not indexed by standard search engines. The dark web is notorious for hosting illegal marketplaces for drugs, weapons, and stolen data. </p>
                </div>
            </div>
        </div>
    </div>
    
    
    <div class="awareness-box">
        <p>
            Online shopping scams are one of the most common forms of cybercrime. 
            Fraudsters may pose as trusted sellers, create fake websites, or send
            phishing emails to trick users into sharing personal or payment information.
        </p>
        <ul>
            <li>Always verify the legitimacy of online sellers and platforms.</li>
            <li>Use secure payment methods like credit cards or trusted gateways.</li>
            <li>Never click on suspicious links or attachments from unknown sources.</li>
            <li>Regularly check for data breaches involving your accounts.</li>
            <li>Report any fraud attempts immediately using the report form.</li>
        </ul>
        <p>
            For more information and the latest cybercrime alerts, visit&nbsp;
            <a href="https://www.mycert.org.my/" target="_blank">
                CyberSecurity&nbsp;Malaysia
            </a>.
        </p>
    </div>

</div><!-- /.center-box -->
<script>
/* toggle "flipped" class on click */
function flip(card){
    card.classList.toggle('flipped');
}
</script>
 <footer>
    <p>© 2025 Crime Slayers - Cybercrime Awareness</p>
</footer
</body>
</html>
