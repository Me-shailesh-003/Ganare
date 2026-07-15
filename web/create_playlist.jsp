<%--
    Document   : playlist
    Created on : Feb 2, 2024, 11:41:31 PM
    Author     : Jitendra
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Playlist</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Arial', sans-serif;
        }

        body {
            background: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background: #ffffff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            width: 380px;
            text-align: center;
            transition: all 0.3s ease-in-out;
        }

        .container:hover {
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
        }

        h2 {
            color: #333;
            margin-bottom: 15px;
        }

        label {
            font-size: 14px;
            font-weight: bold;
            color: #555;
            display: block;
            text-align: left;
            margin-bottom: 5px;
        }

        input[type="text"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
            transition: 0.3s;
        }

        input[type="text"]:focus {
            border-color: #007BFF;
            outline: none;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.2);
        }

        button {
            background: #007BFF;
            color: white;
            border: none;
            padding: 12px;
            cursor: pointer;
            border-radius: 5px;
            width: 100%;
            font-size: 16px;
            font-weight: bold;
            transition: 0.3s;
        }

        button:hover {
            background: #0056b3;
        }

        #playlist-container {
            margin-top: 20px;
            text-align: left;
        }

        h3 {
            color: #333;
            font-size: 18px;
            margin-bottom: 10px;
        }

        ul {
            list-style: none;
            padding: 0;
        }

        ul li {
            background: #e9ecef;
            padding: 10px;
            margin: 5px 0;
            border-radius: 5px;
            font-size: 14px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: 0.3s;
        }

        ul li:hover {
            background: #d6d6d6;
        }

        a {
            display: block;
            margin-top: 15px;
            text-decoration: none;
            color: #007BFF;
            font-weight: bold;
            transition: 0.3s;
        }

        a:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>
    <div class="container">
        <form action="playlist_db.jsp" method="post">
            <h2>Create Playlist</h2>

            <label for="playlist-name">Playlist Name:</label>
            <input type="text" id="playlist-name" name="playlistName" placeholder="Enter playlist name">

             <button type="submit">Add Playlist</button>
         
              
        </form>
    </div>

   
</body>
</html>
