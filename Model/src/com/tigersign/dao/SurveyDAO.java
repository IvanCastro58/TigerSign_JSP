package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

public class SurveyDAO {

    // Fetch all surveys
    public List<Survey> getAllSurveys() {
        List<Survey> surveys = new ArrayList<>();
        String query = "SELECT * FROM TS_SURVEY";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                Survey survey = new Survey();
                survey.setName(rs.getString("name"));
                survey.setDate(rs.getString("survey_date"));
                survey.setEmail(rs.getString("email"));
                survey.setService(rs.getString("service"));
                survey.setRating(rs.getInt("rating"));
                survey.setStandout(rs.getString("standout"));
                survey.setFeedback(rs.getString("feedback"));

                surveys.add(survey);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return surveys;
    }

    // Fetch average score
    public double getAverageScore() {
        String query = "SELECT AVG(rating) AS avg_rating FROM TS_SURVEY";
        double avgRating = 0.0;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet rs = statement.executeQuery()) {

            if (rs.next()) {
                avgRating = rs.getDouble("avg_rating");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return avgRating;
    }

    // Fetch total evaluations sent
    public int getEvaluationSentCount() {
        String query = "SELECT COUNT(*) AS eval_sent_count FROM TS_SURVEY";
        int evalSentCount = 0;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet rs = statement.executeQuery()) {

            if (rs.next()) {
                evalSentCount = rs.getInt("eval_sent_count");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return evalSentCount;
    }

    // Fetch total evaluations received (assuming based on non-null feedback)
    public int getEvaluationReceivedCount() {
        String query = "SELECT COUNT(*) AS eval_received_count FROM TS_SURVEY WHERE feedback IS NOT NULL";
        int evalReceivedCount = 0;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet rs = statement.executeQuery()) {

            if (rs.next()) {
                evalReceivedCount = rs.getInt("eval_received_count");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return evalReceivedCount;
    }

    // Fetch service window performance scores with count
    public List<Survey> getServiceWindowScores() {
        List<Survey> serviceScores = new ArrayList<>();
        String query = "SELECT service, AVG(rating) AS avg_rating, COUNT(*) AS eval_count FROM TS_SURVEY GROUP BY service";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                Survey survey = new Survey();
                survey.setService(rs.getString("service"));
                survey.setRating(rs.getInt("avg_rating"));
                survey.setEvaluationCount(rs.getInt("eval_count")); // Add a new field for evaluation count
                serviceScores.add(survey);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return serviceScores;
    }
    
    // Fetch all feedback for display
    public List<Survey> getAllFeedback() {
        List<Survey> feedbackList = new ArrayList<>();
        String query = "SELECT name, email, service, feedback FROM TS_SURVEY WHERE feedback IS NOT NULL";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                Survey survey = new Survey();
                survey.setName(rs.getString("name"));
                survey.setEmail(rs.getString("email"));
                survey.setService(rs.getString("service"));
                survey.setFeedback(rs.getString("feedback"));

                feedbackList.add(survey);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }
    
    // Fetch standout count for a specific category
    public int getStandoutCount(String standout) {
        String query = "SELECT COUNT(*) AS count FROM TS_SURVEY WHERE standout = ?";
        int count = 0;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            
            statement.setString(1, standout);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                count = rs.getInt("count");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // Fetch total count of surveys
    public int getTotalCount() {
        String query = "SELECT COUNT(*) AS total_count FROM TS_SURVEY";
        int totalCount = 0;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet rs = statement.executeQuery()) {

            if (rs.next()) {
                totalCount = rs.getInt("total_count");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totalCount;
    }

    // Submit a new survey
    public boolean submitSurvey(Survey survey) {
        String insertQuery = "INSERT INTO TS_SURVEY (NAME, SURVEY_DATE, EMAIL, SERVICE, RATING, STANDOUT, FEEDBACK) " +
                             "VALUES (?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?, ?, ?)";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(insertQuery)) {

            statement.setString(1, survey.getName() != null ? survey.getName() : "ANONYMOUS");
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
    
    // Fetch a paginated list of surveys
    public List<Survey> getPaginatedSurveys(int page, int pageSize) {
        List<Survey> surveys = new ArrayList<>();
        String query = "SELECT * FROM TS_SURVEY ORDER BY survey_date DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, (page - 1) * pageSize); // Calculate the offset
            statement.setInt(2, pageSize); // Number of rows to fetch

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    Survey survey = new Survey();
                    survey.setName(rs.getString("name"));
                    survey.setDate(rs.getString("survey_date"));
                    survey.setEmail(rs.getString("email"));
                    survey.setService(rs.getString("service"));
                    survey.setRating(rs.getInt("rating"));
                    survey.setStandout(rs.getString("standout"));
                    survey.setFeedback(rs.getString("feedback"));

                    surveys.add(survey);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return surveys;
    }
}
