/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ganare.manageSongs;

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

/**
 *
 * @author hp
 */
public class Update_Edited_Data extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter pw = response.getWriter();
        try {
            String id = request.getParameter("id");
            String song_name = request.getParameter("song_name");
            String singer_name = request.getParameter("singer_name");
            String language = request.getParameter("language");
            String release_year = request.getParameter("release_year");
            String album_name = request.getParameter("album_name");
            String image_fileName = request.getParameter("image_name");
            String audio_fileName = request.getParameter("audio_name");


            Connection cn = MyConnection.createConnection();

            Statement smt = cn.createStatement();

            int i = smt.executeUpdate("UPDATE song SET song_name='" + song_name + "', singer_name='" + singer_name + "', language='" + language + "', release_year='" + release_year + "', album_name='" + album_name + "' , image_fileName='" + image_fileName + "' , audio_fileName='" + audio_fileName + "' WHERE id=" + id);

            if (i > 0) {

                RequestDispatcher rd = request.getRequestDispatcher("admin_home.jsp");
                rd.forward(request, response);

            }

            cn.close();
        } catch (Exception e) {
            pw.println(e.getMessage());
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
