package com.tigersign.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    //private static final String JDBC_URL = "jdbc:oracle:thin:@localhost:1521:ORCL";
    private static final String JDBC_URL = "jdbc:oracle:thin:@localhost:1521:ORCLDB";
    private static final String DB_USER = "system";
    private static final String DB_PASSWORD = "sys123";

    static {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace(); // Consider logging the error
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
    }
}
