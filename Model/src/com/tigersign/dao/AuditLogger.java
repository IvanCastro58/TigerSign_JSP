package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.time.ZoneId;
import java.time.ZonedDateTime;

public class AuditLogger {
    
    public static void logActivity(String adminEmail, String activity) {
        int adminId = getAdminId(adminEmail);
        if (adminId != -1) { // Check if adminId is valid
            String insertQuery = "INSERT INTO TS_AUDIT (ACTIVITY, ACTIVITY_DATETIME, ADMIN_ID) VALUES (?, ?, ?)";
            try (Connection connection = DatabaseConnection.getConnection();
                 PreparedStatement preparedStatement = connection.prepareStatement(insertQuery)) {
                 
                preparedStatement.setString(1, activity);
                
                ZonedDateTime phtTime = ZonedDateTime.now(ZoneId.of("Asia/Manila"));
                preparedStatement.setTimestamp(2, Timestamp.valueOf(phtTime.toLocalDateTime()));
                
                preparedStatement.setInt(3, adminId);
                preparedStatement.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("Admin ID not found for email: " + adminEmail);
        }
    }

    // Method to get admin ID by email
    private static int getAdminId(String adminEmail) {
        int adminId = -1;
        String query = "SELECT ID FROM TS_ADMIN WHERE EMAIL = ?";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, adminEmail);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                adminId = resultSet.getInt("ID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return adminId;
    }
}
