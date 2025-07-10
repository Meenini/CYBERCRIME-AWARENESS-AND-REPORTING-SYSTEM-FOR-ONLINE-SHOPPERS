<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login Page</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body style="background-image: url('pexels-tirachard-kumtanom-112571-574284.jpg');
             background-size: cover;
             background-position: center;
             background-repeat: no-repeat;">
    <div class="top-bar">
    <span class="group-name">Crime Slayers</span>
</div>
<div class="overlay">
<div class="form-box">
    <h2>Login Page</h2>
    <% if (request.getAttribute("error") != null) { %>
        <p class="error-msg"><%= request.getAttribute("error") %></p>
    <% } %>
    <form action="LoginServlet" method="post">
        Email: <input type="text" name="email" required><br>
        Password: <input type="password" name="password" required><br>
        <input type="submit" value="Login">
    </form>
    <p>Don't have an account? <a href="register.jsp">Register here</a></p>
</div>
</div>
<footer>
    <p>© 2025 Crime Slayers - Cybercrime Awareness</p>
</footer>

</body>

</html>

