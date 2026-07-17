<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // Session check for user
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("email") == null) {
        response.sendRedirect("index.html");
        return;
    }
    
    // The parameter passed from user_home.jsp for artist name is 'playlistName'
    String artistName = request.getParameter("playlistName");
    String artistImage = request.getParameter("artistImage");
    
    // Validate artistImage (no path traversal, only filename allowed)
    if (artistImage != null && (artistImage.contains("/") || artistImage.contains("\\"))) {
        artistImage = "default.png"; // Fallback if attempted traversal
    }
    
    if (artistName == null) artistName = "Artist";
    if (artistImage == null) artistImage = "default.png";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gaanare - Artist: <%= artistName.replace("<","&lt;").replace(">","&gt;") %></title>
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
            padding: 20px 30px; background: var(--glass-bg); backdrop-filter: blur(15px);
            border-bottom: 1px solid var(--glass-border);
            position: sticky; top: 0; z-index: 100; flex-wrap: wrap;
        }
        .top-bar a { color: var(--accent-color); text-decoration: none; font-weight: 600; display: flex; align-items: center; gap: 8px; font-size: 14px; }
        .top-bar h1 { font-size: 20px; flex: 1; }
        .content { padding: 30px; max-width: 1200px; margin: 0 auto; }
        .playlist-header { display: flex; align-items: center; gap: 20px; margin-bottom: 30px; }
        .artist-img { width: 100px; height: 100px; border-radius: 50%; object-fit: cover; border: 3px solid var(--accent-color); }
        .playlist-title { font-size: 32px; font-weight: 800; }
        .playlist-subtitle { color: var(--secondary-text); margin-top: 4px; display: inline-block; padding: 4px 12px; background: rgba(139,92,246,0.2); border-radius: 20px; font-size: 12px; font-weight: 600; color: var(--accent-color); }
        table { width: 100%; border-collapse: collapse; background: var(--glass-bg); backdrop-filter: blur(10px); border: 1px solid var(--glass-border); border-radius: 16px; overflow: hidden; }
        th { background: rgba(139,92,246,0.2); color: var(--primary-text); padding: 16px 20px; text-align: left; font-size: 13px; text-transform: uppercase; letter-spacing: 1px; border-bottom: 1px solid var(--glass-border); }
        td { padding: 14px 20px; border-bottom: 1px solid rgba(255,255,255,0.05); font-size: 14px; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: rgba(255,255,255,0.04); }
        audio { width: 100%; min-width: 180px; height: 36px; border-radius: 8px; }
        @media (max-width: 768px) {
            .top-bar { padding: 15px; } .content { padding: 15px; } .playlist-title { font-size: 24px; }
            table { display: block; overflow-x: auto; white-space: nowrap; }
        }
    </style>
</head>
<body>
    <div class="top-bar">
        <a href="user_home.jsp"><i class="fas fa-arrow-left"></i> Home</a>
        <h1><i class="fas fa-music" style="color: var(--accent-color);"></i> Artist Songs</h1>
    </div>
    <div class="content">
        <div class="playlist-header">
            <!-- Fixed the image path to use the same directory as user_home.jsp for artist images -->
            <img src="images/Songs_image/Artist_Images/<%= artistImage.replace("\"", "&quot;") %>" class="artist-img" alt="<%= artistName.replace("\"", "&quot;") %>" onerror="this.src='images/web_images/logoGanare.png'">
            <div>
                <div class="playlist-title"><%= artistName.replace("<","&lt;").replace(">","&gt;") %></div>
                <div class="playlist-subtitle">Artist Playlist</div>
            </div>
        </div>

        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/gana_bajao";
                String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "shailesh";
                String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "";
                Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                
                String sql = "SELECT * FROM song WHERE singer_name = ?";
                PreparedStatement ps = cn.prepareStatement(sql);
                ps.setString(1, artistName);
                ResultSet rs = ps.executeQuery();
                boolean hasSongs = false;
        %>
        <table>
            <thead>
                <tr>
                    <th>#</th><th>Song Name</th><th>Language</th><th>Year</th><th>Album</th><th>Play</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    int rowNum = 0;
                    while (rs.next()) { 
                    hasSongs = true; 
                    rowNum++;
                    String sName = rs.getString("song_name") != null ? rs.getString("song_name").replace("<","&lt;").replace(">","&gt;") : "";
                    String sLang = rs.getString("language") != null ? rs.getString("language") : "";
                    String sYear = rs.getString("release_year") != null ? rs.getString("release_year") : "";
                    String sAlbum = rs.getString("album_name") != null ? rs.getString("album_name").replace("<","&lt;").replace(">","&gt;") : "";
                    String sAudio = rs.getString("audio_filename") != null ? rs.getString("audio_filename") : "";
                %>
                <tr>
                    <td style="color:var(--secondary-text);"><%= rowNum %></td>
                    <td style="font-weight:600;"><%= sName %></td>
                    <td><%= sLang %></td>
                    <td><%= sYear %></td>
                    <td><%= sAlbum %></td>
                    <td><audio controls><source src="songs/<%= sAudio %>" type="audio/mpeg"></audio></td>
                </tr>
                <% } if (!hasSongs) { %>
                <tr><td colspan="6" style="text-align:center;padding:40px;color:var(--secondary-text);">No songs found for this artist.</td></tr>
                <% } %>
            </tbody>
        </table>
        <% cn.close(); } catch (Exception e) { out.println("<div style='color:#ef4444;padding:20px;'>Error: " + e.getMessage() + "</div>"); } %>
    </div>
</body>
</html>
