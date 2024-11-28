package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.time.ZoneId;
import java.time.ZonedDateTime;

public class AuditLoggerSuperAdmin {
    
    public static void logActivity(String userEmail, String activity) {
        int userId = getSuperAdminId(userEmail);
        if (userId != -1) { 
            String insertQuery = "INSERT INTO TS_AUDIT (ACTIVITY, ACTIVITY_DATETIME, SUPER_ADMIN_ID) VALUES (?, ?, ?)";
            try (Connection connection = DatabaseConnection.getConnection();
                 PreparedStatement preparedStatement = connection.prepareStatement(insertQuery)) {
                 
                preparedStatement.setString(1, activity);
                
                ZonedDateTime phtTime = ZonedDateTime.now(ZoneId.of("Asia/Manila"));
                preparedStatement.setTimestamp(2, Timestamp.valueOf(phtTime.toLocalDateTime()));
                
                preparedStatement.setInt(3, userId);
                preparedStatement.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("Admin ID not found for email: " + userEmail);
        }
    }

    private static int getSuperAdminId(String userEmail) {
        int adminId = -1;
        String query = "SELECT ID FROM TS_SUPERADMIN WHERE EMAIL = ?";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, userEmail);
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
