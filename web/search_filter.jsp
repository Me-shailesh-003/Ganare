<%-- 
    Document   : search_filter
    Created on : 21-Jan-2024, 10:36:31 pm
    Author     : hp
--%>

<%@page import="com.ganare.dbconnection.MyConnection"%>
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
        <title>Document</title>
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
                max-width: 100vw;
                text-align: center;
                padding: 50px;
                display: flex;
                gap: 40px;
            }

            /*            .results {
            
                            color: white;
                            text-align: center;
                            max-width: 100vw;
                            padding-left: 100px;
                            display: flex;
            
                            gap: 100px;
                        }*/

            .titles img {
                width: 130px;
                height: 130px;
            }



            .titles h1 {
                padding: 50px 0px 0px 3px;
            }

            .results {
                color: white;
                text-align: center;
                max-width: 100vw;
                margin-left: auto;
                margin-right: auto;
                margin-top: 20px;
                border-collapse: collapse;
            }

            .results th,
            .results td {
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



            /*footer css*/



            .footer {
                position: fixed;
                bottom: 0;
                left: 0;
                width: 100%;
                background-color: #f0f0f0;
            }

            .player-container {
                width: 100%;
            }

            .player {
                background-color: #000;
                padding-bottom: 0px;
                padding-top: 10px;
                border-radius: 0px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
                color: white;
                margin-bottom: 10px;
            }

            .media-info {
                margin-left: 55px;
                display: flex;
                align-items: center;
                margin-bottom: -75px;
            }

            .music-image {
                width: 75px;
                height: auto;
                padding-bottom: 10px;
                border-radius: 0%;
                margin-right: 30px;
            }

            .track-info {
                flex-grow: 1;
            }

            .controls {
                width: 350px;
                margin-left: 590px;
                display: flex;
                justify-content: space-around;
                margin-bottom: 15px;
            }

            .progress-bar {
                margin-left: 500px;
                width: 38%;
            }

        </style>
    </head>

    <body>
        <%
            String searchwd = "", filter = "", query = "";
            try {
                searchwd = request.getParameter("search");
                filter = request.getParameter("filter");
                if (filter.equals("")) {
                    query = "select * from song where "
                            + "song_name LIKE '%" + searchwd + "%'  OR "
                            + "singer_name LIKE '%" + searchwd + "%'  OR "
                            + "language LIKE '%" + searchwd + "%' OR "
                            + "release_year  LIKE '%" + searchwd + "%' OR "
                            + "album_name  LIKE '%" + searchwd + "%' OR "
                            + "audio_filename LIKE '%" + searchwd + "%'";
                } else {
                    query = "select * from song where " + filter + " like '%" + searchwd + "%'";
                }

                Connection cn = MyConnection.createConnection();
                Statement smt = cn.createStatement();
                ResultSet rs = smt.executeQuery(query);
        %>

        <div class="container">
            <div class="titles">
                <img src="images/others/magnifier.png" alt="">
                <h1>Search results for "<%= searchwd%>"</h1>
            </div>

            <table class="results">
                <thead>
                    <tr>
                        <th>#Title</th>
                        <th>#Artist</th>
                        <th>#Language</th>
                        <th>#Year</th>
                        <th>#Album</th>
                        <th>#Play</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (rs.next()) {
                            String songId = rs.getString(1);
                            String songName = rs.getString(2);
                            String singerName = rs.getString(3);
                            String lang = rs.getString(4);
                            String year = rs.getString(5);
                            String album = rs.getString(6);
                            String songFilePath= rs.getString(8);
                            
                    %>
                    <tr>
                        <td><%= songName%></td>
                        <td><%= singerName%></td>
                        <td><%= lang%></td>
                        <td><%= year%></td>
                        <td><%= album%></td>
<!--                        <td><a href='search_filter.jsp?id="<%= songId%>"'><img src='images/buttons/play.png' width='30' height='30' style="filter: brightness(0) invert(1);"></a></td>-->
                          <td>
                            <audio controls>
                                <source src="songs/<%= songFilePath%>" type="audio/mp3">
                                Your browser does not support the audio element.
                            </audio>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <%
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        %>



                     
       
</body>
</html>
