<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Playlist Songs</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Lexend:wght@500&display=swap');

            body {
                font-family: 'Lexend', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #4d2a25;
            }

            .container {
                display: block;
            }

            .titles {
                background-color: #854a42;
                color: white;
                text-align: center;
                padding: 50px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .titles img {
                width: 130px;
                height: 130px;
            }

            .titles h1 {
                padding: 50px 0 0 3px;
                margin: 0;
            }

            .buttons {
                display: flex;
                flex-direction: column;
                align-items: flex-end;
                gap: 15px;
                padding-right: 20px;
            }

            .logout-button, .add-song-button {
                padding: 12px 25px;
                background-color: #854a42;
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                text-align: center;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
                transition: background-color 0.3s, transform 0.2s;
            }

            .logout-button:hover, .add-song-button:hover {
                background-color: #61392f;
                transform: translateY(-2px);
            }

            .results {
                color: white;
                text-align: center;
                width: 100%;
                margin: 20px auto;
                border-collapse: collapse;
            }

            .results th, .results td {
                padding: 25px 75px;
            }

            .results th {
                background-color: #854a42;
            }

            .results tr:nth-child(even) {
                background-color: #61392f;
            }

            .results tr:nth-child(odd) {
                background-color: #854a42;
            }

            audio {
                width: 250px;
            }
        </style>
    </head>
    <body>

        <%
            String playlistName = request.getParameter("playlistName");
            String playlistIdStr = request.getParameter("playlistId");

            if (playlistIdStr == null) {
                out.println("<h2 style='color:white;text-align:center;'>Playlist ID missing</h2>");
                return;
            }

            int playlistId = Integer.parseInt(playlistIdStr);

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gana_bajao", "shailesh", "");

                String sql = "SELECT s.* FROM song s "
                        + "JOIN playlist_songs ps ON s.id = ps.song_id "
                        + "WHERE ps.playlist_id = ?";
                PreparedStatement ps = cn.prepareStatement(sql);
                ps.setInt(1, playlistId);
                ResultSet rs = ps.executeQuery();
        %>

        <div class="container">
            <div class="titles">
                <img src="images/playlists_image/Hot_Hits.jpg" alt="Playlist Icon">
                <h1>Your Playlist: <%= playlistName%></h1>

                <div class="buttons">
                    <form action="User_Logout" onsubmit="return confirm('Are you sure you want to logout?');">
                        <input type="submit" value="Logout" class="logout-button">
                    </form>
                    <form action="DeletePlaylist" method="get" onsubmit="return confirm('Are you sure you want to delete this playlist?');">
                        <input type="hidden" name="playlistId" value="<%= playlistId%>">
                        <input type="submit" value="Delete Playlist" class="logout-button" style="background-color: #d9534f;">
                    </form>
                    <form action="add_songs.jsp" method="post">
                        <input type="hidden" name="playlistId" value="<%= playlistId%>">
                        <input type="hidden" name="playlistName" value="<%= playlistName%>">
                        <input type="submit" value="Add New Song" class="add-song-button">
                    </form>
                    
                </div>
            </div>

            <table class="results">
                <thead>
                    <tr>
                        <th>Song Name</th>
                        <th>Singer Name</th>
                        <th>Language</th>
                        <th>Release Year</th>
                        <th>Album Name</th>
                        <th>Play</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        boolean hasSongs = false;
                        while (rs.next()) {
                            hasSongs = true;
                    %>
                    <tr>
                        <td><%= rs.getString("song_name")%></td>
                        <td><%= rs.getString("singer_name")%></td>
                        <td><%= rs.getString("language")%></td>
                        <td><%= rs.getString("release_year")%></td>
                        <td><%= rs.getString("album_name")%></td>
                        <td>
                            <audio controls>
                                <source src="songs/<%= rs.getString("audio_filename")%>" type="audio/mp3">
                                Your browser does not support the audio element.
                            </audio>
                        </td>
                    </tr>
                    <%
                        }
                        if (!hasSongs) {
                    %>
                    <tr><td colspan="6" style="color: white;">No songs in this playlist.</td></tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>

        <%
                cn.close();
            } catch (Exception e) {
                out.println("<h2 style='color:white;text-align:center;'>Error: " + e.getMessage() + "</h2>");
            }
        %>

    </body>
</html>
