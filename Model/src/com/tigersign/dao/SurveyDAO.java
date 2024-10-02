package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class SurveyDAO {

    public boolean submitSurvey(Survey survey) {
        String insertQuery = "INSERT INTO TS_SURVEY (NAME, SURVEY_DATE, EMAIL, SERVICE, RATING, STANDOUT, FEEDBACK) " +
                             "VALUES (?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?, ?, ?)";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(insertQuery)) {

            statement.setString(1, survey.getName());
            statement.setString(2, survey.getDate()); // Expecting date in YYYY-MM-DD format
            statement.setString(3, survey.getEmail());
            statement.setString(4, survey.getService());
            statement.setInt(5, survey.getRating());
            statement.setString(6, survey.getStandout());
            statement.setString(7, survey.getFeedback());

            int rowsInserted = statement.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
