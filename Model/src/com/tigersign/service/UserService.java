package com.tigersign.service;

import com.tigersign.dao.DatabaseConnection;
import com.tigersign.dao.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.logging.Level;
import java.util.logging.Logger;

public class UserService {

    private static final Logger LOGGER = Logger.getLogger(UserService.class.getName());

    public User getUserById(int userId) {
        User user = null;
        String query = "SELECT id, picture, firstname, lastname, email, status, position FROM TS_ADMIN WHERE id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    user = new User();
                    user.setId(resultSet.getInt("id"));
                    user.setPicture(resultSet.getString("picture")); 
                    user.setFirstname(resultSet.getString("firstname"));
                    user.setLastname(resultSet.getString("lastname"));
                    user.setEmail(resultSet.getString("email"));
                    user.setStatus(resultSet.getString("status"));
                    user.setPosition(resultSet.getString("position"));
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user from database", e);
        }

        return user;
    }

    public boolean deactivateUser(int userId, String reason) {
        String query = "UPDATE TS_ADMIN SET status = 'DEACTIVATED', reason = ? WHERE id = ? AND status = 'ACTIVE'";
        boolean isDeactivated = false;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, reason);
            statement.setInt(2, userId);

            int rowsUpdated = statement.executeUpdate();
            isDeactivated = (rowsUpdated > 0);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deactivating user", e);
        }

        return isDeactivated;
    }
    
    public boolean activateUser(int userId) {
        String query = "UPDATE TS_ADMIN SET status = 'ACTIVE', reason = NULL WHERE id = ? AND status = 'DEACTIVATED'";
        boolean isActivated = false;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            int rowsUpdated = statement.executeUpdate();
            isActivated = (rowsUpdated > 0);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error activating user", e);
        }

        return isActivated;
    }
    
    public String getDeactivationReason(int userId) {
        String query = "SELECT reason FROM TS_ADMIN WHERE id = ? AND status = 'DEACTIVATED'";
        String deactivationReason = null;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                deactivationReason = resultSet.getString("reason");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving deactivation reason", e);
        }

        return deactivationReason;
    }
    
    public boolean updateUserPosition(int userId, String newPosition) {
        String query = "UPDATE TS_ADMIN SET position = ? WHERE id = ?";
        boolean isUpdated = false;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, newPosition);
            statement.setInt(2, userId);
            int rowsUpdated = statement.executeUpdate();
            isUpdated = (rowsUpdated > 0);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating user position", e);
        }

        return isUpdated;
    }


}
