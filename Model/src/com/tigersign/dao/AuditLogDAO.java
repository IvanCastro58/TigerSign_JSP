package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

public class AuditLogDAO {

    public List<AuditLog> getAllAudits() throws SQLException {
        List<AuditLog> auditList = new ArrayList<>();
        String query = "SELECT a.ID, a.ACTIVITY, a.ACTIVITY_DATETIME, " +
                       "CASE WHEN a.ADMIN_ID IS NOT NULL THEN a.ADMIN_ID ELSE a.SUPER_ADMIN_ID END AS USER_ID, " +
                       "CASE WHEN a.ADMIN_ID IS NOT NULL THEN admin.FIRSTNAME ELSE superadmin.FIRSTNAME END AS FIRSTNAME, " +
                       "CASE WHEN a.ADMIN_ID IS NOT NULL THEN admin.LASTNAME ELSE superadmin.LASTNAME END AS LASTNAME, " +
                       "CASE WHEN a.ADMIN_ID IS NOT NULL THEN admin.POSITION ELSE 'SUPER ADMIN' END AS POSITION, " +
                       "CASE WHEN a.ADMIN_ID IS NOT NULL THEN admin.PICTURE ELSE superadmin.PICTURE END AS PICTURE " +
                       "FROM TS_AUDIT a " +
                       "LEFT JOIN TS_ADMIN admin ON a.ADMIN_ID = admin.ID " +
                       "LEFT JOIN TS_SUPERADMIN superadmin ON a.SUPER_ADMIN_ID = superadmin.ID " +
                       "WHERE a.ADMIN_ID IS NOT NULL OR a.SUPER_ADMIN_ID IS NOT NULL " +
                       "ORDER BY a.ACTIVITY_DATETIME DESC";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                AuditLog audit = new AuditLog();
                audit.setId(rs.getInt("ID"));
                audit.setActivity(rs.getString("ACTIVITY"));
                audit.setActivityDateTime(rs.getTimestamp("ACTIVITY_DATETIME"));
                audit.setAdminId(rs.getInt("USER_ID"));
                audit.setFirstName(rs.getString("FIRSTNAME"));
                audit.setLastName(rs.getString("LASTNAME"));
                audit.setPosition(rs.getString("POSITION"));
                audit.setPicture(rs.getString("PICTURE"));

                auditList.add(audit);
            }
        }
        return auditList;
    }
}
