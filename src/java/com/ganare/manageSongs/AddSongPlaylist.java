package com.ganare.manageSongs;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AddSongPlaylist")
public class AddSongPlaylist extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        String playlistName = (String) session.getAttribute("playlistName");
        String songIdStr = request.getParameter("songId");
        String role = (String) session.getAttribute("role"); 

        if (playlistName == null || songIdStr == null || role == null) {
            out.println("{\"status\":\"error\",\"message\":\"Missing session data\"}");
            return;
        }

        try {
            int songId = Integer.parseInt(songIdStr);
            int playlistId = -1;
            String insertTable = "";

            Class.forName("com.mysql.cj.jdbc.Driver");
            String dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/gana_bajao";
            String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "shailesh";
            String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "";
            Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            if (role.equals("admin")) {
                String adminId = (String) session.getAttribute("adminId");

                PreparedStatement playlistStmt = cn.prepareStatement("SELECT playlist_id FROM artist_playlists WHERE admin_id = ? AND name = ?");
                playlistStmt.setString(1, adminId);
                playlistStmt.setString(2, playlistName);
                ResultSet rs = playlistStmt.executeQuery();
                if (rs.next()) {
                    playlistId = rs.getInt("playlist_id");
                    insertTable = "artist_playlist_songs";
                }
            } else {
                String userId = (String) session.getAttribute("userId");
                PreparedStatement playlistStmt = cn.prepareStatement("SELECT playlist_id FROM user_playlists WHERE id = ? AND name = ?");
                playlistStmt.setString(1, userId);
                playlistStmt.setString(2, playlistName);
                ResultSet rs = playlistStmt.executeQuery();
                if (rs.next()) {
                    playlistId = rs.getInt("playlist_id");
                    insertTable = "playlist_songs";
                }
            }

            if (playlistId == -1 || insertTable.equals("")) {
                out.println("{\"status\":\"error\",\"message\":\"Playlist not found.\"}");
                return;
            }

            // Check if song already added
            PreparedStatement checkStmt = cn.prepareStatement("SELECT * FROM " + insertTable + " WHERE playlist_id = ? AND song_id = ?");
            checkStmt.setInt(1, playlistId);
            checkStmt.setInt(2, songId);
            ResultSet checkRs = checkStmt.executeQuery();

            if (checkRs.next()) {
                out.println("{\"status\":\"exists\",\"message\":\"Song already in playlist.\"}");
            } else {
                PreparedStatement insertStmt = cn.prepareStatement("INSERT INTO " + insertTable + " (playlist_id, song_id) VALUES (?, ?)");
                insertStmt.setInt(1, playlistId);
                insertStmt.setInt(2, songId);
                insertStmt.executeUpdate();
                out.println("{\"status\":\"success\",\"message\":\"Song added to playlist.\"}");
            }

            cn.close();
        } catch (Exception e) {
            out.println("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        }
    }
}
