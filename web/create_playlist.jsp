<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // Session Check (Bug 9 Fix)
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("email") == null) {
        response.sendRedirect("index.html");
        return;
    }
    String userName = (String) sess.getAttribute("name");
    if (userName == null) userName = "User";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Gaanare - Create Playlist</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            padding: 20px;
        }
        body::before {
            content: '';
            position: fixed;
            top: 0; left: 0; width: 100vw; height: 100vh;
            background:
                radial-gradient(circle at 15% 50%, rgba(139, 92, 246, 0.5) 0%, transparent 50%),
                radial-gradient(circle at 85% 30%, rgba(59, 130, 246, 0.4) 0%, transparent 50%);
            z-index: -1; filter: blur(80px);
            animation: gradientMove 15s ease-in-out infinite alternate;
        }
        @keyframes gradientMove {
            0% { transform: scale(1) translate(0, 0); }
            100% { transform: scale(1.2) translate(-5%, 5%); }
        }
        .logo-area {
            text-align: center;
            margin-bottom: 30px;
            animation: float 6s ease-in-out infinite;
        }
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        .logo-area img {
            width: 130px;
            filter: drop-shadow(0 0 20px rgba(139, 92, 246, 0.7));
        }
        .card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            padding: 40px;
            width: 100%;
            max-width: 480px;
            position: relative;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
        }
        .card::before {
            content: '';
            position: absolute;
            top: 0; left: 10%; right: 10%; height: 1px;
            background: linear-gradient(90deg, transparent, var(--accent-color), transparent);
        }
        h2 {
            font-size: 28px;
            font-weight: 800;
            text-align: center;
            margin-bottom: 8px;
            background: linear-gradient(135deg, #fff, #a1a1aa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        p.subtitle {
            color: var(--secondary-text);
            text-align: center;
            margin-bottom: 30px;
            font-size: 15px;
        }
        label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: var(--secondary-text);
            margin-bottom: 10px;
        }
        input[type="text"] {
            width: 100%;
            padding: 16px;
            background: rgba(0,0,0,0.5);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            color: #fff;
            font-size: 16px;
            font-family: 'Outfit', sans-serif;
            transition: all 0.3s ease;
            margin-bottom: 24px;
        }
        input[type="text"]:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 15px rgba(139, 92, 246, 0.3);
        }
        button[type="submit"] {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, var(--accent-color), #4f46e5);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            font-family: 'Outfit', sans-serif;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        button[type="submit"]:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(139, 92, 246, 0.5);
        }
        .back-link {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 20px;
            color: var(--secondary-text);
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s;
        }
        .back-link:hover { color: var(--accent-hover); }
    </style>
</head>
<body>
    <div class="logo-area">
        <a href="user_home.jsp"><img src="images/web_images/logoGanare.png" alt="Gaanare Logo"></a>
    </div>
    <div class="card">
        <h2><i class="fas fa-music" style="color: var(--accent-color); font-size: 22px;"></i> Create Playlist</h2>
        <p class="subtitle">Create a new playlist for your favorite songs</p>
        <form action="playlist_db.jsp" method="post">
            <label for="playlist-name">Playlist Name</label>
            <input type="text" id="playlist-name" name="playlistName" placeholder="My Awesome Playlist" required maxlength="50">
            <button type="submit"><i class="fas fa-plus"></i> Create Playlist</button>
        </form>
    </div>
    <a href="user_home.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Back to Home</a>
</body>
</html>
