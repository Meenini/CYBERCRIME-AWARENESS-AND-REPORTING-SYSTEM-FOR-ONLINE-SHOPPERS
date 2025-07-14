package ejb;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.ejb.Stateless;

@Stateless
public class ReportBean {
    public void addReport(Connection con, int userId, String title, String description, String category) throws SQLException {
        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO reports (user_id, title, description, category, date_reported) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)");
        ps.setInt(1, userId);
        ps.setString(2, title);
        ps.setString(3, description);
        ps.setString(4, category);
        ps.executeUpdate();
        ps.close();
    }

    public String sayHello() {
        return "Hello from EJB!";
    }
}
