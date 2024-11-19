package com.tigersign.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

public class SurveyDAO {

    public List<Survey> getAllSurveys(String filterType, String filterValue) {
        List<Survey> surveys = new ArrayList<>();
        String query = "SELECT * FROM TS_SURVEY WHERE 1=1";

        if (filterType != null && !filterType.isEmpty()) {
            if ("day".equals(filterType)) {
                query += " AND TRUNC(survey_date) = TO_DATE(?, 'YYYY-MM-DD')";
            } else if ("month".equals(filterType)) {
                query += " AND TO_CHAR(survey_date, 'YYYY-MM') = ?";
            } else if ("year".equals(filterType)) {
                query += " AND TO_CHAR(survey_date, 'YYYY') = ?";
            } else if ("range".equals(filterType)) {
                query += " AND survey_date BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')";
            }
        }

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            if ("range".equals(filterType)) {
                String[] dates = filterValue.split(",");
                statement.setString(1, dates[0]);
                statement.setString(2, dates[1]);
            } else if (filterType != null && !filterType.isEmpty()) {
                statement.setString(1, filterValue);
            }

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

    public double getAverageScore(String filterType, String filterValue) {
        String query = "SELECT AVG(rating) AS avg_rating FROM TS_SURVEY WHERE 1=1";

        if (filterType != null && !filterType.isEmpty()) {
            if ("day".equals(filterType)) {
                query += " AND TRUNC(survey_date) = TO_DATE(?, 'YYYY-MM-DD')";
            } else if ("month".equals(filterType)) {
                query += " AND TO_CHAR(survey_date, 'YYYY-MM') = ?";
            } else if ("year".equals(filterType)) {
                query += " AND TO_CHAR(survey_date, 'YYYY') = ?";
            } else if ("range".equals(filterType)) {
                query += " AND survey_date BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')";
            }
        }

        double avgRating = 0.0;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            if ("range".equals(filterType)) {
                String[] dates = filterValue.split(",");
                statement.setString(1, dates[0]);
                statement.setString(2, dates[1]);
            } else if (filterType != null && !filterType.isEmpty()) {
                statement.setString(1, filterValue);
            }

            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    avgRating = rs.getDouble("avg_rating");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return avgRating;
    }

    public int getEvaluationReceivedCount(String filterType, String filterValue) {
        String query = "SELECT COUNT(*) AS eval_received_count FROM TS_SURVEY WHERE 1=1";

        if (filterType != null && !filterType.isEmpty()) {
            if ("day".equals(filterType)) {
                query += " AND TRUNC(survey_date) = TO_DATE(?, 'YYYY-MM-DD')";
            } else if ("month".equals(filterType)) {
                query += " AND TO_CHAR(survey_date, 'YYYY-MM') = ?";
            } else if ("year".equals(filterType)) {
                query += " AND TO_CHAR(survey_date, 'YYYY') = ?";
            } else if ("range".equals(filterType)) {
                query += " AND survey_date BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')";
            }
        }

        int evalReceivedCount = 0;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            if ("range".equals(filterType)) {
                String[] dates = filterValue.split(",");
                statement.setString(1, dates[0]);
                statement.setString(2, dates[1]);
            } else if (filterType != null && !filterType.isEmpty()) {
                statement.setString(1, filterValue);
            }

            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    evalReceivedCount = rs.getInt("eval_received_count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return evalReceivedCount;
    }

    public List<Survey> getServiceWindowScores(String filterType, String filterValue) {
        List<Survey> serviceScores = new ArrayList<>();
        String query = "SELECT service, AVG(rating) AS avg_rating, COUNT(*) AS eval_count FROM TS_SURVEY WHERE 1=1";

        if (filterType != null && !filterType.isEmpty()) {
            if ("day".equals(filterType)) {
                query += " AND TRUNC(survey_date) = TO_DATE(?, 'YYYY-MM-DD')";
            } else if ("month".equals(filterType)) {
                query += " AND TO_CHAR(survey_date, 'YYYY-MM') = ?";
            } else if ("year".equals(filterType)) {
                query += " AND TO_CHAR(survey_date, 'YYYY') = ?";
            } else if ("range".equals(filterType)) {
                query += " AND survey_date BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')";
            }
        }

        query += " GROUP BY service";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            if ("range".equals(filterType)) {
                String[] dates = filterValue.split(",");
                statement.setString(1, dates[0]);
                statement.setString(2, dates[1]);
            } else if (filterType != null && !filterType.isEmpty()) {
                statement.setString(1, filterValue);
            }

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    Survey survey = new Survey();
                    survey.setService(rs.getString("service"));
                    survey.setRating(rs.getInt("avg_rating"));
                    survey.setEvaluationCount(rs.getInt("eval_count"));
                    serviceScores.add(survey);
                }
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
    
    public int getStandoutCount(String standout, String filterType, String filterValue) {
        String query = "SELECT COUNT(*) AS count FROM TS_SURVEY WHERE standout = ?";

        if (filterType != null && !filterType.isEmpty()) {
            if ("day".equals(filterType)) {
                query += " AND TRUNC(survey_date) = TO_DATE(?, 'YYYY-MM-DD')";
            } else if ("month".equals(filterType)) {
                query += " AND TO_CHAR(survey_date, 'YYYY-MM') = ?";
            } else if ("year".equals(filterType)) {
                query += " AND TO_CHAR(survey_date, 'YYYY') = ?";
            } else if ("range".equals(filterType)) {
                query += " AND survey_date BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')";
            }
        }

        int count = 0;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            
            statement.setString(1, standout);

            if ("range".equals(filterType)) {
                String[] dates = filterValue.split(",");
                statement.setString(2, dates[0]);
                statement.setString(3, dates[1]);
            } else if (filterType != null && !filterType.isEmpty()) {
                statement.setString(2, filterValue);
            }

            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                count = rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }

    public int getTotalCount(String filterType, String filterValue) {
        String query = "SELECT COUNT(*) AS total_count FROM TS_SURVEY WHERE 1=1";

        if (filterType != null && !filterType.isEmpty()) {
            if ("day".equals(filterType)) {
                query += " AND TRUNC(survey_date) = TO_DATE(?, 'YYYY-MM-DD')";
            } else if ("month".equals(filterType)) {
                query += " AND TO_CHAR(survey_date, 'YYYY-MM') = ?";
            } else if ("year".equals(filterType)) {
                query += " AND TO_CHAR(survey_date, 'YYYY') = ?";
            } else if ("range".equals(filterType)) {
                query += " AND survey_date BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')";
            }
        }

        int totalCount = 0;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            if ("range".equals(filterType)) {
                String[] dates = filterValue.split(",");
                statement.setString(1, dates[0]);
                statement.setString(2, dates[1]);
            } else if (filterType != null && !filterType.isEmpty()) {
                statement.setString(1, filterValue);
            }

            ResultSet rs = statement.executeQuery();
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
}
