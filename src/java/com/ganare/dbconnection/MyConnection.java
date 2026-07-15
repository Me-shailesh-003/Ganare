/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ganare.dbconnection;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author hp
 */
public class MyConnection {
    
   public static Connection createConnection()
    { 
        Connection cn = null;
        
        
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            String dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/gana_bajao";
            String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "shailesh";
            String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "";
            cn=DriverManager.getConnection(dbUrl, dbUser, dbPass);
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        return cn;
        
    }
    
}
