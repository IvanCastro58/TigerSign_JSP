package com.tigersign.dao;

import java.sql.*;
import java.util.*;
import java.text.SimpleDateFormat;
import oracle.jdbc.OracleTypes;

public class PendingClaimsService {
    public List<PendingClaim> getActivePendingClaims() throws SQLException {
        List<PendingClaim> claims = new ArrayList<>();
        String query = "BEGIN ? := TIGERSIGNX_PKG.GET_TRANSACTION_DET(?, TO_DATE(?, 'DD-MON-YYYY'), TO_DATE(?, 'DD-MON-YYYY')); END;";

        try (Connection connection = DatabaseConnection.getConnection();
             CallableStatement stmt = connection.prepareCall(query)) {
            
            stmt.registerOutParameter(1, OracleTypes.CURSOR);
            stmt.setString(2, null); 
            stmt.setString(3, "01-JAN-2011");
            stmt.setString(4, "05-JAN-2011");

            stmt.execute();

            try (ResultSet rs = (ResultSet) stmt.getObject(1)) {
                while (rs.next()) {
                    String status = rs.getString("STATUS");
                    if ("ACTIVE".equals(status)) {
                        String orNumber = rs.getString("OR_NUMBER");
                        String customerName = rs.getString("CUSTOMER_NAME");
                        String dateProcessedStr = rs.getString("DATE_PROCESSED");
                        Timestamp dateProcessed = null;

                        if (dateProcessedStr != null) {
                            try {
                                SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
                                dateProcessed = new Timestamp(dateFormat.parse(dateProcessedStr).getTime());
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }

                        String college = rs.getString("FIN_COST_CENTER");
                        String feeName = rs.getString("FEE_NAME");
                        claims.add(new PendingClaim(orNumber, customerName, dateProcessed, college, feeName));
                    }
                }
            }
        }

        return claims;
    }
    
    public void insertPendingClaims(List<PendingClaim> pendingClaims) throws SQLException {
        String existingQuery = "SELECT OR_NUMBER FROM TS_REQUEST";
        
        Set<String> existingOrNumbers = new HashSet<>();
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement existingStmt = connection.prepareStatement(existingQuery);
             ResultSet existingRs = existingStmt.executeQuery()) {

            while (existingRs.next()) {
                existingOrNumbers.add(existingRs.getString("OR_NUMBER"));
            }
        }

        Map<String, Set<String>> orNumberFeeMap = new HashMap<>();

        for (PendingClaim claim : pendingClaims) {
            orNumberFeeMap
                .computeIfAbsent(claim.getOrNumber(), k -> new HashSet<>())
                .add(claim.getFeeName());
        }

        // Updated insert query to include CUSTOMER_NAME, COLLEGE, and DATE_PROCESSED
        String insertQuery = "INSERT INTO TS_REQUEST (OR_NUMBER, FILE_STATUS, DATE_AVAILABLE, IS_CLAIMED, FEE_NAME, DATE_PROCESSING, CUSTOMER_NAME, COLLEGE, PAYMENT_DATE) "
                            + "VALUES (?, 'PENDING', NULL, 'N', ?, NULL, ?, ?, ?, ?)";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(insertQuery)) {

            for (PendingClaim claim : pendingClaims) {
                String orNumber = claim.getOrNumber();
                String feeName = claim.getFeeName();
                String customerName = claim.getCustomerName();
                String college = claim.getCollege();
                Timestamp dateProcessed = claim.getDateProcessed();  // Retrieve the date processed

                if (!existingOrNumbers.contains(orNumber)) {
                    pstmt.setString(1, orNumber); 
                    pstmt.setString(2, feeName); 
                    pstmt.setString(3, customerName);
                    pstmt.setString(4, college);
                    pstmt.setTimestamp(5, dateProcessed);  // Set the dateProcessed here
                    pstmt.addBatch();
                }
            }

            pstmt.executeBatch();
        }
    }
    
    public String getFileStatus(String orNumber, String feeName) throws SQLException {
        String status = null;
        String query = "SELECT FILE_STATUS FROM TS_REQUEST WHERE OR_NUMBER = ? AND FEE_NAME = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setString(1, orNumber);
            pstmt.setString(2, feeName);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                status = rs.getString("FILE_STATUS");
            }
        }
        return status;
    }
    
    public void updateFileStatus(String orNumber, String feeName, String fileStatus) throws SQLException {
        String updateQuery = "UPDATE TS_REQUEST SET FILE_STATUS = ?, " +
                             "DATE_AVAILABLE = CASE WHEN ? = 'AVAILABLE' THEN SYSDATE ELSE DATE_AVAILABLE END, " +
                             "DATE_PROCESSING = CASE WHEN ? = 'PROCESSING' THEN SYSDATE ELSE DATE_PROCESSING END " +
                             "WHERE OR_NUMBER = ? AND FEE_NAME = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(updateQuery)) {
            pstmt.setString(1, fileStatus);
            pstmt.setString(2, fileStatus); 
            pstmt.setString(3, fileStatus); 
            pstmt.setString(4, orNumber);
            pstmt.setString(5, feeName);
            pstmt.executeUpdate();
        }
    }
    
    public int getDaysSinceProcessing(String orNumber, String feeName) throws SQLException {
        String query = "SELECT DATE_PROCESSING FROM TS_REQUEST WHERE OR_NUMBER = ? AND FEE_NAME = ?";
        int days = 0;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setString(1, orNumber);
            pstmt.setString(2, feeName);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Timestamp dateProcessing = rs.getTimestamp("DATE_PROCESSING");
                if (dateProcessing != null) {
                    // Calculate the difference in days
                    long diffInMillis = System.currentTimeMillis() - dateProcessing.getTime();
                    days = (int) (diffInMillis / (1000 * 60 * 60 * 24)); // Convert milliseconds to days
                }
            }
        }

        return days;
    }

}


//public class PendingClaimsService {
//
//    public List<PendingClaim> getPendingClaims() {
//        List<PendingClaim> claimsList = new ArrayList<>();
//        String query = "SELECT id, transaction_id, name, email, status, college, date_processed, files FROM TS_REQUEST WHERE is_claimed = 'N'";
//
//        try (Connection connection = DatabaseConnection.getConnection();
//             Statement statement = connection.createStatement();
//             ResultSet resultSet = statement.executeQuery(query)) {
//
//            while (resultSet.next()) {
//                PendingClaim claim = new PendingClaim();
//                claim.setId(resultSet.getInt("id"));
//                claim.setTransactionId(resultSet.getString("transaction_id"));
//                claim.setName(resultSet.getString("name"));
//                claim.setEmail(resultSet.getString("email"));
//                claim.setStatus(resultSet.getString("status"));
//                claim.setCollege(resultSet.getString("college"));
//                claim.setDateProcessed(resultSet.getString("date_processed"));
//                claim.setFiles(resultSet.getString("files"));
//                claimsList.add(claim);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace(); 
//        }
//
//        return claimsList;
//    }
//    
//    public void updateClaimStatus(int id, String status) {
//          Connection connection = null;
//          PreparedStatement statement = null;
//
//          try {
//              connection = DatabaseConnection.getConnection();
//              String sql = "UPDATE TS_REQUEST SET status = ? WHERE id = ?";
//              statement = connection.prepareStatement(sql);
//              statement.setString(1, status);
//              statement.setInt(2, id);
//              statement.executeUpdate();
//          } catch (SQLException e) {
//              e.printStackTrace(); 
//          } finally {
//              try {
//                  if (statement != null) statement.close();
//                  if (connection != null) connection.close();
//              } catch (SQLException e) {
//                  e.printStackTrace(); 
//              }
//          }
//      }
//}

