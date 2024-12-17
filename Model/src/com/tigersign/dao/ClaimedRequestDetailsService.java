package com.tigersign.dao;

import java.awt.image.BufferedImage;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;

import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Base64;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import org.json.JSONObject;

import org.apache.commons.imaging.Imaging;

public class ClaimedRequestDetailsService {

    private static final String API_URL = "https://ping.arya.ai/api/v2/signature-detection";
    private static final String API_TOKEN = "9873fbc8a73439c0f279e1b04c82ab17";

    public ClaimedRequestDetails getClaimedRequestDetails(String requestId) {
        ClaimedRequestDetails details = null;
        String query = "SELECT r.or_number AS orNumber, r.customer_name AS requester_name, r.requests AS files, " +
                       "r.request_description AS files_desc, r.payment_date AS dateProcessed, r.college, " +
                       "c.name AS claimer_name, c.email AS claimer_email, p.proof_date, c.role, " +
                       "p.photo AS photoPath, p.signature AS signaturePath, p.id_photo, p.letter_photo, " +
                       "p.released_by, p.id_signature, p.letter_signature " +
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
                    details.setPhotoPath(resultSet.getString("photoPath"));
                    details.setSignaturePath(resultSet.getString("signaturePath"));
                    
                    // Convert BLOB to Base64
                    details.setIdPhotoBase64(convertBlobToBase64(resultSet.getBinaryStream("id_photo")));
                    details.setLetterPhotoBase64(convertBlobToBase64(resultSet.getBinaryStream("letter_photo")));

                    // Check if both signatures are already stored in the database (not null)
                    Blob idSignatureBlob = resultSet.getBlob("id_signature");
                    Blob letterSignatureBlob = resultSet.getBlob("letter_signature");
                    boolean hasIdSignature = idSignatureBlob != null;
                    boolean hasLetterSignature = letterSignatureBlob != null;

                    System.out.println("Has ID Signature: " + hasIdSignature);
                    System.out.println("Has Letter Signature: " + hasLetterSignature);

                    // Only call analyzeImageForSignature if signatures are not already in the database
                    String idSignatureBase64 = hasIdSignature ? convertBlobToBase64(idSignatureBlob.getBinaryStream()) : null;
                    String letterSignatureBase64 = hasLetterSignature ? convertBlobToBase64(letterSignatureBlob.getBinaryStream()) : null;

                    if (!hasIdSignature && details.getIdPhotoBase64() != null) {
                        System.out.println("Checking for ID photo signature...");
                        idSignatureBase64 = analyzeImageForSignature(details.getIdPhotoBase64());
                        if (idSignatureBase64 == null || idSignatureBase64.equals("Signature not detected")) {
                            idSignatureBase64 = Base64.getEncoder().encodeToString("No signature detected".getBytes());
                        }
                    }

                    if (!hasLetterSignature && details.getLetterPhotoBase64() != null) {
                        System.out.println("Checking for letter photo signature...");
                        letterSignatureBase64 = analyzeImageForSignature(details.getLetterPhotoBase64());
                        if (letterSignatureBase64 == null || letterSignatureBase64.equals("Signature not detected")) {
                            letterSignatureBase64 = Base64.getEncoder().encodeToString("No signature detected".getBytes());
                        }
                    }

                    // Handle "Signature not detected" cases
                    if (idSignatureBase64 == null || idSignatureBase64.equals("Signature not detected")) {
                        idSignatureBase64 = "Signature not detected";
                    }
                    if (letterSignatureBase64 == null || letterSignatureBase64.equals("Signature not detected")) {
                        letterSignatureBase64 = "Signature not detected";
                    }

                    // Convert Base64 image snippets to byte arrays if signatures were detected
                    byte[] idSignatureBytes = idSignatureBase64 != null && !idSignatureBase64.equals("Signature not detected") 
                        ? Base64.getDecoder().decode(idSignatureBase64) 
                        : null;
                    byte[] letterSignatureBytes = letterSignatureBase64 != null && !letterSignatureBase64.equals("Signature not detected") 
                        ? Base64.getDecoder().decode(letterSignatureBase64) 
                        : null;
                    
                    
                        if (idSignatureBase64 != null && letterSignatureBase64 != null &&
                            !idSignatureBase64.equals("Signature not detected") &&
                            !letterSignatureBase64.equals("Signature not detected")) {
                            try {
                                double ssimScore = calculateSSIM(idSignatureBase64, letterSignatureBase64);
                                details.setSignatureSimilarityScore(ssimScore * 100); // Convert to percentage
                            } catch (Exception e) {
                                e.printStackTrace();
                                details.setSignatureSimilarityScore(0.0);
                            }
                        } else {
                            details.setSignatureSimilarityScore(0.0); // If "Signature not detected", set similarity score to 0.0
                        }

                    // Store the signature blobs into the database
                    storeSignaturesToDatabase(requestId, idSignatureBytes, letterSignatureBytes);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return details;
    }

    private String convertBlobToBase64(InputStream blobStream) {
        if (blobStream == null) {
            System.out.println("Blob stream is null.");
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

    private String analyzeImageForSignature(String base64Image) {
        try {
            // Create OkHttpClient
            OkHttpClient client = new OkHttpClient();

            // Prepare the JSON request body
            JSONObject jsonBody = new JSONObject();
            jsonBody.put("output_format", "snippets");
            jsonBody.put("doc_base64", base64Image);
            jsonBody.put("req_id", "unique_request_id");

            // Request setup
            RequestBody body = RequestBody.create(MediaType.parse("application/json"), jsonBody.toString());
            Request request = new Request.Builder()
                    .url(API_URL)
                    .method("POST", body)
                    .addHeader("token", API_TOKEN)
                    .addHeader("content-type", "application/json")
                    .build();

            Response response = client.newCall(request).execute();
            if (response.isSuccessful()) {
                String responseBody = response.body().string();
                System.out.println("Raw Response: " + responseBody);

                JSONObject jsonResponse = new JSONObject(responseBody);

                if (jsonResponse.optBoolean("success", false)) {
                    if (jsonResponse.has("Signs") && !jsonResponse.isNull("Signs") && jsonResponse.getJSONArray("Signs").length() > 0) {
                        JSONObject signDetails = jsonResponse.getJSONArray("Signs").getJSONObject(0);
                        String snippetImageBase64 = signDetails.optString("base64", null);
                        if (snippetImageBase64 != null && !snippetImageBase64.isEmpty()) {
                            return snippetImageBase64.split(",")[1]; // Return pure Base64 string
                        }
                    }
                }

                return "Signature not detected";
            } else {
                System.err.println("API Error: " + response.message());
                return "Signature not detected";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Signature not detected";
        }
    }
    
    private double calculateSSIM(String base64Image1, String base64Image2) throws Exception {
        // Decode Base64 strings
        byte[] image1Bytes = Base64.getDecoder().decode(base64Image1);
        byte[] image2Bytes = Base64.getDecoder().decode(base64Image2);

        // Convert byte arrays to BufferedImage objects
        BufferedImage image1 = Imaging.getBufferedImage(new ByteArrayInputStream(image1Bytes));
        BufferedImage image2 = Imaging.getBufferedImage(new ByteArrayInputStream(image2Bytes));

        // Preprocess images: Grayscale, Resize, Normalize
        BufferedImage preprocessed1 = preprocessImage(image1);
        BufferedImage preprocessed2 = preprocessImage(image2);

        // Compute SSIM Score
        double ssimScore = computeEnhancedSSIM(preprocessed1, preprocessed2);

        // If SSIM score is above a threshold but the images are still different, compare edges for fine-grained analysis
        if (ssimScore > 0.90) {
            int edgeDifference = compareEdges(preprocessed1, preprocessed2);
            if (edgeDifference > 500) { // A threshold for significant edge difference
                System.out.println("Significant edge difference detected despite high SSIM. Adjusting score.");
                ssimScore -= 0.05; // Adjust SSIM score based on edge difference
            }
        }

        return ssimScore;
    }

    private BufferedImage preprocessImage(BufferedImage img) {
        // Convert to grayscale
        BufferedImage grayscale = toGrayscale(img);

        // Trim unnecessary edges or noise
        BufferedImage trimmed = trimEdges(grayscale);

        // Resize to consistent dimensions (e.g., 256x256)
        BufferedImage resized = resizeImage(trimmed, 256, 256);

        // Normalize intensities for uniformity
        return normalizeIntensity(resized);
    }


    private BufferedImage trimEdges(BufferedImage img) {
        int width = img.getWidth();
        int height = img.getHeight();

        // Find non-background pixels
        int threshold = 200;
        int minX = width, minY = height, maxX = 0, maxY = 0;

        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int pixel = img.getRaster().getSample(x, y, 0);
                if (pixel < threshold) {
                    minX = Math.min(minX, x);
                    minY = Math.min(minY, y);
                    maxX = Math.max(maxX, x);
                    maxY = Math.max(maxY, y);
                }
            }
        }

        // Crop image based on detected edges
        if (minX < maxX && minY < maxY) {
            return img.getSubimage(minX, minY, maxX - minX + 1, maxY - minY + 1);
        }
        return img;
    }

    private BufferedImage normalizeIntensity(BufferedImage img) {
        int width = img.getWidth();
        int height = img.getHeight();
        BufferedImage normalized = new BufferedImage(width, height, img.getType());

        int min = 255, max = 0;

        // Find min and max pixel intensities
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int pixel = img.getRaster().getSample(x, y, 0);
                min = Math.min(min, pixel);
                max = Math.max(max, pixel);
            }
        }

        // Normalize pixel intensities
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int pixel = img.getRaster().getSample(x, y, 0);
                int normalizedPixel = (int) (255.0 * (pixel - min) / (max - min));
                normalized.getRaster().setSample(x, y, 0, normalizedPixel);
            }
        }

        return normalized;
    }

    private BufferedImage toGrayscale(BufferedImage img) {
        BufferedImage grayscale = new BufferedImage(img.getWidth(), img.getHeight(), BufferedImage.TYPE_BYTE_GRAY);
        grayscale.getGraphics().drawImage(img, 0, 0, null);
        return grayscale;
    }

    private BufferedImage resizeImage(BufferedImage img, int width, int height) {
        BufferedImage resized = new BufferedImage(width, height, img.getType());
        resized.getGraphics().drawImage(img, 0, 0, width, height, null);
        return resized;
    }
    
    private BufferedImage detectEdges(BufferedImage img) {
        int width = img.getWidth();
        int height = img.getHeight();
        BufferedImage edges = new BufferedImage(width, height, BufferedImage.TYPE_BYTE_GRAY);

        // Apply a simple Sobel operator for edge detection
        for (int y = 1; y < height - 1; y++) {
            for (int x = 1; x < width - 1; x++) {
                int gx = (-1 * img.getRaster().getSample(x - 1, y - 1, 0)) +
                         (-2 * img.getRaster().getSample(x - 1, y, 0)) +
                         (-1 * img.getRaster().getSample(x - 1, y + 1, 0)) +
                         (1 * img.getRaster().getSample(x + 1, y - 1, 0)) +
                         (2 * img.getRaster().getSample(x + 1, y, 0)) +
                         (1 * img.getRaster().getSample(x + 1, y + 1, 0));

                int gy = (-1 * img.getRaster().getSample(x - 1, y - 1, 0)) +
                         (-2 * img.getRaster().getSample(x, y - 1, 0)) +
                         (-1 * img.getRaster().getSample(x + 1, y - 1, 0)) +
                         (1 * img.getRaster().getSample(x - 1, y + 1, 0)) +
                         (2 * img.getRaster().getSample(x, y + 1, 0)) +
                         (1 * img.getRaster().getSample(x + 1, y + 1, 0));

                int magnitude = (int) Math.sqrt(gx * gx + gy * gy);
                edges.getRaster().setSample(x, y, 0, Math.min(255, magnitude));
            }
        }

        return edges;
    }
    
    private int compareEdges(BufferedImage img1, BufferedImage img2) {
        BufferedImage edges1 = detectEdges(img1);
        BufferedImage edges2 = detectEdges(img2);

        int width = edges1.getWidth();
        int height = edges1.getHeight();
        int edgeDifference = 0;

        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int pixel1 = edges1.getRaster().getSample(x, y, 0);
                int pixel2 = edges2.getRaster().getSample(x, y, 0);
                edgeDifference += Math.abs(pixel1 - pixel2);
            }
        }

        return edgeDifference;
    }

    private double computeEnhancedSSIM(BufferedImage img1, BufferedImage img2) {
        double C1 = 6.5025, C2 = 58.5225;

        double meanX = 0, meanY = 0, varX = 0, varY = 0, covXY = 0;
        int width = img1.getWidth();
        int height = img1.getHeight();
        int n = width * height;

        // Compute means, variances, and covariance of images
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int pixelX = img1.getRaster().getSample(x, y, 0);
                int pixelY = img2.getRaster().getSample(x, y, 0);

                meanX += pixelX;
                meanY += pixelY;
                varX += pixelX * pixelX;
                varY += pixelY * pixelY;
                covXY += pixelX * pixelY;
            }
        }

        meanX /= n;
        meanY /= n;
        varX = varX / n - meanX * meanX;
        varY = varY / n - meanY * meanY;
        covXY = covXY / n - meanX * meanY;

        // Compute SSIM formula
        double numerator = (2 * meanX * meanY + C1) * (2 * covXY + C2);
        double denominator = (meanX * meanX + meanY * meanY + C1) * (varX + varY + C2);

        return numerator / denominator;
    }

    private void storeSignaturesToDatabase(String requestId, byte[] idSignatureBytes, byte[] letterSignatureBytes) {
        String updateQuery = "UPDATE TS_PROOFS SET id_signature = ?, letter_signature = ? WHERE request_id = ?";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(updateQuery)) {
            
            // Check if the byte array is null or corresponds to the "No signature detected" text
            statement.setBytes(1, (idSignatureBytes != null && idSignatureBytes.length > 0) 
                ? idSignatureBytes 
                : null);  // You can set it to null or a default image if needed
            
            statement.setBytes(2, (letterSignatureBytes != null && letterSignatureBytes.length > 0) 
                ? letterSignatureBytes 
                : null);  // Same as above
            
            statement.setString(3, requestId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}