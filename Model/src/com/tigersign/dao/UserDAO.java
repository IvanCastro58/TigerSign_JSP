package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT id, picture, firstname, lastname, email, status FROM TS_ADMIN WHERE status = 'ACTIVE'";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("id"));
                user.setPicture(resultSet.getString("picture")); // Retrieve the full URL
                user.setFirstname(resultSet.getString("firstname"));
                user.setLastname(resultSet.getString("lastname"));
                user.setEmail(resultSet.getString("email"));
                user.setStatus(resultSet.getString("status"));
                users.add(user);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching users from database", e);
        }

        return users;
    }
}
