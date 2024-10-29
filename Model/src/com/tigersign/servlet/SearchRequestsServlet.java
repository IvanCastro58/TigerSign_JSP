package com.tigersign.servlet;

import com.tigersign.dao.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/SearchRequestsServlet")
public class SearchRequestsServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SearchRequestsServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orNumber = request.getParameter("or_number");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        LOGGER.log(Level.INFO, "Received OR Number: {0}", orNumber); // Log OR Number for debugging

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT REQUESTS, FILE_STATUS, ON_HOLD_REASON FROM TS_REQUEST WHERE OR_NUMBER = ?";
            try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                preparedStatement.setString(1, orNumber);
                ResultSet resultSet = preparedStatement.executeQuery();

                StringBuilder jsonBuilder = new StringBuilder();
                jsonBuilder.append("[");
                boolean first = true;
                while (resultSet.next()) {
                    if (!first) {
                        jsonBuilder.append(",");
                    }
                    String requestName = resultSet.getString("REQUESTS");
                    String fileStatus = resultSet.getString("FILE_STATUS");
                    String onHoldReason = resultSet.getString("ON_HOLD_REASON");

                    jsonBuilder.append("{\"request\":\"").append(requestName)
                                .append("\", \"status\":\"").append(fileStatus).append("\"");

                    // Explicitly include onHoldReason if the status is ON HOLD, even if null
                    if ("HOLD".equalsIgnoreCase(fileStatus)) {
                        jsonBuilder.append(", \"onHoldReason\":\"")
                                   .append(onHoldReason != null ? onHoldReason : "Reason not provided")
                                   .append("\"");
                    }

                    jsonBuilder.append("}");
                    first = false;
                }
                jsonBuilder.append("]");
                String jsonResponse = jsonBuilder.toString();

                LOGGER.log(Level.INFO, "JSON Response: {0}", jsonResponse); // Log JSON response
                out.print(jsonResponse);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Database or JSON error", e); // Log any exceptions
            out.print("[]"); // Return an empty array on error
        }
    }
}
