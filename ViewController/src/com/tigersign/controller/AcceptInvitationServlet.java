package com.tigersign.controller;

import com.tigersign.dao.DatabaseConnection;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/accept-invitation")
public class AcceptInvitationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email != null && !email.isEmpty()) {
            if (isEmailAlreadyAdmin(email)) {
                response.getWriter().write("This invitation has already been accepted.");
            } else if (addAdminToDatabase(email)) {
                response.getWriter().write("Invitation accepted successfully. You are now an admin.");
            } else {
                response.getWriter().write("Failed to accept invitation. Please try again.");
            }
        } else {
            response.getWriter().write("Invalid email address.");
        }
    }

    private boolean isEmailAlreadyAdmin(String email) {
        String checkSQL = "SELECT COUNT(*) FROM TS_ADMIN WHERE EMAIL = ? AND STATUS = 'ACTIVE'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(checkSQL)) {

            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; 
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean addAdminToDatabase(String email) {
        String insertSQL = "INSERT INTO TS_ADMIN (EMAIL, FIRSTNAME, LASTNAME, PICTURE, STATUS) VALUES (?, NULL, NULL, NULL, 'ACTIVE')";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(insertSQL)) {

            pstmt.setString(1, email);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
