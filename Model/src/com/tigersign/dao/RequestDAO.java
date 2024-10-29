package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RequestDAO {
    public void updateClaimedStatus(String requestId) throws SQLException {
        String sql = "UPDATE TS_REQUEST SET IS_CLAIMED = 'Y', FILE_STATUS = 'CLAIMED' WHERE REQUEST_ID = ?";
        try (Connection conn = DatabaseConnection.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, requestId);
            stmt.executeUpdate();
        }
    }
}
