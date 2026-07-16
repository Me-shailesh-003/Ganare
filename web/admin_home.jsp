<%@page import="com.ganare.dbconnection.MyConnection"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gaanare - Admin Panel</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            :root {
                --primary-bg: #121212;
                --secondary-bg: #181818;
                --card-bg: #282828;
                --hover-bg: #3e3e3e;
                --primary-text: #ffffff;
                --secondary-text: #b3b3b3;
                --accent-color: #1db954;
                --accent-hover: #1ed760;
                --border-color: #333;
                --danger-color: #f44336;
                --warning-color: #ff9800;
                --success-color: #4caf50;
                --shadow: 0 8px 24px rgba(0, 0, 0, 0.5);
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background: linear-gradient(180deg, var(--primary-bg) 0%, #0a0a0a 100%);
                color: var(--primary-text);
                line-height: 1.6;
                overflow-x: hidden;
            }

            /* Sidebar Navigation */
            .sidebar {
                position: fixed;
                left: 0;
                top: 0;
                width: 260px;
                height: 100vh;
                background: var(--primary-bg);
                padding: 24px;
                z-index: 100;
                border-right: 1px solid var(--border-color);
                overflow-y: auto;
            }

            .sidebar::-webkit-scrollbar {
                width: 8px;
            }

            .sidebar::-webkit-scrollbar-track {
                background: var(--secondary-bg);
            }

            .sidebar::-webkit-scrollbar-thumb {
                background: var(--hover-bg);
                border-radius: 4px;
            }

            .logo-container {
                text-align: center;
                margin-bottom: 32px;
                padding-bottom: 24px;
                border-bottom: 1px solid var(--border-color);
            }

            .logo-container img {
                width: 120px;
                margin-bottom: 12px;
            }

            .logo-tagline {
                font-size: 11px;
                color: var(--secondary-text);
                font-weight: 500;
            }

            .tablinks {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 16px;
                color: var(--secondary-text);
                text-decoration: none;
                border-radius: 8px;
                transition: all 0.3s ease;
                font-weight: 500;
                font-size: 14px;
                margin-bottom: 4px;
                cursor: pointer;
                border: none;
                background: transparent;
                width: 100%;
                text-align: left;
            }

            .tablinks:hover,
            .tablinks.active {
                background: var(--card-bg);
                color: var(--primary-text);
            }

            .tablinks i {
                width: 20px;
                font-size: 16px;
            }

            .logout-button {
                position: absolute;
                bottom: 24px;
                left: 24px;
                right: 24px;
            }

            .logout-button form {
                width: 100%;
            }

            .logout-button input[type="submit"] {
                width: 100%;
                padding: 12px;
                background: transparent;
                border: 1px solid var(--danger-color);
                border-radius: 8px;
                color: var(--danger-color);
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                font-size: 14px;
            }

            .logout-button input[type="submit"]:hover {
                background: var(--danger-color);
                color: var(--primary-text);
            }

            /* Main Content */
            .main-content {
                margin-left: 260px;
                padding: 32px;
                min-height: 100vh;
            }

            .tabcontent {
                display: none;
                animation: fadeIn 0.5s;
            }

            .tabcontent.active {
                display: block;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Welcome Section */
            .welcome-container {
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 80vh;
                text-align: center;
            }

            .welcome-container h1 {
                font-size: 42px;
                font-weight: 700;
                background: linear-gradient(135deg, var(--accent-color), #1ed760);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                line-height: 1.4;
            }

            /* Forms */
            .container {
                max-width: 800px;
                margin: 0 auto;
                background: var(--card-bg);
                padding: 40px;
                border-radius: 16px;
                box-shadow: var(--shadow);
            }

            .container h2 {
                font-size: 28px;
                margin-bottom: 32px;
                text-align: center;
                color: var(--primary-text);
            }

            .container form {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .container label {
                font-size: 14px;
                font-weight: 600;
                color: var(--primary-text);
                margin-bottom: 8px;
            }

            .container input[type="text"],
            .container input[type="number"],
            .container input[type="file"],
            .container select {
                padding: 12px 16px;
                background: var(--secondary-bg);
                border: 1px solid var(--border-color);
                border-radius: 8px;
                color: var(--primary-text);
                font-size: 14px;
                transition: all 0.3s ease;
                font-family: 'Inter', sans-serif;
            }

            .container input:focus,
            .container select:focus {
                outline: none;
                border-color: var(--accent-color);
                background: var(--hover-bg);
            }

            .container select {
                cursor: pointer;
            }

            .container button[type="submit"] {
                padding: 14px 28px;
                background: linear-gradient(135deg, var(--accent-color), #1ed760);
                border: none;
                border-radius: 8px;
                color: var(--primary-text);
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                font-size: 15px;
                margin-top: 16px;
            }

            .container button[type="submit"]:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 24px rgba(29, 185, 84, 0.4);
            }

            /* Tables */
            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                background: var(--card-bg);
                border-radius: 12px;
                overflow: hidden;
                box-shadow: var(--shadow);
                margin-top: 24px;
            }

            caption {
                padding: 24px;
                background: var(--secondary-bg);
                border-bottom: 1px solid var(--border-color);
            }

            caption h2 {
                font-size: 24px;
                color: var(--primary-text);
                font-weight: 700;
            }

            table th {
                background: var(--secondary-bg);
                padding: 16px;
                text-align: left;
                font-weight: 600;
                font-size: 13px;
                color: var(--primary-text);
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            table td {
                padding: 16px;
                border-bottom: 1px solid var(--border-color);
                color: var(--secondary-text);
                font-size: 14px;
            }

            table tr:last-child td {
                border-bottom: none;
            }

            table tr:hover {
                background: var(--hover-bg);
            }

            table a {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 32px;
                height: 32px;
                background: var(--secondary-bg);
                border-radius: 6px;
                transition: all 0.3s ease;
            }

            table a:hover {
                background: var(--accent-color);
                transform: scale(1.1);
            }

            table a img {
                filter: brightness(0) invert(1);
            }

            /* Table Wrapper */
            .table-wrapper {
                overflow-x: auto;
                margin-top: 24px;
            }

            /* Stats Cards */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 24px;
                margin-bottom: 32px;
            }

            .stat-card {
                background: var(--card-bg);
                padding: 24px;
                border-radius: 12px;
                border: 1px solid var(--border-color);
                transition: all 0.3s ease;
            }

            .stat-card:hover {
                transform: translateY(-4px);
                box-shadow: var(--shadow);
            }

            .stat-card h3 {
                font-size: 14px;
                color: var(--secondary-text);
                margin-bottom: 8px;
                font-weight: 500;
            }

            .stat-card .stat-value {
                font-size: 32px;
                font-weight: 700;
                color: var(--primary-text);
            }

            /* Page Header */
            .page-header {
                margin-bottom: 32px;
            }

            .page-header h1 {
                font-size: 32px;
                font-weight: 700;
                margin-bottom: 8px;
            }

            .page-header p {
                color: var(--secondary-text);
                font-size: 14px;
            }

            /* Responsive */
            @media (max-width: 1024px) {
                .sidebar {
                    width: 80px;
                    padding: 16px;
                }

                .logo-container img {
                    width: 48px;
                }

                .logo-tagline,
                .tablinks span {
                    display: none;
                }

                .main-content {
                    margin-left: 80px;
                }

                .logout-button {
                    left: 16px;
                    right: 16px;
                }
            }

            @media (max-width: 768px) {
                .sidebar {
                    display: none;
                }

                .main-content {
                    margin-left: 0;
                    padding: 16px;
                }

                .container {
                    padding: 24px;
                }

                table {
                    font-size: 12px;
                }

                table th,
                table td {
                    padding: 12px 8px;
                }
            }

            /* Mobile Menu Toggle */
            .mobile-menu-toggle {
                display: none;
                position: fixed;
                top: 16px;
                left: 16px;
                z-index: 101;
                width: 40px;
                height: 40px;
                background: var(--card-bg);
                border: 1px solid var(--border-color);
                border-radius: 8px;
                color: var(--primary-text);
                font-size: 20px;
                cursor: pointer;
            }

            @media (max-width: 768px) {
                .mobile-menu-toggle {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .sidebar.mobile-active {
                    display: block;
                    width: 260px;
                }
            }
        </style>
    </head>
    <body>

        <%
            try {
                session = request.getSession(false);
                String name = (String) session.getAttribute("name");
                String email = (String) session.getAttribute("email");

                if (email != null) {
                    System.out.println("Welcome to Home");
                } else {
                    RequestDispatcher rd = request.getRequestDispatcher("admin_login.html");
                    rd.include(request, response);
                    out.println("<script>loginFirst();</script>");
                }
            } catch (Exception e) {
                RequestDispatcher rd = request.getRequestDispatcher("admin_login.html");
                rd.include(request, response);
                out.println("<script>loginFirst();</script>");
            }
        %>

        <!-- Mobile Menu Toggle -->
        <button class="mobile-menu-toggle" onclick="toggleMobileMenu()">
            <i class="fas fa-bars"></i>
        </button>

        <!-- Sidebar Navigation -->
        <div class="sidebar" id="sidebar">
            <div class="logo-container">
                <img src="images/web_images/logoGanare.png" alt="Gaanare Logo">
                <p class="logo-tagline">Where Melodies Reflect The Soul</p>
            </div>

            <a class="tablinks" onclick="openFunc(event, 'welcome')" id="defaultOpen">
                <i class="fas fa-home"></i>
                <span>Dashboard</span>
            </a>
            <a class="tablinks" onclick="openFunc(event, 'addSongs')">
                <i class="fas fa-plus-circle"></i>
                <span>Add New Songs</span>
            </a>
            <a class="tablinks" onclick="openFunc(event, 'viewSongs')">
                <i class="fas fa-list"></i>
                <span>View Songs</span>
            </a>
            <a class="tablinks" onclick="openFunc(event, 'editSongs')">
                <i class="fas fa-edit"></i>
                <span>Edit Songs</span>
            </a>
            <a class="tablinks" onclick="openFunc(event, 'deleteSongs')">
                <i class="fas fa-trash-alt"></i>
                <span>Delete Songs</span>
            </a>
            <a class="tablinks" onclick="openFunc(event, 'addPlaylists')">
                <i class="fas fa-folder-plus"></i>
                <span>Add Artist Playlist</span>
            </a>
            <a class="tablinks" onclick="openFunc(event, 'deleteArtistPlaylist')">
                <i class="fas fa-folder-minus"></i>
                <span>Delete Artist Playlist</span>
            </a>
            <a class="tablinks" onclick="openFunc(event, 'editArtistPlaylist')">
                <i class="fas fa-music"></i>
                <span>Add Song To Playlist</span>
            </a>
            <a class="tablinks" onclick="openFunc(event, 'userInfo')">
                <i class="fas fa-cog"></i>
                <span>Manage User</span>
            </a>

            <div class="logout-button">
                <form action="Admin_Logout" onsubmit="return confirm('Are you sure you want to logout?');">
                    <input type="submit" value="Logout">
                </form>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Welcome Tab -->
            <div id="welcome" class="tabcontent">
                <div class="welcome-container">
                    <h1>We're glad to have you on the admin page.<br>Manage your tasks and settings with ease.</h1>
                </div>
            </div>

            <!-- Add Songs Tab -->
            <div id="addSongs" class="tabcontent">
                <div class="page-header">
                    <h1>Add New Song</h1>
                    <p>Upload and manage music content to your platform</p>
                </div>

                <div class="container">
                    <h2>Song Details</h2>
                    <form action="UpdateSongInfo" method="post">
                        <label for="songName">Song Name</label>
                        <input type="text" id="songName" name="songName" placeholder="Enter song name" required>

                        <label for="singerName">Singer Name</label>
                        <input type="text" id="singerName" name="singerName" placeholder="Enter singer name" required>

                        <label for="lang-select">Select Language</label>
                        <select name="lang" id="lang-select" required>
                            <option value="">Choose a language</option>
                            <option value="English">English</option>
                            <option value="Hindi">Hindi</option>
                            <option value="Punjabi">Punjabi</option>
                            <option value="Bhojpuri">Bhojpuri</option>
                        </select>

                        <label for="year">Release Year</label>
                        <input type="number" id="year" name="year" placeholder="2024" required>

                        <label for="albumName">Album Name</label>
                        <input type="text" id="albumName" name="albumName" placeholder="Enter album name" required>

                        <button type="submit">Add Song</button>
                    </form>
                </div>
            </div>

            <!-- View Songs Tab -->
            <div id="viewSongs" class="tabcontent">
                <div class="page-header">
                    <h1>All Songs</h1>
                    <p>View complete song library</p>
                </div>

                <div class="table-wrapper">
                    <%
                        try {
                            Connection cn = MyConnection.createConnection();
                            Statement smt = cn.createStatement();
                            ResultSet rs = smt.executeQuery("select * from song");
                            out.println("<table>");
                            out.println("<caption><h2>Song Library</h2></caption>");
                            out.println("<tr><th>ID</th><th>Song Name</th><th>Singer</th><th>Language</th><th>Year</th><th>Album</th><th>Image</th><th>Audio</th></tr>");
                            while (rs.next()) {
                                String songId = rs.getString(1);
                                String songName = rs.getString(2);
                                String singerName = rs.getString(3);
                                String lang = rs.getString(4);
                                String year = rs.getString(5);
                                String album = rs.getString(6);
                                String imageFileName = rs.getString(7);
                                String audioFileName = rs.getString(8);

                                out.println("<tr>");
                                out.println("<td>" + songId + "</td>");
                                out.println("<td>" + songName + "</td>");
                                out.println("<td>" + singerName + "</td>");
                                out.println("<td>" + lang + "</td>");
                                out.println("<td>" + year + "</td>");
                                out.println("<td>" + album + "</td>");
                                out.println("<td>" + imageFileName + "</td>");
                                out.println("<td>" + audioFileName + "</td>");
                                out.println("</tr>");
                            }
                            out.println("</table>");
                            cn.close();
                        } catch (Exception e) {
                            out.println("<p style='color: var(--danger-color); text-align: center;'>" + e.getMessage() + "</p>");
                        }
                    %>
                </div>
            </div>

            <!-- Edit Songs Tab -->
            <div id="editSongs" class="tabcontent">
                <div class="page-header">
                    <h1>Edit Songs</h1>
                    <p>Modify song information and details</p>
                </div>

                <div class="table-wrapper">
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            String dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/gana_bajao"; String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "shailesh"; String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : ""; Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                            Statement smt = cn.createStatement();
                            ResultSet rs = smt.executeQuery("select * from song");
                            out.println("<table>");
                            out.println("<caption><h2>Edit Song Details</h2></caption>");
                            out.println("<tr><th>ID</th><th>Song Name</th><th>Singer</th><th>Language</th><th>Year</th><th>Album</th><th>Image</th><th>Audio</th><th>Action</th></tr>");
                            while (rs.next()) {
                                String songId = rs.getString(1);
                                String songName = rs.getString(2);
                                String singerName = rs.getString(3);
                                String lang = rs.getString(4);
                                String year = rs.getString(5);
                                String album = rs.getString(6);
                                String imageFileName = rs.getString(7);
                                String audioFileName = rs.getString(8);

                                out.println("<tr>");
                                out.println("<td>" + songId + "</td>");
                                out.println("<td>" + songName + "</td>");
                                out.println("<td>" + singerName + "</td>");
                                out.println("<td>" + lang + "</td>");
                                out.println("<td>" + year + "</td>");
                                out.println("<td>" + album + "</td>");
                                out.println("<td>" + imageFileName + "</td>");
                                out.println("<td>" + audioFileName + "</td>");
                                out.println("<td><a href='edit_data.jsp?id=" + songId + "' title='Edit'><img src='images/buttons/pen.png' width='20' height='20'></a></td>");
                                out.println("</tr>");
                            }
                            out.println("</table>");
                            cn.close();
                        } catch (Exception e) {
                            out.println("<p style='color: var(--danger-color); text-align: center;'>" + e.getMessage() + "</p>");
                        }
                    %>
                </div>
            </div>

            <!-- Delete Songs Tab -->
            <div id="deleteSongs" class="tabcontent">
                <div class="page-header">
                    <h1>Delete Songs</h1>
                    <p>Remove songs from your library</p>
                </div>

                <div class="table-wrapper">
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            String dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/gana_bajao"; String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "shailesh"; String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : ""; Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                            Statement smt = cn.createStatement();
                            ResultSet rs = smt.executeQuery("select * from song");
                            out.println("<table>");
                            out.println("<caption><h2>Manage Song Deletions</h2></caption>");
                            out.println("<tr><th>ID</th><th>Song Name</th><th>Singer</th><th>Language</th><th>Year</th><th>Album</th><th>Image</th><th>Audio</th><th>Action</th></tr>");
                            while (rs.next()) {
                                String songId = rs.getString(1);
                                String songName = rs.getString(2);
                                String singerName = rs.getString(3);
                                String lang = rs.getString(4);
                                String year = rs.getString(5);
                                String album = rs.getString(6);
                                String imageFileName = rs.getString(7);
                                String audioFileName = rs.getString(8);

                                out.println("<tr>");
                                out.println("<td>" + songId + "</td>");
                                out.println("<td>" + songName + "</td>");
                                out.println("<td>" + singerName + "</td>");
                                out.println("<td>" + lang + "</td>");
                                out.println("<td>" + year + "</td>");
                                out.println("<td>" + album + "</td>");
                                out.println("<td>" + imageFileName + "</td>");
                                out.println("<td>" + audioFileName + "</td>");
                                out.println("<td><a href='Delete_Songs?id=" + songId + "' onclick=\"return confirm('Are you sure you want to delete this song?');\" title='Delete'><img src='images/buttons/delete.png' width='20' height='20'></a></td>");
                                out.println("</tr>");
                            }
                            out.println("</table>");
                            cn.close();
                        } catch (Exception e) {
                            out.println("<p style='color: var(--danger-color); text-align: center;'>" + e.getMessage() + "</p>");
                        }
                    %>
                </div>
            </div>

            <!-- Add Playlists Tab -->
            <div id="addPlaylists" class="tabcontent">
                <div class="page-header">
                    <h1>Create Artist Playlist</h1>
                    <p>Add new curated playlists for featured artists</p>
                </div>

                <div class="container">
                    <h2>Playlist Information</h2>
                    <form action="Admin_Playlist" method="post" enctype="multipart/form-data">
                        <label for="playlist-name">Playlist Name</label>
                        <input type="text" id="playlist-name" name="playlistName" placeholder="Enter playlist name" required>

                        <label for="playlist-image">Playlist Cover Image</label>
                        <input type="file" id="playlist-image" name="playlistImage" accept="image/*" required>

                        <button type="submit">Create Playlist</button>
                    </form>
                </div>
            </div>

            <!-- Delete Artist Playlist Tab -->
            <div id="deleteArtistPlaylist" class="tabcontent">
                <div class="page-header">
                    <h1>Delete Artist Playlists</h1>
                    <p>Remove artist playlists from the platform</p>
                </div>

                <div class="table-wrapper">
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            String dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/gana_bajao"; String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "shailesh"; String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : ""; Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                            Statement smt = cn.createStatement();
                            ResultSet rs = smt.executeQuery("select * from artist_playlists");
                            out.println("<table>");
                            out.println("<caption><h2>Artist Playlists</h2></caption>");
                            out.println("<tr><th>Playlist ID</th><th>Playlist Name</th><th>Action</th></tr>");
                            while (rs.next()) {
                                String playlistId = rs.getString(1);
                                String playlistName = rs.getString(3);

                                out.println("<tr>");
                                out.println("<td>" + playlistId + "</td>");
                                out.println("<td>" + playlistName + "</td>");
                                out.println("<td><a href='DeletePlaylist?playlistId=" + playlistId + "' onclick=\"return confirm('Are you sure you want to delete this playlist?');\" title='Delete'><img src='images/buttons/delete.png' width='20' height='20'></a></td>");
                                out.println("</tr>");
                            }
                            out.println("</table>");
                            cn.close();
                        } catch (Exception e) {
                            out.println("<p style='color: var(--danger-color); text-align: center;'>" + e.getMessage() + "</p>");
                        }
                    %>
                </div>
            </div>

            <!-- Edit Artist Playlist Tab -->
            <div id="editArtistPlaylist" class="tabcontent">
                <div class="page-header">
                    <h1>Manage Playlist Songs</h1>
                    <p>Add songs to artist playlists</p>
                </div>

                <div class="table-wrapper">
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            String dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/gana_bajao"; String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "shailesh"; String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : ""; Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                            Statement smt = cn.createStatement();
                            ResultSet rs = smt.executeQuery("select * from artist_playlists");
                            out.println("<table>");
                            out.println("<caption><h2>Add Songs to Playlists</h2></caption>");
                            out.println("<tr><th>Playlist ID</th><th>Playlist Name</th><th>Action</th></tr>");
                            while (rs.next()) {
                                String playlistId = rs.getString(1);
                                String playlistName = rs.getString(3);

                                out.println("<tr>");
                                out.println("<td>" + playlistId + "</td>");
                                out.println("<td>" + playlistName + "</td>");
                                out.println("<td><a href='add_songs.jsp?playlistName=" + playlistName + "&playlistId=" + playlistId + "' title='Add Songs'><img src='images/buttons/pen.png' width='20' height='20'></a></td>");
                                out.println("</tr>");
                            }
                            out.println("</table>");
                            cn.close();
                        } catch (Exception e) {
                            out.println("<p style='color: var(--danger-color); text-align: center;'>" + e.getMessage() + "</p>");
                        }
                    %>
                </div>
            </div>

            <!-- No Name Tab (Settings) -->
            <div id="userInfo" class="tabcontent">
                <div class="page-header">
                    <h1>Manage USER'S</h1>
                    <p> Here you can manage users </p>
                </div>

                <div class="table-wrapper">
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            String dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/gana_bajao"; String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "shailesh"; String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : ""; Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                            Statement smt = cn.createStatement();
                            ResultSet rs = smt.executeQuery("select * from user_info");
                            out.println("<table>");
                            out.println("<caption><h2>Users Detail</h2></caption>");
                            out.println("<tr><th>User ID</th><th>User Name</th><th>Email Address</th><th>Action</th></tr>");
                            while (rs.next()) {
                                String userId = rs.getString(1);
                                String userName = rs.getString(2);
                                String userEmail = rs.getString(3);

                                out.println("<tr>");
                                out.println("<td>" + userId + "</td>");
                                out.println("<td>" + userName + "</td>");
                                out.println("<td>" + userEmail + "</td>");
                                out.println("<td><a href='ManageUser?id=" + userId + "' onclick=\"return confirm('Are you sure you want to delete this song?');\" title='Delete'><img src='images/buttons/delete.png' width='20' height='20'></a></td>");
                                out.println("</tr>");
                            }
                            out.println("</table>");
                            cn.close();
                        } catch (Exception e) {
                            out.println("<p style='color: var(--danger-color); text-align: center;'>" + e.getMessage() + "</p>");
                        }
                    %>
                </div>


            </div>
        </div>

        <script>
            function openFunc(evt, tabName) {
                var i, tabcontent, tablinks;

                // Hide all tab content
                tabcontent = document.getElementsByClassName("tabcontent");
                for (i = 0; i < tabcontent.length; i++) {
                    tabcontent[i].classList.remove('active');
                }

                // Remove active class from all tabs
                tablinks = document.getElementsByClassName("tablinks");
                for (i = 0; i < tablinks.length; i++) {
                    tablinks[i].classList.remove('active');
                }

                // Show current tab and mark as active
                document.getElementById(tabName).classList.add('active');
                evt.currentTarget.classList.add('active');

                // Close mobile menu if open
                if (window.innerWidth <= 768) {
                    document.getElementById('sidebar').classList.remove('mobile-active');
                }
            }

            function toggleMobileMenu() {
                document.getElementById('sidebar').classList.toggle('mobile-active');
            }

            // Open default tab on page load
            document.addEventListener('DOMContentLoaded', function () {
                document.getElementById("defaultOpen").click();
            });

            // Close mobile menu when clicking outside
            document.addEventListener('click', function (event) {
                const sidebar = document.getElementById('sidebar');
                const toggle = document.querySelector('.mobile-menu-toggle');

                if (window.innerWidth <= 768) {
                    if (!sidebar.contains(event.target) && !toggle.contains(event.target)) {
                        sidebar.classList.remove('mobile-active');
                    }
                }
            });
        </script>
    </body>
</html>
