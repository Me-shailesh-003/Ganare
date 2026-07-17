<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // Session check
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("email") == null) {
        response.sendRedirect("index.html");
        return;
    }
    String playlistName = request.getParameter("playlistName");
    String playlistIdStr = request.getParameter("playlistId");
    if (playlistIdStr == null) {
        response.sendRedirect("user_home.jsp");
        return;
    }
    if (playlistName == null) playlistName = "My Playlist";
    int playlistId = 0;
    try { playlistId = Integer.parseInt(playlistIdStr); } catch(Exception e) { response.sendRedirect("user_home.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gaanare - <%= playlistName.replace("<","&lt;").replace(">","&gt;") %></title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-bg: #09090b;
            --primary-text: #ffffff;
            --secondary-text: #a1a1aa;
            --accent-color: #8b5cf6;
            --accent-hover: #a78bfa;
            --glass-bg: rgba(255, 255, 255, 0.05);
            --glass-border: rgba(255, 255, 255, 0.1);
            --card-bg: rgba(255, 255, 255, 0.08);
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Outfit', sans-serif; background: var(--primary-bg); color: var(--primary-text); min-height: 100vh; }
        body::before {
            content: ''; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            background: radial-gradient(circle at 20% 40%, rgba(139, 92, 246, 0.4) 0%, transparent 50%),
                        radial-gradient(circle at 80% 60%, rgba(59, 130, 246, 0.3) 0%, transparent 50%);
            z-index: -1; filter: blur(80px);
        }
        .top-bar {
            display: flex; align-items: center; gap: 16px;
            padding: 20px 30px;
            background: var(--glass-bg); backdrop-filter: blur(15px);
            border-bottom: 1px solid var(--glass-border);
            position: sticky; top: 0; z-index: 100;
            flex-wrap: wrap;
        }
        .top-bar a { color: var(--accent-color); text-decoration: none; font-weight: 600; display: flex; align-items: center; gap: 8px; font-size: 14px; }
        .top-bar h1 { font-size: 20px; flex: 1; }
        .action-btns { display: flex; gap: 10px; flex-wrap: wrap; }
        .btn {
            padding: 10px 20px; border-radius: 10px; border: none;
            font-weight: 600; cursor: pointer; font-family: 'Outfit', sans-serif;
            font-size: 13px; text-decoration: none; display: inline-flex; align-items: center; gap: 6px;
            transition: all 0.3s ease;
        }
        .btn-primary { background: linear-gradient(135deg, var(--accent-color), #4f46e5); color: white; }
        .btn-danger { background: rgba(239, 68, 68, 0.2); color: #ef4444; border: 1px solid rgba(239,68,68,0.3); }
        .btn-secondary { background: var(--glass-bg); color: var(--primary-text); border: 1px solid var(--glass-border); }
        .btn:hover { transform: translateY(-2px); }
        .content { padding: 30px; max-width: 1200px; margin: 0 auto; }
        .playlist-header { display: flex; align-items: center; gap: 20px; margin-bottom: 30px; }
        .playlist-icon { width: 80px; height: 80px; background: linear-gradient(135deg, var(--accent-color), #4f46e5); border-radius: 16px; display: flex; align-items: center; justify-content: center; font-size: 32px; flex-shrink: 0; }
        .playlist-title { font-size: 32px; font-weight: 800; }
        .playlist-subtitle { color: var(--secondary-text); margin-top: 4px; }
        table { width: 100%; border-collapse: collapse; background: var(--glass-bg); backdrop-filter: blur(10px); border: 1px solid var(--glass-border); border-radius: 16px; overflow: hidden; }
        th { background: rgba(139,92,246,0.2); color: var(--primary-text); padding: 16px 20px; text-align: left; font-size: 13px; text-transform: uppercase; letter-spacing: 1px; border-bottom: 1px solid var(--glass-border); }
        td { padding: 14px 20px; border-bottom: 1px solid rgba(255,255,255,0.05); font-size: 14px; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: rgba(255,255,255,0.04); }
        audio { width: 100%; min-width: 180px; height: 36px; border-radius: 8px; }
        .empty-state { text-align: center; padding: 60px 20px; color: var(--secondary-text); }
        .empty-state i { font-size: 50px; opacity: 0.3; margin-bottom: 16px; display: block; }
        @media (max-width: 768px) {
            .top-bar { padding: 15px; }
            .content { padding: 15px; }
            .playlist-title { font-size: 24px; }
            table { display: block; overflow-x: auto; white-space: nowrap; }
            .action-btns { width: 100%; }
        }
    </style>
</head>
<body>
    <div class="top-bar">
        <a href="user_home.jsp"><i class="fas fa-arrow-left"></i> Home</a>
        <h1><i class="fas fa-list" style="color: var(--accent-color);"></i> Playlist</h1>
        <div class="action-btns">
            <form action="add_songs.jsp" method="post" style="display:inline;">
                <input type="hidden" name="playlistId" value="<%= playlistId %>">
                <input type="hidden" name="playlistName" value="<%= playlistName.replace("<","&lt;").replace(">","&gt;") %>">
                <button type="submit" class="btn btn-primary"><i class="fas fa-plus"></i> Add Song</button>
            </form>
            <form action="DeletePlaylist" method="get" style="display:inline;" onsubmit="return confirm('Delete playlist? This cannot be undone.');">
                <input type="hidden" name="playlistId" value="<%= playlistId %>">
                <button type="submit" class="btn btn-danger"><i class="fas fa-trash"></i> Delete Playlist</button>
            </form>
            <form action="User_Logout" style="display:inline;" onsubmit="return confirm('Are you sure you want to logout?');">
                <button type="submit" class="btn btn-secondary"><i class="fas fa-sign-out-alt"></i> Logout</button>
            </form>
        </div>
    </div>
    <div class="content">
        <div class="playlist-header">
            <div class="playlist-icon"><i class="fas fa-music"></i></div>
            <div>
                <div class="playlist-title"><%= playlistName.replace("<","&lt;").replace(">","&gt;") %></div>
                <div class="playlist-subtitle">Your personal playlist</div>
            </div>
        </div>

        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/gana_bajao";
                String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "shailesh";
                String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "";
                Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                String sql = "SELECT s.* FROM song s JOIN playlist_songs ps ON s.id = ps.song_id WHERE ps.playlist_id = ?";
                PreparedStatement ps = cn.prepareStatement(sql);
                ps.setInt(1, playlistId);
                ResultSet rs = ps.executeQuery();
                boolean hasSongs = false;
        %>
        <table>
            <thead>
                <tr>
                    <th>#</th><th>Song Name</th><th>Artist</th><th>Language</th><th>Year</th><th>Album</th><th>Play</th>
                </tr>
            </thead>
            <tbody>
                <% int rowNum = 0; while (rs.next()) { hasSongs = true; rowNum++;
                    String sName = rs.getString("song_name") != null ? rs.getString("song_name").replace("<","&lt;").replace(">","&gt;") : "";
                    String sArtist = rs.getString("singer_name") != null ? rs.getString("singer_name").replace("<","&lt;").replace(">","&gt;") : "";
                    String sLang = rs.getString("language") != null ? rs.getString("language") : "";
                    String sYear = rs.getString("release_year") != null ? rs.getString("release_year") : "";
                    String sAlbum = rs.getString("album_name") != null ? rs.getString("album_name").replace("<","&lt;").replace(">","&gt;") : "";
                    String sAudio = rs.getString("audio_filename") != null ? rs.getString("audio_filename") : "";
                %>
                <tr>
                    <td style="color:var(--secondary-text);"><%= rowNum %></td>
                    <td style="font-weight:600;"><%= sName %></td>
                    <td style="color:var(--secondary-text);"><%= sArtist %></td>
                    <td><%= sLang %></td>
                    <td><%= sYear %></td>
                    <td><%= sAlbum %></td>
                    <td><audio controls><source src="songs/<%= sAudio %>" type="audio/mpeg"></audio></td>
                </tr>
                <% } if (!hasSongs) { %>
                <tr><td colspan="7"><div class="empty-state"><i class="fas fa-music"></i><p>No songs in this playlist yet. Click "Add Song" to get started!</p></div></td></tr>
                <% } %>
            </tbody>
        </table>
        <% cn.close(); } catch (Exception e) { out.println("<div style='color:#ef4444;padding:20px;text-align:center;'>Error: " + e.getMessage() + "</div>"); } %>
    </div>
</body>
</html>
