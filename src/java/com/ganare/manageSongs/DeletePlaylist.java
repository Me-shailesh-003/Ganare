import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeletePlaylist")
public class DeletePlaylist extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String playlistId = request.getParameter("playlistId");
        String role = (String) request.getSession().getAttribute("role"); // "admin" or "user"

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/gana_bajao";
            String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "shailesh";
            String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "";
            Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            if ("admin".equals(role)) {
                // Delete songs from artist_playlist_songs
                PreparedStatement ps1 = cn.prepareStatement("DELETE FROM artist_playlist_songs WHERE playlist_id = ?");
                ps1.setInt(1, Integer.parseInt(playlistId));
                ps1.executeUpdate();

                // Delete the playlist from artist_playlists
                PreparedStatement ps2 = cn.prepareStatement("DELETE FROM artist_playlists WHERE playlist_id = ?");
                ps2.setInt(1, Integer.parseInt(playlistId));
                ps2.executeUpdate();

                ps1.close();
                ps2.close();
            } else {
                // Delete songs from user playlist
                PreparedStatement ps1 = cn.prepareStatement("DELETE FROM playlist_songs WHERE playlist_id = ?");
                ps1.setInt(1, Integer.parseInt(playlistId));
                ps1.executeUpdate();

                // Delete the playlist from user_playlists
                PreparedStatement ps2 = cn.prepareStatement("DELETE FROM user_playlists WHERE playlist_id = ?");
                ps2.setInt(1, Integer.parseInt(playlistId));
                ps2.executeUpdate();

                ps1.close();
                ps2.close();
            }

            cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        
        if ("admin".equals(role)) {
            response.sendRedirect("admin_home.jsp");
        } else {
            response.sendRedirect("user_home.jsp");
        }
    }
}
