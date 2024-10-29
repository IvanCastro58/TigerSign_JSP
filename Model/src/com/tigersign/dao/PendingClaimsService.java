package com.tigersign.dao;

import java.sql.*;
import java.util.*;
import java.text.SimpleDateFormat;
import oracle.jdbc.OracleTypes;

public class PendingClaimsService {
//    public List<PendingClaim> getActivePendingClaims() throws SQLException {
//        List<PendingClaim> claims = new ArrayList<>();
//        String query = "BEGIN ? := TIGERSIGNX_PKG.GET_TRANSACTION_DET(?, TO_DATE(?, 'DD-MON-YYYY'), TO_DATE(?, 'DD-MON-YYYY')); END;";
//
//        try (Connection connection = DatabaseConnection.getConnection();
//             CallableStatement stmt = connection.prepareCall(query)) {
//
//            // Set up the parameters
//            stmt.registerOutParameter(1, OracleTypes.CURSOR);
//            stmt.setString(2, null);
//            stmt.setString(3, "01-JAN-2011");
//            stmt.setString(4, "05-JAN-2011");
//
//            stmt.execute();
//
//            try (ResultSet rs = (ResultSet) stmt.getObject(1)) {
//                while (rs.next()) {
//                    String status = rs.getString("STATUS");
//                    if ("ACTIVE".equals(status)) {
//                        String orNumber = rs.getString("OR_NUMBER");
//                        String customerName = rs.getString("CUSTOMER_NAME");
//                        String dateProcessedStr = rs.getString("DATE_PROCESSED");
//                        Timestamp dateProcessed = null;
//
//                        if (dateProcessedStr != null) {
//                            try {
//                                SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
//                                dateProcessed = new Timestamp(dateFormat.parse(dateProcessedStr).getTime());
//                            } catch (Exception e) {
//                                e.printStackTrace();
//                            }
//                        }
//
//                        String college = rs.getString("FIN_COST_CENTER");
//                        String feeName = rs.getString("FEE_NAME");
//                        String feeDesc = rs.getString("FEE_DESCRIPTION");
//
//                        // Fetch REQUEST_ID from TS_REQUEST for the current OR_NUMBER
//                        String requestId = getRequestIdByOrNumber(orNumber, connection);
//                        String fileStatus = getFileStatusByOrNumber(orNumber, connection); // New method
//
//                        // Add to the claims list
//                        claims.add(new PendingClaim(orNumber, customerName, dateProcessed, college, feeName, feeDesc, requestId, fileStatus));
//                    }
//                }
//            }
//        }
//
//        return claims;
//    }
    
    public List<PendingClaim> getActivePendingClaims() throws SQLException {
            List<PendingClaim> claims = new ArrayList<>();

            // Fetch all required columns directly from TS_REQUEST
            String query = "SELECT REQUEST_ID, OR_NUMBER, CUSTOMER_NAME, COLLEGE, FILE_STATUS, PAYMENT_DATE, REQUESTS, REQUEST_DESCRIPTION FROM TS_REQUEST WHERE IS_CLAIMED = 'N'";

            try (Connection connection = DatabaseConnection.getConnection();
                 PreparedStatement stmt = connection.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    String orNumber = rs.getString("OR_NUMBER");
                    String customerName = rs.getString("CUSTOMER_NAME");
                    String college = rs.getString("COLLEGE");
                    String fileStatus = rs.getString("FILE_STATUS");
                    Timestamp dateProcessed = rs.getTimestamp("PAYMENT_DATE");
                    String feeName = rs.getString("REQUESTS");
                    String feeDesc = rs.getString("REQUEST_DESCRIPTION");
                    String requestId = rs.getString("REQUEST_ID");

                    // Create a PendingClaim instance with all retrieved values
                    claims.add(new PendingClaim(orNumber, customerName, dateProcessed, college, feeName, feeDesc, requestId, fileStatus));
                }
            }

            return claims;
        }

    private String getRequestIdByOrNumber(String orNumber, Connection connection) throws SQLException {
        String requestId = null;
        String requestIdQuery = "SELECT REQUEST_ID FROM TS_REQUEST WHERE OR_NUMBER = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(requestIdQuery)) {
            pstmt.setString(1, orNumber);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    requestId = rs.getString("REQUEST_ID");
                }
            }
        }

        return requestId;
    }
    
    private String getFileStatusByOrNumber(String orNumber, Connection connection) throws SQLException {
           String fileStatus = null;
           String fileStatusQuery = "SELECT FILE_STATUS FROM TS_REQUEST WHERE OR_NUMBER = ?"; // Add file_status query

           try (PreparedStatement pstmt = connection.prepareStatement(fileStatusQuery)) {
               pstmt.setString(1, orNumber);
               try (ResultSet rs = pstmt.executeQuery()) {
                   if (rs.next()) {
                       fileStatus = rs.getString("FILE_STATUS");
                   }
               }
           }

           return fileStatus;
       }
    
    public int getDaysSinceProcessing(String requestId) throws SQLException {
            String query = "SELECT DATE_PROCESSING FROM TS_REQUEST WHERE REQUEST_ID = ?";
            int days = 0;

            try (Connection connection = DatabaseConnection.getConnection();
                 PreparedStatement pstmt = connection.prepareStatement(query)) {
                pstmt.setString(1, requestId);
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
    
//    public void insertPendingClaims(List<PendingClaim> pendingClaims) throws SQLException {
//        // SQL query to get existing OR_NUMBERs from TS_REQUEST
//        String existingQuery = "SELECT OR_NUMBER FROM TS_REQUEST";
//        
//        // Set to hold existing OR_NUMBERs
//        Set<String> existingOrNumbers = new HashSet<>();
//        
//        try (Connection connection = DatabaseConnection.getConnection();
//             PreparedStatement existingStmt = connection.prepareStatement(existingQuery);
//             ResultSet existingRs = existingStmt.executeQuery()) {
//             
//            // Populate the set with existing OR_NUMBERs
//            while (existingRs.next()) {
//                existingOrNumbers.add(existingRs.getString("OR_NUMBER"));
//            }
//        }
//        
//        // Map to hold OR_NUMBER and associated FEE_NAME values
//        Map<String, Set<String>> orNumberFeeMap = new HashMap<>();
//        
//        // Populate the map with OR_NUMBERs and their associated FEE_NAME values
//        for (PendingClaim claim : pendingClaims) {
//            orNumberFeeMap
//                .computeIfAbsent(claim.getOrNumber(), k -> new HashSet<>())
//                .add(claim.getFeeName());
//        }
//
//        // SQL query for inserting new claims
//        String insertQuery = "INSERT INTO TS_REQUEST (REQUEST_ID, OR_NUMBER, CUSTOMER_NAME, PAYMENT_DATE, COLLEGE, REQUESTS, REQUEST_DESCRIPTION) "
//                                + "VALUES (TS_REQUEST_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?)";
//
//            try (Connection connection = DatabaseConnection.getConnection();
//                 PreparedStatement pstmt = connection.prepareStatement(insertQuery)) {
//
//                // Loop through each pending claim and insert into TS_REQUEST
//                for (PendingClaim claim : pendingClaims) {
//                    String orNumber = claim.getOrNumber();
//                    
//                    // Insert only if OR_NUMBER does not already exist in TS_REQUEST
//                    if (!existingOrNumbers.contains(orNumber)) {
//                        pstmt.setString(1, orNumber); // Set OR_NUMBER
//                        pstmt.setString(2, claim.getCustomerName()); // Set CUSTOMER_NAME
//                        pstmt.setTimestamp(3, claim.getDateProcessed()); // Set PAYMENT_DATE (as Timestamp)
//                        pstmt.setString(4, claim.getCollege()); // Set COLLEGE
//                        pstmt.setString(5, claim.getFeeName()); // Set REQUESTS (FEE_NAME)
//                        pstmt.setString(6, claim.getFeeDesc()); // Set REQUEST_DESCRIPTION (FEE_DESC)
//
//                        pstmt.addBatch(); // Add to batch
//                    }
//                }
//
//                // Execute batch insert
//                pstmt.executeBatch();
//            }
//    }
}