<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add To Playlist</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            body {
                background-color: #f8f9fa;
                color: #333;
                text-align: center;
            }
            .container {
                width: 90%;
                max-width: 1200px;
                margin: 40px auto;
                background: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            }
            h1 {
                color: #343a40;
                font-size: 28px;
                margin-bottom: 10px;
                font-weight: 600;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                background: white;
            }
            th, td {
                padding: 12px;
                text-align: center;
                border-bottom: 1px solid #ddd;
            }
            th {
                background-color: #007BFF;
                color: white;
                text-transform: uppercase;
                font-size: 14px;
                font-weight: 600;
            }
            tr:nth-child(even) {
                background-color: #f2f2f2;
            }
            tr:hover {
                background-color: #e9ecef;
                transition: 0.2s ease-in-out;
            }
            .add-btn {
                text-decoration: none;
                background-color: #28a745;
                color: white;
                padding: 8px 12px;
                border-radius: 5px;
                font-weight: 500;
                transition: background 0.3s ease-in-out;
                cursor: pointer;
                border: none;
            }
            .add-btn:hover {
                background-color: #218838;
            }
            .playlist-box {
                margin-top: 20px;
                padding: 15px;
                background: #e3f2fd;
                border-left: 4px solid #007BFF;
                display: inline-block;
                font-size: 18px;
                font-weight: 500;
                color: #007BFF;
                border-radius: 4px;
            }
            .home-btn {
                margin-top: 30px;
                padding: 12px 24px;
                background-color: #007BFF;
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                cursor: pointer;
            }
            .home-btn:hover {
                background-color: #0056b3;
            }
        </style>
        <script>
            function addSong(songId) {
                fetch('AddSongPlaylist', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: 'songId=' + songId
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.status === "success") {
                                alert("✅ Song added to playlist.");
                            } else if (data.status === "exists") {
                                alert("⚠️ Song already in playlist.");
                            } else {
                                alert("❌ Failed to add song.");
                                console.error("Error message:", data.message);
                            }
                        })
                        .catch(error => {
                            alert("❌ Error occurred.");
                            console.error("Request failed:", error);
                        });
            }

            
        </script>
    </head>
    <body>
        <div class="container">
            <h1>Here, Select Songs For The Playlist!</h1>

            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gana_bajao", "shailesh", "");
                    Statement smt = cn.createStatement();
                    ResultSet rs = smt.executeQuery("SELECT * FROM song");

                    out.println("<table>");
                    out.println("<caption><h2 style='color: #007BFF; margin-bottom: 10px;'>Available Songs</h2></caption>");
                    out.println("<tr><th>Song ID</th><th>Song Name</th><th>Singer Name</th><th>Language</th><th>Release Year</th><th>Album Name</th><th>Action</th></tr>");

                    while (rs.next()) {
                        String songId = rs.getString(1);
                        String songName = rs.getString(2);
                        String singerName = rs.getString(3);
                        String lang = rs.getString(4);
                        String year = rs.getString(5);
                        String album = rs.getString(6);

                        out.println("<tr>");
                        out.println("<td>" + songId + "</td>");
                        out.println("<td>" + songName + "</td>");
                        out.println("<td>" + singerName + "</td>");
                        out.println("<td>" + lang + "</td>");
                        out.println("<td>" + year + "</td>");
                        out.println("<td>" + album + "</td>");
                        out.println("<td><button class='add-btn' onclick='addSong(" + songId + ")'>Add Song</button></td>");
                        out.println("</tr>");
                    }

                    out.println("</table>");
                    cn.close();
                } catch (Exception e) {
                    out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                }
            %>

            <%
                String playlistName = request.getParameter("playlistName");
                if (playlistName != null) {
                    session.setAttribute("playlistName", playlistName);
                } else {
                    playlistName = (String) session.getAttribute("playlistName");
                }

                String role = (String) session.getAttribute("role");
                String homePage = "user_home.jsp";

                if ("admin".equals(role)) {
                    homePage = "admin_home.jsp";
                }
            %>

            <div class="playlist-box">Selected Playlist: <%= playlistName%></div>
        
            <button class="home-btn" onclick="window.location.href = '<%= homePage%>'">Go to Home</button>
            <!--        <button class="home-btn" onclick="goHome()">Go to Home</button>-->
        </div>
    </body>
</html>
