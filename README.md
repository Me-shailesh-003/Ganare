# GANARE – Where Melodies Reflect the Soul

GANARE is a web-based music player that allows users to play, search, and manage songs through playlists. It features user authentication, admin control, playlist creation, and a custom music player built with Java, JSP, Servlets, and MySQL.

## Features

- User login, registration, and password recovery
- Music player with play, pause, next, previous, and download features
- Browse all songs and search by song name, artist, or language
- Create and manage user playlists
- Admin dashboard for adding, editing, and deleting songs and playlists
- Artist-specific playlists managed by the admin

## Tech Stack

Servlets · JavaServer Pages (JSP) · advance java · Exception Management · Web Applications · collection framework · Java Database Connectivity (JDBC) · MySQL · Netbeans Platform · HTML5 · Cascading Style Sheets (CSS) · JavaScript  ·  JavaMail (for password reset) 

## Pages & Flow

### User

- `index.jsp`: Landing page with login form, registration, and forgot password links
- `user_home.jsp`: Main dashboard with tabs: All Songs, Artist Playlists, Your Playlist, About Us, Contact
- Music cards fetched from Database and played in a bottom music player
- Playlists stored and loaded dynamically using `playlist.sql`
- Song search functionality using filters

### Admin

- `admin_home.jsp`: Dashboard with tabs for managing songs and playlists
- Add, edit, delete songs and playlists
- Upload song files and metadata
- Admin managed all Admin Playlist Activities

## How to Run

1. Import the project into an IDE like Netbeans or Eclipse 
2. Set up MySQL and import provided `.sql` files (Please Contact me for the DATABASE FILES)
3. Configure database connection in `MyConnection.java`
4. Deploy the project on a servlet container (Tomcat)
5. Open `http://localhost:8080/ganare/` in your browser

## Author

Developed by :  Shailesh Parmar
Contact : meshailesh003@gmail.com

