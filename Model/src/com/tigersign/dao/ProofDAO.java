package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Base64;
import java.io.ByteArrayInputStream;

public class ProofDAO {
    public void insertProofs(String photoData, String signatureData, String proofDate, String idData, String letterData, int claimerId, String transactionId, String fullName) throws SQLException {
            String sql = "INSERT INTO TS_PROOFS (PHOTO, SIGNATURE, PROOF_DATE, ID_PHOTO, LETTER_PHOTO, CLAIMER_ID, TRANSACTION_ID, RELEASED_BY) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            
            try (Connection conn = DatabaseConnection.getConnection(); 
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                // Convert Base64 data to byte array (BLOB)
                byte[] photoBytes = Base64.getDecoder().decode(photoData.split(",")[1]);
                byte[] signatureBytes = Base64.getDecoder().decode(signatureData.split(",")[1]);

                stmt.setBinaryStream(1, new ByteArrayInputStream(photoBytes), photoBytes.length);
                stmt.setBinaryStream(2, new ByteArrayInputStream(signatureBytes), signatureBytes.length);

                if (idData != null && !idData.isEmpty()) {
                    byte[] idBytes = Base64.getDecoder().decode(idData.split(",")[1]);
                    stmt.setBinaryStream(4, new ByteArrayInputStream(idBytes), idBytes.length);
                } else {
                    stmt.setNull(4, java.sql.Types.BLOB);
                }

                if (letterData != null && !letterData.isEmpty()) {
                    byte[] letterBytes = Base64.getDecoder().decode(letterData.split(",")[1]);
                    stmt.setBinaryStream(5, new ByteArrayInputStream(letterBytes), letterBytes.length);
                } else {
                    stmt.setNull(5, java.sql.Types.BLOB);
                }

                stmt.setDate(3, java.sql.Date.valueOf(proofDate));
                stmt.setInt(6, claimerId); // Set claimer_id
                stmt.setString(7, transactionId); // Set transaction_id
                stmt.setString(8, fullName); // Set released_by

                stmt.executeUpdate();
            }
    }
}

