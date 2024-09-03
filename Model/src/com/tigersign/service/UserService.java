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
        String query = "SELECT id, picture, firstname, lastname, email, status FROM TS_ADMIN WHERE id = ? AND is_active = 'Y'";

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
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user from database", e);
        }

        return user;
    }
}
