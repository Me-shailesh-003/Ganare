<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.ganare.dbconnection.MyConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    // Bug 10 Fix: Session Check
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("email") == null) {
        response.sendRedirect("index.html");
        return;
    }
    // Bug 23 Fix: Store and retrieve playlistId in session
    String playlistName = request.getParameter("playlistName");
    String playlistIdParam = request.getParameter("playlistId");
    if (playlistName != null) sess.setAttribute("playlistName", playlistName);
    else playlistName = (String) sess.getAttribute("playlistName");
    if (playlistIdParam != null) sess.setAttribute("currentPlaylistId", playlistIdParam);
    else playlistIdParam = (String) sess.getAttribute("currentPlaylistId");
    if (playlistName == null) playlistName = "Unknown";
    if (playlistIdParam == null) playlistIdParam = "0";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gaanare - Add Songs to Playlist</title>
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
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--primary-bg);
            color: var(--primary-text);
            min-height: 100vh;
        }
        body::before {
            content: '';
            position: fixed;
            top: 0; left: 0; width: 100vw; height: 100vh;
            background:
                radial-gradient(circle at 20% 40%, rgba(139, 92, 246, 0.4) 0%, transparent 50%),
                radial-gradient(circle at 80% 60%, rgba(59, 130, 246, 0.3) 0%, transparent 50%);
            z-index: -1; filter: blur(80px);
        }
        .top-bar {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 20px 30px;
            background: var(--glass-bg);
            backdrop-filter: blur(15px);
            border-bottom: 1px solid var(--glass-border);
            position: sticky;
            top: 0;
            z-index: 100;
            flex-wrap: wrap;
        }
        .top-bar a {
            color: var(--accent-color);
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }
        .top-bar h1 { font-size: 20px; flex: 1; }
        .playlist-badge {
            background: linear-gradient(135deg, var(--accent-color), #4f46e5);
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        .content { padding: 30px; max-width: 1200px; margin: 0 auto; }
        .search-bar {
            margin-bottom: 20px;
            display: flex;
            gap: 12px;
        }
        .search-bar input {
            flex: 1;
            padding: 12px 20px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            color: var(--primary-text);
            font-size: 15px;
            font-family: 'Outfit', sans-serif;
        }
        .search-bar input:focus { outline: none; border-color: var(--accent-color); }
        table {
            width: 100%;
            border-collapse: collapse;
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            overflow: hidden;
        }
        th {
            background: rgba(139, 92, 246, 0.2);
            color: var(--primary-text);
            padding: 16px 20px;
            text-align: left;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 1px solid var(--glass-border);
        }
        td {
            padding: 14px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            font-size: 14px;
        }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: rgba(255,255,255,0.04); }
        .add-btn {
            background: linear-gradient(135deg, var(--accent-color), #4f46e5);
            color: white;
            padding: 8px 18px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            font-family: 'Outfit', sans-serif;
            font-size: 13px;
            transition: all 0.3s ease;
        }
        .add-btn:hover { transform: scale(1.05); }
        .add-btn.added { background: #10b981; cursor: default; }
        .add-btn:disabled { opacity: 0.7; cursor: not-allowed; }
        @media (max-width: 768px) {
            .top-bar { padding: 15px; }
            .content { padding: 15px; }
            table { display: block; overflow-x: auto; white-space: nowrap; }
            .playlist-badge { font-size: 11px; padding: 4px 10px; }
        }
    </style>
    <script>
        // Bug 46 Fix: Live search filter for songs list
        function filterSongs() {
            const searchText = document.getElementById('songSearch').value.toLowerCase();
            const rows = document.querySelectorAll('#songTable tbody tr');
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchText) ? '' : 'none';
            });
        }

        const playlistId = '<%= playlistIdParam %>';  // Bug 23 Fix

        function addSong(songId, btn) {
            btn.disabled = true;
            btn.textContent = 'Adding...';
            // Bug 23 Fix: Now sending playlistId along with songId
            fetch('AddSongPlaylist', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'songId=' + encodeURIComponent(songId) + '&playlistId=' + encodeURIComponent(playlistId)
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    btn.textContent = '\u2713 Added';
                    btn.classList.add('added');
                } else if (data.status === 'exists') {
                    btn.textContent = 'Already Added';
                    btn.classList.add('added');
                } else {
                    btn.textContent = 'Failed';
                    btn.disabled = false;
                    alert('Error: ' + (data.message || 'Could not add song'));
                }
            })
            .catch(err => {
                btn.textContent = 'Error';
                btn.disabled = false;
                console.error('Request failed:', err);
            });
        }
    </script>
</head>
<body>
    <div class="top-bar">
        <a href="user_home.jsp"><i class="fas fa-arrow-left"></i> Back to Home</a>
        <h1><i class="fas fa-plus-circle" style="color: var(--accent-color);"></i> Add Songs to Playlist</h1>
        <div class="playlist-badge"><i class="fas fa-list"></i> <%= playlistName.replace("<", "&lt;").replace(">", "&gt;") %></div>
    </div>
    <div class="content">
        <!-- Bug 46 Fix: Search/filter for songs list -->
        <div class="search-bar">
            <input type="text" id="songSearch" placeholder="&#xf002; Search songs by name, artist, album..." oninput="filterSongs()" autocomplete="off">
        </div>
        <table id="songTable">
            <thead>
                <tr>
                    <th>Song Name</th>
                    <th>Artist</th>
                    <th>Language</th>
                    <th>Year</th>
                    <th>Album</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Connection cn = MyConnection.createConnection();
                        Statement smt = cn.createStatement();
                        ResultSet rs = smt.executeQuery("SELECT id, song_name, singer_name, language, release_year, album_name FROM song ORDER BY song_name");
                        while (rs.next()) {
                            String songId = rs.getString("id");
                            String songName = rs.getString("song_name") != null ? rs.getString("song_name").replace("<", "&lt;").replace(">", "&gt;") : "";
                            String singerName = rs.getString("singer_name") != null ? rs.getString("singer_name").replace("<", "&lt;").replace(">", "&gt;") : "";
                            String lang = rs.getString("language") != null ? rs.getString("language") : "";
                            String year = rs.getString("release_year") != null ? rs.getString("release_year") : "";
                            String album = rs.getString("album_name") != null ? rs.getString("album_name").replace("<", "&lt;").replace(">", "&gt;") : "";
                %>
                <tr>
                    <td style="font-weight: 600;"><%= songName %></td>
                    <td style="color: var(--secondary-text);"><%= singerName %></td>
                    <td><%= lang %></td>
                    <td><%= year %></td>
                    <td><%= album %></td>
                    <td><button class="add-btn" onclick="addSong('<%= songId %>', this)"><i class="fas fa-plus"></i> Add</button></td>
                </tr>
                <%
                        }
                        rs.close(); smt.close(); cn.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6' style='color:#ef4444;text-align:center;padding:20px;'><i class='fas fa-exclamation-triangle'></i> DB Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
