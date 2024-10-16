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
        String query = "SELECT a.ID, a.ACTIVITY, a.ACTIVITY_DATETIME, a.ADMIN_ID, "
                     + "admin.FIRSTNAME, admin.LASTNAME, admin.POSITION, admin.PICTURE "
                     + "FROM TS_AUDIT a "
                     + "JOIN TS_ADMIN admin ON a.ADMIN_ID = admin.ID";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                AuditLog audit = new AuditLog();
                audit.setId(rs.getInt("ID"));
                audit.setActivity(rs.getString("ACTIVITY"));
                audit.setActivityDateTime(rs.getTimestamp("ACTIVITY_DATETIME"));
                audit.setAdminId(rs.getInt("ADMIN_ID"));
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
