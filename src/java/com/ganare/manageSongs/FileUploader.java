/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ganare.manageSongs;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.*;
import org.apache.commons.fileupload.servlet.*;

public class FileUploader extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        int maxFileSize = 17000 * 1024; 
        int maxMemSize = 17000 * 1024; 
        String audioFilePath = "D:" + File.separator + "Universal Web Project" + File.separator + "Ganare" + File.separator + "web" + File.separator + "songs";
        String imageFilePath = "D:" + File.separator + "Universal Web Project" + File.separator + "Ganare" + File.separator + "web" + File.separator + "images"+ File.separator + "Songs_image";

        String contentType = request.getContentType();

        if (contentType != null && contentType.indexOf("multipart/form-data") >= 0) {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(maxMemSize);
            factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setSizeMax(maxFileSize);

            try {
                List<FileItem> fileItems = upload.parseRequest(request);
                Iterator<FileItem> i = fileItems.iterator();

                out.println("<html>");
                out.println("<body>");

                while (i.hasNext()) {
                    FileItem fi = i.next();
                    if (!fi.isFormField()) {
                        String fieldName = fi.getFieldName();
                        String fileName = fi.getName();
                        boolean isInMemory = fi.isInMemory();
                        long sizeInBytes = fi.getSize();

                        if (fileName.toLowerCase().endsWith(".mp3") || fileName.toLowerCase().endsWith(".wav")) {
                            File audioFile = new File(audioFilePath, fileName);
                            fi.write(audioFile);

                            HttpSession hs = request.getSession(true);
                            hs.setAttribute("audio_filename", fileName);
                        } 
                        
                        else if (fileName.toLowerCase().endsWith(".jpg") || fileName.toLowerCase().endsWith(".jpeg") || fileName.toLowerCase().endsWith(".png")) {
                            File imageFile = new File(imageFilePath, fileName);
                            fi.write(imageFile);

                            HttpSession hs = request.getSession(true);
                            hs.setAttribute("image_filename", fileName);
                        } else {
                            out.println("Invalid file type. Please upload an mp3, wav, jpg, or png file.<br>");
                        }
                    }
                }

                out.println("</body>");
                out.println("</html>");

            } catch (Exception ex) {
                out.println("<html>");
                out.println("<body>");
                out.println("<p>Error uploading file: " + ex.getMessage() + "</p>");
                out.println("</body>");
                out.println("</html>");
            }
        } else {
            out.println("<html>");
            out.println("<body>");
            out.println("<p>No file uploaded</p>");
            out.println("</body>");
            out.println("</html>");
        }

        RequestDispatcher rd = request.getRequestDispatcher("Add_Songs");
        rd.forward(request, response);
    }
}
