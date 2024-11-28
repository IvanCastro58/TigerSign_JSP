package com.tigersign.servlet;

import com.tigersign.dao.AuditLogger;
import com.tigersign.dao.AuditLoggerSuperAdmin;
import com.tigersign.dao.DatabaseConnection;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateStatusServlet")
public class UpdateStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String requestId = request.getParameter("requestId");
        String newStatus = request.getParameter("newStatus");
        String reason = request.getParameter("reason"); 
        String adminEmail = (String) request.getSession().getAttribute("adminEmail"); 
        String userEmail = (String) request.getSession().getAttribute("userEmail");

        String updateQuery = "UPDATE TS_REQUEST SET FILE_STATUS = ?, ON_HOLD_REASON = ?, " +
                             "DATE_ON_HOLD = CASE WHEN ? = 'HOLD' THEN SYSDATE ELSE DATE_ON_HOLD END, " +
                             "DATE_AVAILABLE = CASE WHEN ? = 'AVAILABLE' THEN SYSDATE ELSE DATE_AVAILABLE END, " +
                             "DATE_PROCESSING = CASE WHEN ? = 'PROCESSING' THEN SYSDATE ELSE DATE_PROCESSING END " +
                             "WHERE REQUEST_ID = ?";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(updateQuery)) {

            pstmt.setString(1, newStatus);
            pstmt.setString(2, reason);
            pstmt.setString(3, newStatus);
            pstmt.setString(4, newStatus);
            pstmt.setString(5, newStatus);
            pstmt.setString(6, requestId);

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.getWriter().write("Status updated successfully");

                String orNumber = null;
                String requestData = null;
                String selectQuery = "SELECT OR_NUMBER, REQUESTS FROM TS_REQUEST WHERE REQUEST_ID = ?";
                try (PreparedStatement selectPstmt = connection.prepareStatement(selectQuery)) {
                    selectPstmt.setString(1, requestId);
                    ResultSet rs = selectPstmt.executeQuery();
                    if (rs.next()) {
                        orNumber = rs.getString("OR_NUMBER");
                        requestData = rs.getString("REQUESTS");
                    }
                }

                if (orNumber != null) {
                    String activity = "Updated status of O.R. Number " + orNumber + " to " + newStatus + " (Request: " + requestData + ")";
                    if (adminEmail != null) {
                        AuditLogger.logActivity(adminEmail, activity);
                    } else if (userEmail != null) {
                        AuditLoggerSuperAdmin.logActivity(userEmail, activity);
                    }
                }
            } else {
                response.getWriter().write("Status not updated. No matching record found.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("Error updating status: " + e.getMessage());
        }
    }
}
