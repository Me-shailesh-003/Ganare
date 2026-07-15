<%-- 
    Document   : edit_data
    Created on : 06-Feb-2024, 1:40:32 pm
    Author     : hp
--%>

<%@page import="com.ganare.dbconnection.MyConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Songs</title>
        
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Lexend:wght@500&display=swap');

            body {
                font-family: 'Lexend', sans-serif;
                margin: 0;
                padding: 0;
                height: 100vh;
                background-color: #130444;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .container {
                max-width: 1100px;
                width: 60%;
                height: 80%;
                margin-left: 8%;
                background-color: white;
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
                overflow: hidden;
                padding: 20px;
            }

            .form-content {
                display: flex;
                flex-wrap: wrap;
            }

            .form-left,
            .form-right {
                flex: 5;
                box-sizing: border-box;
                padding:5px;
            }

            .form-right {
                padding-left:80px;
            }


            form {
                max-width: 50%;
                
                display: flex;
                flex-wrap: wrap;
                margin-left: 180px;
                padding-left: 75px;
            }

            label {
                display: block;
                margin-top: 10px;
            }

            input, select {
                width: calc(125% - 20px);
                padding: 10px;
                margin-top: 5px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
            }

            h4 {
                font-family: 'Lexend', sans-serif;
                padding-top: 2px;
                text-align: center;
                font-size: 15px;
                color: rgb(11, 1, 1);
            }

            button {
                background-color: #040e1a;
                color: white;
                padding: 10px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                width: 100%;
                font-size: 16px;
            }

            button:hover {
                background-color: #130444;
            }

            .imglogo {
                text-align: center;
                margin-top: 40%;
                margin-left: -62%;
            }

            img {
                width: 13%;
                height: auto;
            }

            p {
                color: white;
                margin-top: 10px;
            }


        </style>
    </head>
    <body>
        <%
            try {
                String id = request.getParameter("id");

                Connection cn = MyConnection.createConnection();
                Statement smt = cn.createStatement();
                ResultSet rs = smt.executeQuery("select * from song where id=" + id);
                while (rs.next()) {

                    String song_name = rs.getString(2);
                    String singer_name = rs.getString(3);
                    String language = rs.getString(4);
                    String release_year = rs.getString(5);
                    String album_name = rs.getString(6);
                    String image_name = rs.getString(7);
                    String audio_name = rs.getString(8);

        %>
        <div class="container">
            <h4> Please Edit Carefully... <h4>
                    <form action="Update_Edited_Data">

                        <input type="text" name="id" value="<%= id%>" readonly>
                        <input type="text" name="song_name" value="<%= song_name%>" placeholder="Enter song name">
                        <input type="text" name="singer_name" value="<%= singer_name%>" placeholder="Enter singer name">
                        <input type="text" name="language" value="<%= language%>" placeholder="Enter language">
                        <input type="text" name="release_year" value="<%= release_year%>" placeholder="Enter release year">
                        <input type="text" name="album_name" value="<%= album_name%>" placeholder="Enter album name">
                        <input type="text" name="image_name" value="<%= image_name%>" placeholder="Enter image name">
                        <input type="text" name="audio_name" value="<%= audio_name%>" placeholder="Enter audio name">

                        <button type="submit"  >Update Data</button>

                    </form>
                    <div>

                        <%
                                }

                                cn.close();
                            } catch (Exception e) {
                                out.println(e.getMessage());
                            }

                        %>



                        </body>
                        </html>
