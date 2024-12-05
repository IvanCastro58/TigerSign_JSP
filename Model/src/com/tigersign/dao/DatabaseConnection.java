package com.tigersign.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import java.sql.Connection;
import java.sql.ResultSet;
 
import java.sql.Statement;
 
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import javax.sql.DataSource;
import javax.sql.PooledConnection;

public class DatabaseConnection {

//private static final String JDBC_URL = "jdbc:oracle:thin:@//localhost:1521/orcl";
//private static final String USERNAME = "system";
//private static final String PASSWORD = "123";
private static final String JDBC_URL = "jdbc:oracle:thin:@ustrac-scan.ust.edu.ph:1521/USTPRD.ust.edu.ph";
private static final String USERNAME = "REG_ADM";
private static final String PASSWORD = "reg_adm";
        
    PooledConnection conn;
    static DataSource ds = null;

    public static Connection getConnection() throws SQLException {
        
//        try {
//            Context ic = new InitialContext();
//            ds = (DataSource)ic.lookup("jdbc/reg_admDS");
//        } catch (NamingException ne) {
//            System.err.println(ne.getMessage());
//        }
//        return ds.getConnection();
        
        return DriverManager.getConnection(JDBC_URL, USERNAME, PASSWORD);
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
