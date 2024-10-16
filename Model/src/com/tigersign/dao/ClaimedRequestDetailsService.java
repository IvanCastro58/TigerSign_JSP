package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;
import java.text.SimpleDateFormat;
import java.io.InputStream;
import java.io.ByteArrayOutputStream;

public class ClaimedRequestDetailsService {

    public ClaimedRequestDetails getClaimedRequestDetails(String orNumber, String feeName) {
        ClaimedRequestDetails details = null;
        String query = "SELECT r.customer_name AS requester_name, r.fee_name AS files, r.payment_date AS dateProcessed, " +
                       "c.name AS claimer_name, c.email AS claimer_email, p.proof_date, c.role, " +
                       "p.photo, p.signature, p.id_photo, p.letter_photo, p.released_by " +
                       "FROM TS_PROOFS p " +
                       "JOIN TS_REQUEST r ON p.or_number = r.or_number AND p.fee_name = r.fee_name " +
                       "JOIN TS_CLAIMER c ON p.claimer_id = c.claimer_id " +
                       "WHERE p.or_number = ? AND p.fee_name = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, orNumber);
            statement.setString(2, feeName);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
                    details = new ClaimedRequestDetails();
                    details.setOrNumber(orNumber);
                    details.setRequesterName(resultSet.getString("requester_name"));
                    details.setDateProcessed(dateFormat.format(resultSet.getDate("dateProcessed")));
                    details.setRequestedDocuments(resultSet.getString("files"));
                    details.setClaimerName(resultSet.getString("claimer_name"));
                    details.setClaimerEmail(resultSet.getString("claimer_email"));
                    details.setProofDate(dateFormat.format(resultSet.getDate("proof_date")));
                    details.setClaimerRole(resultSet.getString("role"));
                    details.setReleasedBy(resultSet.getString("released_by"));

                    // Convert BLOB to Base64 string
                    details.setPhotoBase64(convertBlobToBase64(resultSet.getBinaryStream("photo")));
                    details.setSignatureBase64(convertBlobToBase64(resultSet.getBinaryStream("signature")));
                    details.setIdPhotoBase64(convertBlobToBase64(resultSet.getBinaryStream("id_photo")));
                    details.setLetterPhotoBase64(convertBlobToBase64(resultSet.getBinaryStream("letter_photo")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return details;
    }

    private String convertBlobToBase64(InputStream blobStream) {
        if (blobStream == null) {
            return null;
        }
        try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = blobStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
            return Base64.getEncoder().encodeToString(outputStream.toByteArray());
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}


//public class ClaimedRequestDetailsService {
//
//    public ClaimedRequestDetails getClaimedRequestDetails(String transactionId) {
//        ClaimedRequestDetails details = null;
//        String query = "SELECT r.name AS requester_name, r.email AS requester_email, r.date_processed, r.files, " +
//                       "c.name AS claimer_name, c.email AS claimer_email, p.proof_date, c.role, " +
//                       "p.photo, p.signature, p.id_photo, p.letter_photo, p.released_by " +
//                       "FROM TS_PROOFS p " +
//                       "JOIN TS_REQUEST r ON p.transaction_id = r.transaction_id " +
//                       "JOIN TS_CLAIMER c ON p.claimer_id = c.claimer_id " +
//                       "WHERE p.transaction_id = ?";
//
//        try (Connection connection = DatabaseConnection.getConnection();
//             PreparedStatement statement = connection.prepareStatement(query)) {
//            statement.setString(1, transactionId);
//            try (ResultSet resultSet = statement.executeQuery()) {
//                if (resultSet.next()) {
//                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//                    details = new ClaimedRequestDetails();
//                    details.setTransactionId(transactionId);
//                    details.setRequesterName(resultSet.getString("requester_name"));
//                    details.setRequesterEmail(resultSet.getString("requester_email"));
//                    details.setDateProcessed(dateFormat.format(resultSet.getDate("date_processed")));
//                    details.setRequestedDocuments(resultSet.getString("files"));
//                    details.setClaimerName(resultSet.getString("claimer_name"));
//                    details.setClaimerEmail(resultSet.getString("claimer_email"));
//                    details.setProofDate(dateFormat.format(resultSet.getDate("proof_date")));
//                    details.setClaimerRole(resultSet.getString("role"));
//                    details.setReleasedBy(resultSet.getString("released_by"));
//
//                    // Convert BLOB to Base64 string
//                    details.setPhotoBase64(convertBlobToBase64(resultSet.getBinaryStream("photo")));
//                    details.setSignatureBase64(convertBlobToBase64(resultSet.getBinaryStream("signature")));
//                    details.setIdPhotoBase64(convertBlobToBase64(resultSet.getBinaryStream("id_photo")));
//                    details.setLetterPhotoBase64(convertBlobToBase64(resultSet.getBinaryStream("letter_photo")));
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        return details;
//    }
//
//    private String convertBlobToBase64(InputStream blobStream) {
//        if (blobStream == null) {
//            return null;
//        }
//        try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
//            byte[] buffer = new byte[4096];
//            int bytesRead;
//            while ((bytesRead = blobStream.read(buffer)) != -1) {
//                outputStream.write(buffer, 0, bytesRead);
//            }
//            return Base64.getEncoder().encodeToString(outputStream.toByteArray());
//        } catch (Exception e) {
//            e.printStackTrace();
//            return null;
//        }
//    }
//}
