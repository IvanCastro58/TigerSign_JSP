package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.ArrayList;
import java.util.List;

public class PendingClaimsService {

    public List<PendingClaim> getPendingClaims() {
        List<PendingClaim> claimsList = new ArrayList<>();
        String query = "SELECT id, transaction_id, name, email, status, college, date_processed, files FROM TS_REQUEST WHERE is_claimed = 'N'";

        try (Connection connection = DatabaseConnection.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(query)) {

            while (resultSet.next()) {
                PendingClaim claim = new PendingClaim();
                claim.setId(resultSet.getInt("id"));
                claim.setTransactionId(resultSet.getString("transaction_id"));
                claim.setName(resultSet.getString("name"));
                claim.setEmail(resultSet.getString("email"));
                claim.setStatus(resultSet.getString("status"));
                claim.setCollege(resultSet.getString("college"));
                claim.setDateProcessed(resultSet.getString("date_processed"));
                claim.setFiles(resultSet.getString("files"));
                claimsList.add(claim);
            }
        } catch (SQLException e) {
            e.printStackTrace(); 
        }

        return claimsList;
    }
    
    public void updateClaimStatus(int id, String status) {
          Connection connection = null;
          PreparedStatement statement = null;

          try {
              connection = DatabaseConnection.getConnection();
              String sql = "UPDATE TS_REQUEST SET status = ? WHERE id = ?";
              statement = connection.prepareStatement(sql);
              statement.setString(1, status);
              statement.setInt(2, id);
              statement.executeUpdate();
          } catch (SQLException e) {
              e.printStackTrace(); 
          } finally {
              try {
                  if (statement != null) statement.close();
                  if (connection != null) connection.close();
              } catch (SQLException e) {
                  e.printStackTrace(); 
              }
          }
      }
}