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
        String query = "SELECT id, picture, firstname, lastname, email, status FROM TS_ADMIN WHERE id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            // Set the user ID parameter in the SQL query
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
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user from database", e);
        }

        return user;
    }

    public boolean deactivateUser(int userId) {
        String query = "UPDATE TS_ADMIN SET status = 'DEACTIVATED' WHERE id = ? AND status = 'ACTIVE'";
        boolean isDeactivated = false;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            int rowsUpdated = statement.executeUpdate();
            isDeactivated = (rowsUpdated > 0);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deactivating user", e);
        }

        return isDeactivated;
    }
    
    public boolean activateUser(int userId) {
        String query = "UPDATE TS_ADMIN SET status = 'ACTIVE' WHERE id = ? AND status = 'DEACTIVATED'";
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
}
