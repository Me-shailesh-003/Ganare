package com.ganare.userManagement;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import com.ganare.dbconnection.MyConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class User_login extends HttpServlet {

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
            String email = request.getParameter("mail");
            String password = request.getParameter("pwd");
            
           

            Connection cn = MyConnection.createConnection();

            Statement smt = cn.createStatement();

            ResultSet rs = smt.executeQuery("select * from user_info where email='" + email + "' and binary password='" + password + "'");

            if (rs.next()) {
                String id = rs.getString("id");
                String name = rs.getString("name");
                HttpSession hs = request.getSession(true);
                hs.setAttribute("userId", id);
                hs.setAttribute("name", name);
                hs.setAttribute("email", email);
                hs.setAttribute("pwd", password);
                
                      
                hs.setAttribute("role", "user");

                RequestDispatcher rd = request.getRequestDispatcher("user_home.jsp");

                rd.forward(request, response);

            } else {

                RequestDispatcher rd = request.getRequestDispatcher("index.html");
                rd.include(request, response);

                out.println("<script>showUserMessage();</script>");
//   out.println("<div  style='margin-left: 20%; margin-bottom: 30%; color: red;'><h4 > Email or Password not matched!!   </h4></div>"); 

            }

            cn.close();
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
