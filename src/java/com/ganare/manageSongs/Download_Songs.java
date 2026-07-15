package com.ganare.manageSongs;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Download_Songs extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        
        
        try {
            String audio=request.getParameter("audioName");
//            System.out.println("hello  valueeeeeee " +audio);
            audio = audio.replaceAll("\"", "");
            response.setContentType("application/octet-stream");
            String filename = audio;
            String filepath = "D:\\Universal Web Project\\Ganare\\web\\songs\\";

            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

            try (FileInputStream fileInputStream = new FileInputStream(filepath + filename);
                 OutputStream out = response.getOutputStream()) {

                byte[] buffer = new byte[4096];
                int bytesRead;

                while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
        } catch (Exception e) {
            System.out.println("valueeeeeeeee " + e.getMessage());
        }
    }

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
        return "Download Servlet";
    }
}
