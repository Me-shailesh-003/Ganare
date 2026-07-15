package com.ganare.userManagement;

import com.ganare.dbconnection.MyConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
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
public class ManageUser extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {

            System.out.println("This is working");
            String userId = request.getParameter("id");

            Connection cn = MyConnection.createConnection();

            Statement smt = cn.createStatement();
            // delete child table records first
            // <-- FIXED: use the child column that references user_info(id). The FK in your error was on user_playlists.id
            smt.executeUpdate("DELETE FROM user_playlists WHERE id=" + userId);

            // then delete from parent table
            int i = smt.executeUpdate("DELETE FROM user_info WHERE id=" + userId);

            if (i > 0) {

                RequestDispatcher rd = request.getRequestDispatcher("admin_home.jsp");
                rd.forward(request, response);

            }

            cn.close();
        } catch (Exception e) {
            out.println(e.getMessage());
        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
