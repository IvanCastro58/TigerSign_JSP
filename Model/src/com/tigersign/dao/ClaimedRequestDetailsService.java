package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;
import java.text.SimpleDateFormat;
import java.io.InputStream;
import java.io.ByteArrayOutputStream;
import com.tigersign.service.TestOpenCV;

public class ClaimedRequestDetailsService {

    public ClaimedRequestDetails getClaimedRequestDetails(String requestId) {
        ClaimedRequestDetails details = null;
        String query = "SELECT r.or_number AS orNumber, r.customer_name AS requester_name, r.requests AS files, r.request_description AS files_desc, r.payment_date AS dateProcessed, r.college, " +
                       "c.name AS claimer_name, c.email AS claimer_email, p.proof_date, c.role, " +
                       "p.photo, p.signature, p.id_photo, p.letter_photo, p.released_by " +
                       "FROM TS_PROOFS p " +
                       "JOIN TS_REQUEST r ON p.request_id = r.request_id " +
                       "JOIN TS_CLAIMER c ON p.claimer_id = c.claimer_id " +
                       "WHERE p.request_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, requestId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
                    details = new ClaimedRequestDetails();
                    details.setRequestId(requestId);
                    details.setOrNumber(resultSet.getString("orNumber"));
                    details.setRequesterName(resultSet.getString("requester_name"));
                    details.setDateProcessed(dateFormat.format(resultSet.getDate("dateProcessed")));
                    details.setRequestedDocuments(resultSet.getString("files"));
                    details.setRequestedDescription(resultSet.getString("files_desc"));
                    details.setCollege(resultSet.getString("college"));
                    details.setClaimerName(resultSet.getString("claimer_name"));
                    details.setClaimerEmail(resultSet.getString("claimer_email"));
                    details.setProofDate(dateFormat.format(resultSet.getDate("proof_date")));
                    details.setClaimerRole(resultSet.getString("role"));
                    details.setReleasedBy(resultSet.getString("released_by"));

                    // Convert BLOB to Base64 string
                    details.setPhotoBase64(convertBlobToBase64(resultSet.getBinaryStream("photo")));
                    details.setSignatureBase64(convertBlobToBase64(resultSet.getBinaryStream("signature")));
                    String idPhotoBase64 = convertBlobToBase64(resultSet.getBinaryStream("id_photo"));
                    String letterPhotoBase64 = convertBlobToBase64(resultSet.getBinaryStream("letter_photo"));

                    details.setIdPhotoBase64(idPhotoBase64);
                    details.setLetterPhotoBase64(letterPhotoBase64);
                    
                    // Compare images using OpenCV
                    if (idPhotoBase64 != null && letterPhotoBase64 != null) {
                        double similarity = TestOpenCV.compareImages(idPhotoBase64, letterPhotoBase64);
                        details.setImageSimilarity(similarity); // Add a field for similarity
                    } else {
                        details.setImageSimilarity(0.0); // Default value if one of the images is null
                    }
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
