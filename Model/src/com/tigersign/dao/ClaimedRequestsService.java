package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClaimedRequestsService {

    public List<ClaimedRequest> getClaimedRequests() {
        List<ClaimedRequest> requestsList = new ArrayList<>();
        String query = "SELECT p.request_id, r.or_number, r.customer_name AS name, r.college AS college, p.proof_date, r.requests AS files, r.request_description AS files_desc " +
                       "FROM TS_PROOFS p " +
                       "JOIN TS_REQUEST r ON p.request_id = r.request_id";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {

            try (ResultSet resultSet = stmt.executeQuery()) {
                while (resultSet.next()) {
                    ClaimedRequest request = new ClaimedRequest();
                    request.setRequestId(resultSet.getString("request_id"));
                    request.setOrNumber(resultSet.getString("or_number"));
                    request.setName(resultSet.getString("name"));
                    request.setCollege(resultSet.getString("college"));
                    request.setProofDate(resultSet.getString("proof_date"));
                    request.setDocumentsRequested(resultSet.getString("files"));
                    request.setDocumentsDescription(resultSet.getString("files_desc"));
                    requestsList.add(request);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return requestsList;
    }
}

