package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Base64;
import java.util.UUID;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.ServletContext;

public class ProofDAO {
    private ServletContext servletContext;

    // Constructor to inject ServletContext
    public ProofDAO(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    public void insertProofs(String photoData, String signatureData, String proofDate, String idData, String letterData, int claimerId, String requestId, String fullName) throws SQLException {
        String photoFilePath = saveFile(photoData, "photo");
        String signatureFilePath = saveFile(signatureData, "signature");

        String sql = "INSERT INTO TS_PROOFS (PHOTO, SIGNATURE, PROOF_DATE, ID_PHOTO, LETTER_PHOTO, CLAIMER_ID, REQUEST_ID, RELEASED_BY) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, photoFilePath);  // File path for photo
            stmt.setString(2, signatureFilePath);  // File path for signature
            stmt.setDate(3, java.sql.Date.valueOf(proofDate));
            stmt.setInt(6, claimerId);
            stmt.setString(7, requestId);
            stmt.setString(8, fullName);

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

            stmt.executeUpdate();
        }
    }

    private String saveFile(String base64Data, String folder) {
        if (base64Data == null || base64Data.isEmpty()) {
            return null;
        }

        try {
            // Generate a unique file name using UUID
            String uniqueFileName = UUID.randomUUID().toString() + ".png";

            // Define the relative folder path
            String relativePath = "resources/proofs/" + folder + "/" + uniqueFileName;

            // Get the absolute path using ServletContext
            String absolutePath = servletContext.getRealPath("/") + relativePath;

            // Decode the base64 data
            String data = base64Data.split(",")[1];
            byte[] decodedBytes = Base64.getDecoder().decode(data);

            // Create the file and write the data to it
            File file = new File(absolutePath);
            file.getParentFile().mkdirs();  // Create the directories if they don't exist
            try (FileOutputStream fos = new FileOutputStream(file)) {
                fos.write(decodedBytes);
            }

            return relativePath;  // Return the relative path to store in the database
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}