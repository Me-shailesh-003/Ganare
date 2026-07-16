<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.ganare.dbconnection.MyConnection"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gaanare - Where Melodies Reflect The Soul</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-bg: #09090b;
            --primary-text: #ffffff;
            --secondary-text: #a1a1aa;
            --accent-glow: rgba(139, 92, 246, 0.6);
            --accent-glow-secondary: rgba(59, 130, 246, 0.6);
            --accent-color: #8b5cf6;
            --accent-hover: #a78bfa;
            --gradient-start: #8b5cf6;
            --gradient-end: #3b82f6;
            --glass-bg: rgba(255, 255, 255, 0.05);
            --glass-border: rgba(255, 255, 255, 0.1);
            --glass-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
        }

        body {
            font-family: 'Outfit', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--primary-bg);
            color: var(--primary-text);
            line-height: 1.6;
            overflow-x: hidden;
            padding-bottom: 120px;
        }

        /* Animated Background */
        body::before {
            content: '';
            position: fixed;
            top: 0; left: 0; width: 100vw; height: 100vh;
            background: 
                radial-gradient(circle at 15% 50%, var(--accent-glow) 0%, transparent 50%),
                radial-gradient(circle at 85% 30%, var(--accent-glow-secondary) 0%, transparent 50%);
            z-index: -1;
            filter: blur(80px);
            animation: gradientMove 15s ease-in-out infinite alternate;
        }

        @keyframes gradientMove {
            0% { transform: scale(1) translate(0, 0); }
            50% { transform: scale(1.2) translate(5%, -5%); }
            100% { transform: scale(1) translate(-5%, 5%); }
        }

        /* Sidebar Navigation */
        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 240px;
            height: 100vh;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            padding: 24px;
            z-index: 100;
            border-right: 1px solid var(--glass-border);
            overflow-y: auto;
            box-shadow: 10px 0 30px rgba(0,0,0,0.5);
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
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 32px;
            padding: 8px;
        }

        .logo-container img {
            width: 100%;
            height: 100%;
            border-radius: 8px;
        }

        .logo-text {
            font-size: 24px;
            font-weight: 700;
            background: linear-gradient(135deg, var(--accent-color), #1ed760);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .nav-links {
            list-style: none;
            margin-bottom: 32px;
        }

        .nav-links li {
            margin-bottom: 8px;
        }

        .nav-links a {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 12px 16px;
            color: var(--secondary-text);
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .nav-links a:hover,
        .nav-links a.active {
            background: var(--card-bg);
            color: var(--primary-text);
        }

        .nav-links i {
            width: 24px;
            font-size: 20px;
        }

        /* Main Content */
        .main-content {
            margin-left: 240px;
            padding: 24px 32px;
            max-width: 1800px;
        }

        /* Header */
        .top-header {
            position: sticky;
            top: 0;
            background: var(--glass-bg);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            padding: 16px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 90;
            border-bottom: 1px solid var(--glass-border);
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            border-radius: 0 0 20px 20px;
            margin-bottom: 10px;
        }

        .search-container {
            flex: 1;
            max-width: 500px;
            margin: 0 24px;
        }

        .search-container form {
            display: flex;
            align-items: center;
            gap: 12px;
            width: 100%;
        }

        .search-select, .search-input {
            padding: 10px 16px;
            border-radius: 24px;
            border: 1px solid var(--glass-border);
            background: rgba(0, 0, 0, 0.4);
            color: var(--primary-text);
            font-family: inherit;
            height: 44px; /* Ensure uniform height */
            box-sizing: border-box;
        }

        .search-select {
        }

        .search-select:hover {
            background: var(--hover-bg);
        }

        .search-input {
            flex: 1;
            padding: 12px 20px 12px 44px;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            color: var(--primary-text);
            font-size: 14px;
            transition: all 0.3s ease;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="%23b3b3b3" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><path d="m21 21-4.35-4.35"></path></svg>');
            background-repeat: no-repeat;
            background-position: 16px center;
        }

        .search-input:focus {
            outline: none;
            border-color: var(--accent-color);
            background-color: var(--hover-bg);
        }

        .search-btn {
            padding: 12px 28px;
            background: var(--accent-color);
            border: none;
            border-radius: 24px;
            color: var(--primary-text);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
        }

        .search-btn:hover {
            background: var(--accent-hover);
            transform: scale(1.05);
        }

        .user-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 16px;
            background: var(--card-bg);
            border-radius: 24px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .user-profile:hover {
            background: var(--hover-bg);
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-color), #1ed760);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }

        .logout-btn {
            padding: 10px 24px;
            background: transparent;
            border: 1px solid var(--accent-color);
            border-radius: 24px;
            color: var(--accent-color);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
        }

        .logout-btn:hover {
            background: var(--accent-color);
            color: var(--primary-text);
            transform: scale(1.05);
        }

        /* Welcome Banner */
        .welcome-banner {
            background: linear-gradient(135deg, #1db954 0%, #191414 100%);
            padding: 48px;
            border-radius: 16px;
            margin-bottom: 48px;
            position: relative;
            overflow: hidden;
        }

        .welcome-banner::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }

        .welcome-banner h1 {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 12px;
            position: relative;
        }

        .welcome-banner p {
            font-size: 18px;
            opacity: 0.9;
            position: relative;
        }

        /* Section Headers */
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .section-header h2 {
            font-size: 28px;
            font-weight: 700;
        }

        .view-all {
            color: var(--secondary-text);
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .view-all:hover {
            color: var(--primary-text);
        }

        /* Card Grid */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 220px));
            justify-content: start;
            gap: 24px;
            margin-bottom: 64px;
        }

        .music-card {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            padding: 16px;
            border-radius: 12px;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            cursor: pointer;
            position: relative;
            overflow: hidden;
            display: block; /* Ensure it behaves correctly as a flex/grid child */
            text-decoration: none;
        }

        .music-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            border-radius: 12px;
            padding: 2px;
            background: linear-gradient(135deg, rgba(255,255,255,0.2), rgba(255,255,255,0));
            -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
            -webkit-mask-composite: xor;
            mask-composite: exclude;
            pointer-events: none;
        }

        .music-card:hover {
            background: rgba(255, 255, 255, 0.08);
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.6);
        }

        .card-image-container {
            position: relative;
            width: 100%;
            padding-bottom: 100%; /* Maintain 1:1 aspect ratio */
            margin-bottom: 16px;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4);
        }

        .card-image {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 8px;
            transition: transform 0.5s ease;
        }

        .music-card:hover .card-image {
            transform: scale(1.05);
        }

        .play-overlay {
            position: absolute;
            bottom: 8px;
            right: 8px;
            width: 48px;
            height: 48px;
            background: var(--accent-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transform: translateY(8px);
            transition: all 0.3s ease;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.4);
        }

        .music-card:hover .play-overlay {
            opacity: 1;
            transform: translateY(0);
        }

        .play-overlay i {
            color: var(--primary-bg);
            font-size: 20px;
            margin-left: 2px;
        }

        .card-title {
            font-size: 16px;
            font-weight: 600;
            color: var(--primary-text);
            margin-bottom: 8px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .card-subtitle {
            font-size: 14px;
            color: var(--secondary-text);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        /* Create Playlist Button */
        .create-playlist-btn {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            padding: 14px 28px;
            background: linear-gradient(135deg, var(--accent-color), #1ed760);
            border: none;
            border-radius: 24px;
            color: var(--primary-text);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 32px;
            text-decoration: none;
            font-size: 15px;
        }

        .create-playlist-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 24px rgba(29, 185, 84, 0.4);
        }

        .create-playlist-btn i {
            font-size: 20px;
        }

        /* Music Player */
        .music-player {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            background: var(--glass-bg);
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border-top: 1px solid var(--glass-border);
            padding: 16px 24px;
            z-index: 1000;
            box-shadow: 0 -10px 40px rgba(0, 0, 0, 0.6);
        }

        .player-wrapper {
            display: grid;
            grid-template-columns: 1fr 2fr 1fr;
            gap: 24px;
            align-items: center;
            max-width: 1800px;
            margin: 0 auto;
        }

        .now-playing {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .now-playing-image {
            width: 56px;
            height: 56px;
            border-radius: 8px;
            object-fit: cover;
        }

        .now-playing-info {
            flex: 1;
            min-width: 0;
        }

        .now-playing-title {
            font-size: 14px;
            font-weight: 600;
            color: var(--primary-text);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .now-playing-artist {
            font-size: 12px;
            color: var(--secondary-text);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .player-controls-center {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
        }

        .player-buttons {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .control-btn {
            width: 32px;
            height: 32px;
            background: transparent;
            border: none;
            color: var(--secondary-text);
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }

        .control-btn:hover {
            color: var(--primary-text);
            transform: scale(1.1);
        }

        .control-btn.play-pause {
            width: 40px;
            height: 40px;
            background: var(--primary-text);
            color: var(--primary-bg);
        }

        .control-btn.play-pause:hover {
            transform: scale(1.08);
        }

        .progress-container {
            width: 100%;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .progress-bar {
            flex: 1;
            height: 4px;
            background: var(--hover-bg);
            border-radius: 2px;
            cursor: pointer;
            position: relative;
            -webkit-appearance: none;
        }

        .progress-bar::-webkit-slider-thumb {
            -webkit-appearance: none;
            width: 12px;
            height: 12px;
            background: var(--primary-text);
            border-radius: 50%;
            cursor: pointer;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .progress-container:hover .progress-bar::-webkit-slider-thumb {
            opacity: 1;
        }

        .player-extras {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 16px;
        }

        /* Footer */
        .footer-content {
            background: var(--primary-bg);
            padding: 64px 32px 32px;
            margin-top: 64px;
            border-top: 1px solid var(--border-color);
        }

        .footer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 48px;
            max-width: 1200px;
            margin: 0 auto 48px;
        }

        .footer-section h3 {
            font-size: 18px;
            margin-bottom: 16px;
        }

        .footer-section p,
        .footer-section a {
            color: var(--secondary-text);
            text-decoration: none;
            font-size: 14px;
            line-height: 2;
            transition: color 0.3s ease;
        }

        .footer-section a:hover {
            color: var(--primary-text);
        }

        .social-links {
            display: flex;
            gap: 16px;
        }

        .social-links a {
            width: 40px;
            height: 40px;
            background: var(--card-bg);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .social-links a:hover {
            background: var(--accent-color);
            transform: translateY(-4px);
        }

        .mobile-menu-btn {
            display: none;
            background: none;
            border: none;
            color: var(--primary-text);
            font-size: 24px;
            cursor: pointer;
            padding: 8px;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .sidebar {
                width: 80px;
                padding: 16px;
            }

            .logo-container img {
                display: none;
            }

            .nav-links span {
                display: none;
            }

            .main-content {
                margin-left: 80px;
            }

            .card-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: 16px;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                width: 250px;
                position: fixed;
                z-index: 1000;
            }

            .sidebar.active {
                transform: translateX(0);
            }

            .logo-container img,
            .nav-links span {
                display: inline-block;
            }

            .main-content {
                margin-left: 0;
                padding: 16px;
            }

            .mobile-menu-btn {
                display: block;
                margin-right: 16px;
            }
            
            .top-header {
                justify-content: flex-start;
                padding: 15px;
            }
            
            .search-container {
                display: none; /* Hide complex search on small mobile for simplicity, or we can make it a toggle */
            }

            .player-wrapper {
                grid-template-columns: 1fr;
                gap: 12px;
            }

            .player-extras {
                justify-content: center;
            }
            
            .now-playing {
                justify-content: center;
            }

            .welcome-banner h1 {
                font-size: 24px;
            }
            
            .welcome-banner {
                padding: 30px 20px;
            }

            .card-grid {
                grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
            }
            
            .footer-grid {
                grid-template-columns: 1fr;
                gap: 32px;
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
                RequestDispatcher rd = request.getRequestDispatcher("index.html");
                rd.include(request, response);
                out.println("<script>loginFirst();</script>");
            }
        } catch (Exception e) {
            RequestDispatcher rd = request.getRequestDispatcher("index.html");
            rd.include(request, response);
            out.println("<script>loginFirst();</script>");
        }
    %>

    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="logo-container">
            <img src="images/web_images/logoGanare.png" alt="Gaanare Logo">
            
        </div>

        <ul class="nav-links">
            <li><a href="#home" class="active"><i class="fas fa-home"></i><span>Home</span></a></li>
            <li><a href="#genres"><i class="fas fa-guitar"></i><span>Trending</span></a></li>
            <li><a href="#artists"><i class="fas fa-star"></i><span>Artists</span></a></li>
            <li><a href="#playlists"><i class="fas fa-list"></i><span>Your Playlists</span></a></li>
            <li><a href="#liked"><i class="fas fa-heart"></i><span>Liked Songs</span></a></li>
            <li><a href="#about"><i class="fas fa-info-circle"></i><span>About Us</span></a></li>
            <li><a href="#contact"><i class="fas fa-envelope"></i><span>Contact</span></a></li>
        </ul>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Top Header -->
        <header class="top-header">
            <button class="mobile-menu-btn" onclick="toggleMobileMenu()">
                <i class="fas fa-bars"></i>
            </button>
            <div class="search-container">
                <form action="search_filter.jsp" style="display: flex; gap: 12px; width: 100%;">
                    <select name="filter" class="search-select">
                        <option selected="selected" value="">Sort By</option>
                        <option value="song_name">Song Name</option>
                        <option value="singer_name">Singer Name</option>
                        <option value="album_name">Album Name</option>
                        <option value="language">Language</option>
                        <option value="release_year">Release Year</option>
                    </select>
                    <input type="text" name="search" placeholder="Search songs, artists, albums..." class="search-input">
                    <button type="submit" class="search-btn">Search</button>
                </form>
            </div>

            <div class="user-actions">
                <div class="user-profile">
                    <div class="user-avatar"><%= ((String) session.getAttribute("name")).substring(0, 1).toUpperCase() %></div>
                    <span><%= session.getAttribute("name") %></span>
                </div>
                <form action="User_Logout" onsubmit="return confirm('Are you sure you want to logout?');">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </header>

        <!-- Welcome Banner -->
        <section class="welcome-banner" id="home">
            <h1>Welcome back, <%= session.getAttribute("name") %></h1>
            <p>Where Melodies Reflect The Soul</p>
        </section>

        <!-- Trending Songs Section -->
        <section id="genres">
            <div class="section-header">
                <h2>Trending Songs</h2>
                <a href="#" class="view-all">See all</a>
            </div>

            <div class="card-grid">
                <%
                    try {
                        ArrayList<Map<String, String>> songsList = new ArrayList<>();
                        Connection cn = MyConnection.createConnection();
                        Statement smt = cn.createStatement();
                        ResultSet rs = smt.executeQuery("SELECT * FROM song");

                        while (rs.next()) {
                            Map<String, String> songMap = new HashMap<>();
                            songMap.put("id", rs.getString(1));
                            songMap.put("songName", rs.getString(2));
                            songMap.put("singerName", rs.getString(3));
                            songMap.put("imageFileName", rs.getString(7));
                            songMap.put("audioFileName", rs.getString(8));
                            songsList.add(songMap);
                %>

                <a href='user_home.jsp?id=<%=songMap.get("id")%>' class="music-card">
                    <div class="card-image-container">
                        <img src='images/Songs_image/<%= songMap.get("imageFileName") %>' class="card-image" alt="<%= songMap.get("songName") %>">
                        <div class="play-overlay">
                            <i class="fas fa-play"></i>
                        </div>
                    </div>
                    <div class="card-title"><%= songMap.get("songName") %></div>
                    <div class="card-subtitle"><%= songMap.get("singerName") %></div>
                </a>

                <%
                        }
                        session.setAttribute("songsList", songsList);
                        rs.close();
                        smt.close();
                        cn.close();
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                %>
            </div>
        </section>

        <!-- Featured Artists Section -->
        <section id="artists">
            <div class="section-header">
                <h2>Featured Artists</h2>
                <a href="#" class="view-all">See all</a>
            </div>

            <div class="card-grid">
                <%
                    boolean hasPlaylists = false;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        String dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/gana_bajao"; String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "shailesh"; String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : ""; Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                        String query = "SELECT playlist_id, name, image FROM artist_playlists";
                        PreparedStatement ps = cn.prepareStatement(query);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                            hasPlaylists = true;
                            int playlistId = rs.getInt("playlist_id");
                            String playlistName = rs.getString("name");
                            String artist_image = rs.getString("image");
                %>

                <a href='show_admin_playlist.jsp?playlistName=<%= playlistName%>&playlistId=<%= playlistId%>&artistImage=<%= artist_image%>' class="music-card">
                    <div class="card-image-container">
                        <img src='images/Songs_image/Artist_Images/<%=artist_image%>' class="card-image" alt="<%= playlistName %>">
                        <div class="play-overlay">
                            <i class="fas fa-play"></i>
                        </div>
                    </div>
                    <div class="card-title"><%= playlistName %></div>
                    <div class="card-subtitle">Artist Playlist</div>
                </a>

                <%
                        }
                        rs.close();
                        ps.close();
                        cn.close();
                    } catch (Exception e) {
                        out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                    }

                    if (!hasPlaylists) {
                %>
                <p style="grid-column: 1/-1; text-align: center; color: var(--secondary-text);">No artist playlists available at this time.</p>
                <% } %>
            </div>
        </section>

        <!-- Your Playlists Section -->
        <section id="playlists">
            <div class="section-header">
                <h2>Your Playlists</h2>
            </div>

            <a href="create_playlist.jsp" class="create-playlist-btn">
                <i class="fas fa-plus"></i>
                Create New Playlist
            </a>

            <div class="card-grid">
                <%
                    boolean hasUserPlaylists = false;
                    try {
                        String userId = (String) session.getAttribute("userId");
                        if (userId == null) {
                            out.println("<p style='grid-column: 1/-1; color: var(--secondary-text); text-align: center;'>User ID not found in session. Please log in again.</p>");
                        } else {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            String dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/gana_bajao"; String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "shailesh"; String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : ""; Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                            String query = "SELECT playlist_id, name FROM user_playlists WHERE id = ?";
                            PreparedStatement ps = cn.prepareStatement(query);
                            ps.setString(1, userId);
                            ResultSet rs = ps.executeQuery();

                            while (rs.next()) {
                                hasUserPlaylists = true;
                                int playlistId = rs.getInt("playlist_id");
                                String playlistName = rs.getString("name");
                %>

                <a href='show_one_playlist.jsp?playlistName=<%= playlistName%>&playlistId=<%= playlistId%>' class="music-card">
                    <div class="card-image-container">
                        <img src="images/playlists_image/Hot_Hits.jpg" class="card-image" alt="<%= playlistName %>">
                        <div class="play-overlay">
                            <i class="fas fa-play"></i>
                        </div>
                    </div>
                    <div class="card-title"><%= playlistName %></div>
                    <div class="card-subtitle">Your Playlist</div>
                </a>

                <%
                            }
                            rs.close();
                            ps.close();
                            cn.close();
                        }
                    } catch (Exception e) {
                        out.println("<p style='grid-column: 1/-1; color: red; text-align: center;'>Error: " + e.getMessage() + "</p>");
                    }

                    if (!hasUserPlaylists) {
                %>
                <p style="grid-column: 1/-1; text-align: center; color: var(--secondary-text);">No playlists yet. Create one to get started!</p>
                <% } %>
            </div>
        </section>

        <!-- About Section -->
        <section id="about">
            <div class="section-header">
                <h2>About Gaanare</h2>
            </div>
            <div style="background: var(--card-bg); padding: 32px; border-radius: 12px; line-height: 1.8; color: var(--secondary-text);">
                <p style="margin-bottom: 16px;">
                    At Gaanare, we believe in the transformative power of music. Our platform is more than just a place to listen;
                    it's a sanctuary for music lovers and enthusiasts alike. With a mission to bring the world of melodies closer to you, 
                    Gaanare is your go-to destination for discovering, enjoying, and sharing the rhythm of life.
                </p>
                <p style="margin-bottom: 16px;">
                    <strong style="color: var(--primary-text);">Artist Spotlight:</strong>
                    Celebrate the artists who bring music to life. Our Artist Spotlight features delve into the stories behind the music,
                    providing a deeper understanding of the creative minds shaping the industry.
                </p>
                <p style="margin-bottom: 16px;">
                    <strong style="color: var(--primary-text);">Accessible Anywhere, Anytime:</strong>
                    Whether you're at home, on the go, or exploring the world, Gaanare is accessible anytime,
                    anywhere. Take your favorite tunes with you and let the music be your companion.
                </p>
                <p>
                    Join us at Gaanare and be part of a harmonious journey through the world of music. 
                    Together, let's explore, experience, and embrace the extraordinary power of sound.
                </p>
            </div>
        </section>

        <!-- Liked Songs Section -->
        <section id="liked" style="margin-top: 64px;">
            <div class="section-header">
                <h2><i class="fas fa-heart" style="color: var(--accent-color); margin-right: 12px;"></i>Liked Songs</h2>
            </div>
            <div style="background: var(--card-bg); padding: 48px; border-radius: 12px; text-align: center; color: var(--secondary-text);">
                <i class="fas fa-music" style="font-size: 64px; opacity: 0.3; margin-bottom: 16px;"></i>
                <p>Your liked songs will appear here</p>
            </div>
        </section>

        <!-- Footer -->
        <footer class="footer-content" id="contact">
            <div class="footer-grid">
                <div class="footer-section">
                    <h3>Gaanare</h3>
                    <p>Where Melodies Reflect The Soul</p>
                </div>
                <div class="footer-section">
                    <h3>Quick Links</h3>
                    <p><a href="#home">Home</a></p>
                    <p><a href="#genres">Trending</a></p>
                    <p><a href="#artists">Artists</a></p>
                    <p><a href="#playlists">Playlists</a></p>
                </div>
                <div class="footer-section">
                    <h3>Contact Us</h3>
                    <p>Phone: +91-00344334</p>
                    <p><a href="mailto:meshailesh003@gmail.com">meshailesh003@gmail.com</a></p>
                </div>
                <div class="footer-section">
                    <h3>Follow Us</h3>
                    <div class="social-links">
                        <a href="mailto:meshailesh003@gmail.com"><i class="fas fa-envelope"></i></a>
                        <a href="https://www.instagram.com/me_shailesh_003?igsh=OG8xc25lc3piZmJ0"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
            </div>
            <div style="text-align: center; padding-top: 32px; border-top: 1px solid var(--border-color); color: var(--secondary-text); font-size: 14px;">
                <p>&copy; 2025 Gaanare. All rights reserved.</p>
            </div>
        </footer>
    </main>

    <!-- Music Player -->
    <%
        try {
            String songId = request.getParameter("id");
            if (songId != null) {
                System.out.println("Song ID: " + songId);
                Connection cn = MyConnection.createConnection();
                Statement smt = cn.createStatement();
                ResultSet rs = smt.executeQuery("SELECT * FROM song WHERE id = " + songId);

                if (rs.next()) {
                    String songName = rs.getString(2);
                    String singerName = rs.getString(3);
                    String imageFileName = rs.getString(7);
                    String audioFileName = rs.getString(8);
    %>

    <div class="music-player">
        <div class="player-wrapper">
            <div class="now-playing">
                <img src='images/Songs_image/<%= imageFileName%>' alt="Now Playing" class="now-playing-image">
                <div class="now-playing-info">
                    <div class="now-playing-title"><%= songName %></div>
                    <div class="now-playing-artist"><%= singerName %></div>
                </div>
            </div>

            <div class="player-controls-center">
                <div class="player-buttons">
                    <button class="control-btn shuffle-btn"><i class="fas fa-random"></i></button>
                    <button class="control-btn prev-button"><i class="fas fa-step-backward"></i></button>
                    <button class="control-btn play-pause play-pause-button"><i class="fas fa-play"></i></button>
                    <button class="control-btn next-button"><i class="fas fa-step-forward"></i></button>
                    <button class="control-btn loop-button"><i class="fas fa-redo"></i></button>
                </div>
                <div class="progress-container">
                    <span class="time-current" style="color: var(--secondary-text); font-size: 12px;">0:00</span>
                    <input type="range" class="progress-bar" value="0" max="100">
                    <span class="time-total" style="color: var(--secondary-text); font-size: 12px;">0:00</span>
                </div>
            </div>

            <div class="player-extras">
                <a href='Download_Songs?audioName="<%= audioFileName%>"' class="control-btn" title="Download">
                    <i class="fas fa-download"></i>
                </a>
                <button class="control-btn" title="Add to playlist"><i class="fas fa-plus"></i></button>
                <button class="control-btn" title="Like"><i class="far fa-heart"></i></button>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const audioPlayer = new Audio();
            const playPauseButton = document.querySelector('.play-pause-button');
            const prevButton = document.querySelector('.prev-button');
            const nextButton = document.querySelector('.next-button');
            const loopButton = document.querySelector('.loop-button');
            const progressBar = document.querySelector('.progress-bar');
            const timeCurrent = document.querySelector('.time-current');
            const timeTotal = document.querySelector('.time-total');

            let isPlaying = false;
            var currentTrackIndex = 0;

            <%
                ArrayList<Map<String, String>> songsList = (ArrayList<Map<String, String>>) session.getAttribute("songsList");
            %>
            const trackList = [
            <% for (Map<String, String> song : songsList) {%>
                {id: '<%= song.get("id")%>', artist: '<%= song.get("singerName")%>', title: '<%= song.get("songName")%>', source: 'songs/<%= song.get("audioFileName")%>', image: 'images/Songs_image/<%= song.get("imageFileName")%>'},
            <% }%>
            ];

            const userSongId = '<%= songId%>';
            const songIndex = trackList.findIndex(track => track.id === userSongId);

            if (songIndex !== -1) {
                currentTrackIndex = songIndex;
            }

            loadTrack();

            function loadTrack() {
                const currentTrack = trackList[currentTrackIndex];
                audioPlayer.src = currentTrack.source;

                document.querySelector('.now-playing-image').src = currentTrack.image;
                document.querySelector('.now-playing-artist').textContent = currentTrack.artist;
                document.querySelector('.now-playing-title').textContent = currentTrack.title;

                let playPromise = audioPlayer.play();
                if (playPromise !== undefined) {
                    playPromise.then(_ => {
                        isPlaying = true;
                        updatePlayPauseButtonIcon();
                    }).catch(error => {
                        console.log("Autoplay prevented:", error);
                        isPlaying = false;
                        updatePlayPauseButtonIcon();
                    });
                } else {
                    isPlaying = true;
                    updatePlayPauseButtonIcon();
                }
            }

            function updatePlayPauseButtonIcon() {
                const icon = playPauseButton.querySelector('i');
                if (isPlaying) {
                    icon.className = 'fas fa-pause';
                } else {
                    icon.className = 'fas fa-play';
                }
            }

            function formatTime(seconds) {
                const mins = Math.floor(seconds / 60);
                const secs = Math.floor(seconds % 60);
                return `${mins}:${secs < 10 ? '0' : ''}${secs}`;
            }

            playPauseButton.addEventListener('click', togglePlayPause);
            prevButton.addEventListener('click', playPrevious);
            nextButton.addEventListener('click', playNext);
            loopButton.addEventListener('click', toggleLoop);
            progressBar.addEventListener('input', updateProgressBar);

            audioPlayer.addEventListener('timeupdate', function() {
                const progress = (audioPlayer.currentTime / audioPlayer.duration) * 100;
                progressBar.value = progress;
                timeCurrent.textContent = formatTime(audioPlayer.currentTime);
                timeTotal.textContent = formatTime(audioPlayer.duration);
            });

            audioPlayer.addEventListener('ended', function () {
                playNext();
            });

            function togglePlayPause() {
                if (isPlaying) {
                    audioPlayer.pause();
                    isPlaying = false;
                    updatePlayPauseButtonIcon();
                } else {
                    let playPromise = audioPlayer.play();
                    if (playPromise !== undefined) {
                        playPromise.then(_ => {
                            isPlaying = true;
                            updatePlayPauseButtonIcon();
                        }).catch(error => {
                            console.log("Play prevented:", error);
                            isPlaying = false;
                            updatePlayPauseButtonIcon();
                        });
                    } else {
                        isPlaying = true;
                        updatePlayPauseButtonIcon();
                    }
                }
            }

            function playPrevious() {
                currentTrackIndex = (currentTrackIndex - 1 + trackList.length) % trackList.length;
                loadTrack();
            }

            function playNext() {
                currentTrackIndex = (currentTrackIndex + 1) % trackList.length;
                loadTrack();
            }

            function toggleLoop() {
                audioPlayer.loop = !audioPlayer.loop;
                loopButton.style.color = audioPlayer.loop ? 'var(--accent-color)' : 'var(--secondary-text)';
            }

            function updateProgressBar() {
                const progress = progressBar.value / 100;
                audioPlayer.currentTime = progress * audioPlayer.duration;
            }

            // Smooth scroll for navigation
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                        
                // Update active nav link
                        document.querySelectorAll('.nav-links a').forEach(link => link.classList.remove('active'));
                        this.classList.add('active');
                        
                        // Close mobile menu if open
                        document.querySelector('.sidebar').classList.remove('active');
                    }
                });
            });
        });

        function toggleMobileMenu() {
            document.querySelector('.sidebar').classList.toggle('active');
        }
    </script>

    <%
                }
                rs.close();
                smt.close();
                cn.close();
            }
        } catch (Exception e) {
            out.println(e.getMessage());
        }
    %>
</body>
</html>
