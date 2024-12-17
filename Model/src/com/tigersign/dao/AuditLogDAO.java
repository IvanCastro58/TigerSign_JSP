package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;

import java.util.ArrayList;
import java.util.List;

public class AuditLogDAO {

    public List<AuditLog> getAllAudits() throws SQLException {
        List<AuditLog> auditList = new ArrayList<>();
        String query = "SELECT a.ID, a.ACTIVITY_TYPE, a.ACTIVITY_DATETIME, " +
                       "CASE WHEN a.ADMIN_ID IS NOT NULL THEN a.ADMIN_ID ELSE a.SUPER_ADMIN_ID END AS USER_ID, " +
                       "CASE WHEN a.ADMIN_ID IS NOT NULL THEN admin.FIRSTNAME ELSE superadmin.FIRSTNAME END AS FIRSTNAME, " +
                       "CASE WHEN a.ADMIN_ID IS NOT NULL THEN admin.LASTNAME ELSE superadmin.LASTNAME END AS LASTNAME, " +
                       "CASE WHEN a.ADMIN_ID IS NOT NULL THEN admin.POSITION ELSE 'SUPER ADMIN' END AS POSITION, " +
                       "CASE WHEN a.ADMIN_ID IS NOT NULL THEN admin.PICTURE ELSE superadmin.PICTURE END AS PICTURE, " +
                       "CASE WHEN a.ADMIN_ID IS NOT NULL THEN admin.STATUS ELSE 'ACTIVE' END AS STATUS " +
                       "FROM TS_AUDIT a " +
                       "LEFT JOIN TS_ADMIN admin ON a.ADMIN_ID = admin.ID " +
                       "LEFT JOIN TS_SUPERADMIN superadmin ON a.SUPER_ADMIN_ID = superadmin.ID " +
                       "WHERE (a.ADMIN_ID IS NOT NULL OR a.SUPER_ADMIN_ID IS NOT NULL) " +
                       "AND a.IS_ARCHIVE = 'N' " +
                       "ORDER BY a.ACTIVITY_DATETIME DESC";

        // Calculate the cutoff date for archiving (10 years ago from now)
        ZonedDateTime now = ZonedDateTime.now(ZoneId.of("Asia/Manila"));
        LocalDateTime cutoffDate = now.minusYears(10).toLocalDateTime();

        String archiveQuery = "UPDATE TS_AUDIT SET IS_ARCHIVE = 'Y' WHERE ACTIVITY_DATETIME < ? AND IS_ARCHIVE = 'N'";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement archiveStmt = connection.prepareStatement(archiveQuery)) {

            archiveStmt.setTimestamp(1, Timestamp.valueOf(cutoffDate));
            archiveStmt.executeUpdate();
        }

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                AuditLog audit = new AuditLog();
                audit.setId(rs.getInt("ID"));
                audit.setActivity(rs.getString("ACTIVITY_TYPE"));
                audit.setActivityDateTime(rs.getTimestamp("ACTIVITY_DATETIME"));
                audit.setAdminId(rs.getInt("USER_ID"));
                audit.setFirstName(rs.getString("FIRSTNAME"));
                audit.setLastName(rs.getString("LASTNAME"));
                audit.setPosition(rs.getString("POSITION"));
                audit.setPicture(rs.getString("PICTURE"));
                audit.setStatus(rs.getString("STATUS"));

                String detailsQuery = "SELECT DETAIL_KEY, DETAIL_VALUE FROM TS_AUDIT_DETAILS WHERE AUDIT_ID = ?";
                try (PreparedStatement detailsStmt = connection.prepareStatement(detailsQuery)) {
                    detailsStmt.setInt(1, audit.getId());
                    ResultSet detailsRs = detailsStmt.executeQuery();
                    while (detailsRs.next()) {
                        String detailKey = detailsRs.getString("DETAIL_KEY");
                        String detailValue = detailsRs.getString("DETAIL_VALUE");
                        audit.addAuditDetail(detailKey, detailValue);
                    }
                }

                auditList.add(audit);
            }
        }
        return auditList;
    }
}
