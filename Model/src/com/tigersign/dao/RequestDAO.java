package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RequestDAO {
    public void updateClaimedStatus(String transactionId) throws SQLException {
        String sql = "UPDATE TS_REQUEST SET is_claimed = 'Y' WHERE transaction_id = ?";
        try (Connection conn = DatabaseConnection.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, transactionId);
            stmt.executeUpdate();
        }
    }
}
