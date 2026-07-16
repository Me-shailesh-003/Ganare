<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Create Playlist</title>
</head>
<body>

<%
    String playlistName = request.getParameter("playlistName");
    String email = (String) session.getAttribute("email");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/gana_bajao"; String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "shailesh"; String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : ""; Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        // Get user ID based on email
        PreparedStatement getIdStmt = cn.prepareStatement("SELECT id FROM user_info WHERE email = ?");
        getIdStmt.setString(1, email);
        ResultSet rs = getIdStmt.executeQuery();

        if (rs.next()) {
            String userId = rs.getString("id");

            // Insert playlist into user_playlists
            PreparedStatement insertStmt = cn.prepareStatement("INSERT INTO user_playlists (id, name) VALUES (?, ?)");
            insertStmt.setString(1, userId);
            insertStmt.setString(2, playlistName);
            insertStmt.executeUpdate();

            session.setAttribute("userId", userId );
            session.setAttribute("playlistName", playlistName);
            response.sendRedirect("add_songs.jsp");
        } else {
            out.println("User not found.");
        }

        cn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

</body>
</html>
