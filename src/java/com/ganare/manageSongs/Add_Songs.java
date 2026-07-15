package com.ganare.manageSongs;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import com.ganare.dbconnection.MyConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author hp
 */
public class Add_Songs extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {

            HttpSession hs = request.getSession(false);

            if (hs != null) {
                String songname = (String) hs.getAttribute("songname");
                String singername = (String) hs.getAttribute("singername");
                String releaseyear = (String) hs.getAttribute("releaseyear");
                String albumname = (String) hs.getAttribute("albumname");
                String language = (String) hs.getAttribute("language");
                String audio_filename = (String) hs.getAttribute("audio_filename");
                String image_filename = (String) hs.getAttribute("image_filename");


                Connection cn = MyConnection.createConnection();

                Statement smt = cn.createStatement();

                int i = smt.executeUpdate("insert into song (song_name, singer_name, language, release_year, album_name, image_filename, audio_filename) values ('" + songname + "', '" + singername + "', '" + language + "', " + releaseyear + ", '" + albumname + "', '" + image_filename + "', '" + audio_filename + "')");

                if (i > 0) {

                    RequestDispatcher rd = request.getRequestDispatcher("admin_home.jsp");
                    rd.forward(request, response);

                }
                cn.close();
            } else {

                out.println("Session is not available. Please check !.");
            }
        } catch (Exception e) {
            out.println(e.getMessage());
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
