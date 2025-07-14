package dao;

import util.DBConnection;
import java.sql.*;

public class UserDAO {

    // Get user ID by email
    public int getUserIdByEmail(String email) throws Exception {
        int userId = -1;
        Connection con = DBConnection.getConnection();
        String sql = "SELECT id FROM users WHERE email = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            userId = rs.getInt("id");
        }

        rs.close();
        ps.close();
        con.close();

        return userId;
    }

    // Get username by email
    public String getUsernameByEmail(String email) throws Exception {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT username FROM users WHERE email = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        String username = rs.next() ? rs.getString("username") : "";
        rs.close();
        ps.close();
        con.close();
        return username;
    }

    // Get role by email
    public String getRoleByEmail(String email) throws Exception {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT role FROM users WHERE email = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        String role = rs.next() ? rs.getString("role") : "user";
        rs.close();
        ps.close();
        con.close();
        return role;
    }

    // Check login credentials without hashing
    public boolean checkLogin(String email, String password, String role) throws Exception {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM users WHERE email = ? AND password = ? AND role = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, email);
        ps.setString(2, password);  // Plain-text password
        ps.setString(3, role);
        ResultSet rs = ps.executeQuery();
        boolean isValid = rs.next();
        rs.close();
        ps.close();
        con.close();
        return isValid;
    }

    // Optional: Get role after verifying email/password (used in login check)
    public String checkLoginAndGetRole(String email, String password) throws Exception {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT role FROM users WHERE email = ? AND password = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, email);
        ps.setString(2, password);  // Plain-text
        ResultSet rs = ps.executeQuery();

        String role = null;
        if (rs.next()) {
            role = rs.getString("role");
        }

        rs.close();
        ps.close();
        con.close();
        return role;
    }
}
