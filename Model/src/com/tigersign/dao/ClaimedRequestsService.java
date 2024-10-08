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
        String query = "SELECT p.transaction_id, r.name, r.college, p.proof_date, r.files " +
                       "FROM TS_PROOFS p " +
                       "JOIN TS_REQUEST r ON p.transaction_id = r.transaction_id";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                ClaimedRequest request = new ClaimedRequest();
                request.setTransactionId(resultSet.getString("transaction_id"));
                request.setName(resultSet.getString("name"));
                request.setCollege(resultSet.getString("college"));
                request.setProofDate(resultSet.getString("proof_date"));
                request.setDocumentsRequested(resultSet.getString("files"));
                requestsList.add(request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return requestsList;
    }
}
