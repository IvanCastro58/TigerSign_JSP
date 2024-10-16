package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RequestDAO {
    public void updateClaimedStatus(String orNumber, String feeName) throws SQLException {
        String sql = "UPDATE TS_REQUEST SET IS_CLAIMED = 'Y' WHERE OR_NUMBER = ? AND FEE_NAME = ?";
        try (Connection conn = DatabaseConnection.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, orNumber);
            stmt.setString(2, feeName);
            stmt.executeUpdate();
        }
    }
}


//public class RequestDAO {
//    public void updateClaimedStatus(String transactionId) throws SQLException {
//        String sql = "UPDATE TS_REQUEST SET is_claimed = 'Y' WHERE transaction_id = ?";
//        try (Connection conn = DatabaseConnection.getConnection(); 
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            
//            stmt.setString(1, transactionId);
//            stmt.executeUpdate();
//        }
//    }
//}