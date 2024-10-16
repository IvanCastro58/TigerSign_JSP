package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ClaimerDAO {

    // Method to insert a claimer into the TS_CLAIMER table
    public int insertClaimer(String customerName, String email, String role) throws SQLException {
        int claimerId = -1; // Default value to indicate failure
        String sql = "INSERT INTO TS_CLAIMER (name, email, role) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, new String[]{"claimer_id"})) { // Specify column name to return

            stmt.setString(1, customerName);
            stmt.setString(2, email);
            stmt.setString(3, role);

            // Execute the insert statement
            int affectedRows = stmt.executeUpdate();

            // If the insert was successful
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        // Retrieve generated key as an int
                        claimerId = rs.getInt(1); // Or use rs.getLong(1) if your identity column is of type BIGINT
                    }
                }
            }
        }

        if (claimerId <= 0) {
            throw new SQLException("Failed to retrieve the generated claimer_id.");
        }

        return claimerId;
    }
}

//public class ClaimerDAO {
//
//    // Method to insert a claimer into the TS_CLAIMER table
//    public int insertClaimer(String name, String email, String role) throws SQLException {
//        int claimerId = -1; // Default value to indicate failure
//        String sql = "INSERT INTO TS_CLAIMER (name, email, role) VALUES (?, ?, ?)";
//
//        try (Connection conn = DatabaseConnection.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql, new String[]{"claimer_id"})) { // Specify column name to return
//
//            stmt.setString(1, name);
//            stmt.setString(2, email);
//            stmt.setString(3, role);
//
//            // Execute the insert statement
//            int affectedRows = stmt.executeUpdate();
//
//            // If the insert was successful
//            if (affectedRows > 0) {
//                try (ResultSet rs = stmt.getGeneratedKeys()) {
//                    if (rs.next()) {
//                        // Retrieve generated key as an int
//                        claimerId = rs.getInt(1); // Or use rs.getLong(1) if your identity column is of type BIGINT
//                    }
//                }
//            }
//        }
//
//        if (claimerId <= 0) {
//            throw new SQLException("Failed to retrieve the generated claimer_id.");
//        }
//
//        return claimerId;
//    }
//}
