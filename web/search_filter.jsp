<%@page import="com.ganare.dbconnection.MyConnection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gaanare - Search Results</title>
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
        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--primary-bg);
            color: var(--primary-text);
            min-height: 100vh;
            overflow-x: hidden;
        }
        body::before {
            content: '';
            position: fixed;
            top: 0; left: 0; width: 100vw; height: 100vh;
            background:
                radial-gradient(circle at 15% 50%, rgba(139, 92, 246, 0.4) 0%, transparent 50%),
                radial-gradient(circle at 85% 30%, rgba(59, 130, 246, 0.4) 0%, transparent 50%);
            z-index: -1;
            filter: blur(80px);
            animation: gradientMove 15s ease-in-out infinite alternate;
        }
        @keyframes gradientMove {
            0% { transform: scale(1) translate(0, 0); }
            50% { transform: scale(1.2) translate(5%, -5%); }
            100% { transform: scale(1) translate(-5%, 5%); }
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
        }
        .top-bar a {
            color: var(--accent-color);
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: color 0.3s;
        }
        .top-bar a:hover { color: var(--accent-hover); }
        .top-bar h1 {
            font-size: 20px;
            font-weight: 700;
            flex: 1;
        }
        .content { padding: 30px; max-width: 1200px; margin: 0 auto; }
        .search-query {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .search-query span { color: var(--accent-color); }
        .result-count {
            color: var(--secondary-text);
            margin-bottom: 30px;
            font-size: 15px;
        }
        .results-table {
            width: 100%;
            border-collapse: collapse;
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            overflow: hidden;
        }
        .results-table th {
            background: rgba(139, 92, 246, 0.2);
            color: var(--primary-text);
            padding: 16px 20px;
            text-align: left;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 1px solid var(--glass-border);
        }
        .results-table td {
            padding: 14px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            font-size: 14px;
            vertical-align: middle;
        }
        .results-table tr:last-child td { border-bottom: none; }
        .results-table tr:hover td {
            background: rgba(255, 255, 255, 0.05);
        }
        audio {
            width: 100%;
            min-width: 200px;
            height: 40px;
            border-radius: 8px;
        }
        .no-results {
            text-align: center;
            padding: 80px 20px;
            color: var(--secondary-text);
        }
        .no-results i { font-size: 60px; margin-bottom: 20px; opacity: 0.3; }
        .no-results p { font-size: 18px; }
        @media (max-width: 768px) {
            .top-bar { padding: 15px 20px; }
            .content { padding: 20px 15px; }
            .search-query { font-size: 22px; }
            .results-table { display: block; overflow-x: auto; white-space: nowrap; }
            .results-table th, .results-table td { padding: 12px 15px; }
        }
    </style>
</head>
<body>
    <div class="top-bar">
        <a href="user_home.jsp"><i class="fas fa-arrow-left"></i> Back to Home</a>
        <h1><i class="fas fa-search" style="color: var(--accent-color);"></i> Search Results</h1>
    </div>

    <%
        String searchwd = request.getParameter("search");
        String filter = request.getParameter("filter");
        if (searchwd == null) searchwd = "";
        if (filter == null) filter = "";
        int resultCount = 0;
    %>

    <div class="content">
        <div class="search-query">Results for "<span><%= searchwd %></span>"</div>
        <div class="result-count">Loading results...</div>

        <%
            try {
                Connection cn = MyConnection.createConnection();
                PreparedStatement ps;
                String query;

                if (filter.equals("")) {
                    query = "SELECT * FROM song WHERE song_name LIKE ? OR singer_name LIKE ? OR language LIKE ? OR release_year LIKE ? OR album_name LIKE ?";
                    ps = cn.prepareStatement(query);
                    String likeParam = "%" + searchwd + "%";
                    ps.setString(1, likeParam);
                    ps.setString(2, likeParam);
                    ps.setString(3, likeParam);
                    ps.setString(4, likeParam);
                    ps.setString(5, likeParam);
                } else {
                    // Whitelist filter columns to prevent injection
                    java.util.List<String> validColumns = java.util.Arrays.asList("song_name", "singer_name", "album_name", "language", "release_year");
                    if (!validColumns.contains(filter)) {
                        filter = "song_name";
                    }
                    query = "SELECT * FROM song WHERE " + filter + " LIKE ?";
                    ps = cn.prepareStatement(query);
                    ps.setString(1, "%" + searchwd + "%");
                }

                ResultSet rs = ps.executeQuery();
                boolean hasResults = false;
        %>

        <table class="results-table">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Artist</th>
                    <th>Language</th>
                    <th>Year</th>
                    <th>Album</th>
                    <th>Play</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                        hasResults = true;
                        resultCount++;
                        String songName = rs.getString("song_name");
                        String singerName = rs.getString("singer_name");
                        String lang = rs.getString("language");
                        String year = rs.getString("release_year");
                        String album = rs.getString("album_name");
                        String songFilePath = rs.getString("audio_filename");
                        // HTML-escape output to prevent XSS
                        songName = (songName != null) ? songName.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;") : "";
                        singerName = (singerName != null) ? singerName.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;") : "";
                        lang = (lang != null) ? lang.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;") : "";
                        year = (year != null) ? year.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;") : "";
                        album = (album != null) ? album.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;") : "";
                %>
                <tr>
                    <td style="font-weight: 600;"><%= songName %></td>
                    <td style="color: var(--secondary-text);"><%= singerName %></td>
                    <td><%= lang %></td>
                    <td><%= year %></td>
                    <td><%= album %></td>
                    <td>
                        <audio controls>
                            <source src="songs/<%= rs.getString("audio_filename") %>" type="audio/mpeg">
                        </audio>
                    </td>
                </tr>
                <% } %>
                <% if (!hasResults) { %>
                <tr>
                    <td colspan="6">
                        <div class="no-results">
                            <i class="fas fa-search"></i>
                            <p>No results found for "<%= searchwd %>"</p>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <script>
            // Update result count dynamically
            document.querySelector('.result-count').textContent = '<%= resultCount %> song(s) found';
        </script>

        <%
                rs.close();
                ps.close();
                cn.close();
            } catch (Exception e) {
                out.println("<div style='color: #ef4444; text-align: center; padding: 40px;'><i class='fas fa-exclamation-triangle'></i> Error: " + e.getMessage() + "</div>");
            }
        %>
    </div>
</body>
</html>
