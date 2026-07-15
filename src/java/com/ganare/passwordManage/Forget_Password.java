package com.ganare.passwordManage;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author hp
 */
public class Forget_Password extends HttpServlet {

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
        PrintWriter out = response.getWriter();
        try {
            String to = request.getParameter("mail");

            String from = "meshailesh003@gmail.com";
            String pwd = "sxrl icjv fhld tgvo";

            String sub = "Reset Your Password";
            String msg = "Please click the link below to reset your password.";
            String content = "<div style=' font-family: Arial, sans-serif; text-align: center;'>"
                    + "<h2 style='color: hsl(0deg 0% 7.06%);'>No need to worry!</h2>"
                    + "<p>You can reset your <b>Ganare</b> password by clicking the link below:</p>"
                    + "<p style='margin: 20px 0;'><a href='http://localhost:8080/Ganare/update_password.jsp?mail=" + to + "' style='background-color: black; color: white; padding: 10px 15px; text-decoration: none; border-radius: 5px;'>Reset Password</a></p>"
                    + "<p>If you didn't request a password reset, feel free to delete this email and carry on enjoying your music!</p>"
                    + "<p>All the best,<br/>Your Music Team</p>"
                    + "</div>";

            Mailer.send(to, sub, msg, content);
            response.sendRedirect("email_send_msg.html");
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
