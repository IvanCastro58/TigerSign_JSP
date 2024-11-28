package com.tigersign.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import oracle.jdbc.OracleTypes;

public class PendingClaimsService {

    // Fetches data from TIGERSIGNX.PKG
    public List<PendingClaim> getActivePendingClaimsFromPkg() throws SQLException {
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
                        String feeDesc = rs.getString("FEE_DESCRIPTION");

                        String requestId = getRequestIdByOrNumber(orNumber, connection);
                        String fileStatus = getFileStatusByOrNumber(orNumber, connection);

                        claims.add(new PendingClaim(orNumber, customerName, dateProcessed, college, feeName, feeDesc, requestId, fileStatus));
                    }
                }
            }
        }

        System.out.println("Fetched claims from TIGERSIGNX.PKG: " + claims.size());
        return claims;
    }

    // Retrieves data rows of TS_REQUEST table
    public List<PendingClaim> getActivePendingClaimsFromTsRequest() throws SQLException {
        List<PendingClaim> claims = new ArrayList<>();
        String query = "SELECT REQUEST_ID, OR_NUMBER, CUSTOMER_NAME, COLLEGE, FILE_STATUS, PAYMENT_DATE, REQUESTS, REQUEST_DESCRIPTION "
                     + "FROM TS_REQUEST WHERE IS_CLAIMED = 'N' ORDER BY CUSTOMER_NAME ASC";

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

                claims.add(new PendingClaim(orNumber, customerName, dateProcessed, college, feeName, feeDesc, requestId, fileStatus));
            }
        }

        System.out.println("Fetched claims from TS_REQUEST: " + claims.size());
        return claims;
    }

    // Inserts new claims into TS_REQUEST
    public void insertPendingClaims(List<PendingClaim> pendingClaims) throws SQLException {
        String existingQuery = "SELECT OR_NUMBER, REQUESTS FROM TS_REQUEST";
        Set<String> existingClaims = new HashSet<>();

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement existingStmt = connection.prepareStatement(existingQuery);
             ResultSet existingRs = existingStmt.executeQuery()) {

            while (existingRs.next()) {
                String orNumber = existingRs.getString("OR_NUMBER");
                String feeName = existingRs.getString("REQUESTS");
                existingClaims.add(orNumber + "_" + feeName);  // Unique check based on OR_NUMBER + FEE_NAME
            }
        }

        String insertQuery = "INSERT INTO TS_REQUEST (REQUEST_ID, OR_NUMBER, CUSTOMER_NAME, PAYMENT_DATE, COLLEGE, REQUESTS, REQUEST_DESCRIPTION) "
                           + "VALUES (TS_REQUEST_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(insertQuery)) {

            int insertedCount = 0;

            for (PendingClaim claim : pendingClaims) {
                String orNumber = claim.getOrNumber();
                String feeName = claim.getFeeName();
                String uniqueKey = orNumber + "_" + feeName; // Unique identifier based on OR_NUMBER and FEE_NAME

                if (!existingClaims.contains(uniqueKey)) {
                    pstmt.setString(1, orNumber);
                    pstmt.setString(2, claim.getCustomerName());
                    pstmt.setTimestamp(3, claim.getDateProcessed());
                    pstmt.setString(4, claim.getCollege());
                    pstmt.setString(5, claim.getFeeName());
                    pstmt.setString(6, claim.getFeeDesc());

                    pstmt.addBatch();
                    insertedCount++;
                }
            }

            if (insertedCount > 0) {
                pstmt.executeBatch();
                System.out.println("Inserted " + insertedCount + " new claims into TS_REQUEST.");
            } else {
                System.out.println("No new claims to insert.");
            }
        }
    }

    // Main method to fetch claims, inserting only if new data is found
    public List<PendingClaim> getActivePendingClaims() throws SQLException {
        System.out.println("Fetching claims directly from TS_REQUEST...");
        return getActivePendingClaimsFromTsRequest();
    }
    
    public void processPendingClaims() throws SQLException {
        System.out.println("Starting process to fetch claims from TIGERSIGNX.PKG...");

        // Fetch claims from TIGERSIGNX.PKG
        List<PendingClaim> claimsFromPkg = getActivePendingClaimsFromPkg();

        if (claimsFromPkg.isEmpty()) {
            System.out.println("No new claims fetched from TIGERSIGNX.PKG.");
            return;
        }

        // Insert new claims into TS_REQUEST
        insertPendingClaims(claimsFromPkg);

        System.out.println("Process complete. Pending claims inserted.");
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
}