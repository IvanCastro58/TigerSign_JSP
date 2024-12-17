package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.time.ZoneId;
import java.time.ZonedDateTime;

import java.util.Map;

public class AuditLoggerSuperAdmin {

    public static void logActivity(String userEmail, String activity, Map<String, String> details) {
        int userId = getSuperAdminId(userEmail);
        if (userId != -1) {
            Connection connection = null;
            try {
                connection = DatabaseConnection.getConnection();
                connection.setAutoCommit(false);

                int auditId = insertAudit(connection, activity, userId);

                if (auditId != -1) {
                    insertAuditDetails(connection, auditId, details);
                }

                connection.commit();
            } catch (SQLException e) {
                if (connection != null) {
                    try {
                        connection.rollback();
                    } catch (SQLException rollbackEx) {
                        rollbackEx.printStackTrace();
                    }
                }
                e.printStackTrace();
            } finally {
                if (connection != null) {
                    try {
                        connection.setAutoCommit(true);
                        connection.close();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }
            }
        } else {
            System.out.println("Super Admin ID not found for email: " + userEmail);
        }
    }

    private static int insertAudit(Connection connection, String activity, int userId) throws SQLException {
        String insertQuery = "INSERT INTO TS_AUDIT (ACTIVITY_TYPE, ACTIVITY_DATETIME, SUPER_ADMIN_ID) VALUES (?, ?, ?)";
        try (PreparedStatement preparedStatement = connection.prepareStatement(insertQuery, new String[] {"ID"})) {
            preparedStatement.setString(1, activity);
            ZonedDateTime phtTime = ZonedDateTime.now(ZoneId.of("Asia/Manila"));
            preparedStatement.setTimestamp(2, Timestamp.valueOf(phtTime.toLocalDateTime()));
            preparedStatement.setInt(3, userId);

            int rowsAffected = preparedStatement.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        }
        return -1;
    }

    private static void insertAuditDetails(Connection connection, int auditId, Map<String, String> details) throws SQLException {
        String detailInsertQuery = "INSERT INTO TS_AUDIT_DETAILS (AUDIT_ID, DETAIL_KEY, DETAIL_VALUE) VALUES (?, ?, ?)";
        try (PreparedStatement detailStatement = connection.prepareStatement(detailInsertQuery)) {
            for (Map.Entry<String, String> entry : details.entrySet()) {
                detailStatement.setInt(1, auditId);
                detailStatement.setString(2, entry.getKey());
                detailStatement.setString(3, entry.getValue());
                detailStatement.addBatch();
            }
            detailStatement.executeBatch();
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
