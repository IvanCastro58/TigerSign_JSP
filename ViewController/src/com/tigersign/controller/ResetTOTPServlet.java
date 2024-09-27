package com.tigersign.controller;

import com.tigersign.dao.DatabaseConnection;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/reset-totp")
public class ResetTOTPServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");
        Boolean resetInitiated = (Boolean) session.getAttribute("resetInitiated");

        // Check if the email is available and reset hasn't already been initiated
        if (email != null && (resetInitiated == null || !resetInitiated)) {
            sendResetEmail(email, request);
            session.setAttribute("resetInitiated", true);  
            response.sendRedirect("SuperAdmin/confirmation_reset.jsp");
        } else if (resetInitiated != null && resetInitiated) {
            response.sendRedirect("SuperAdmin/already_reset.jsp"); 
        } else {
            response.sendRedirect("error/error_not_logged_in.jsp");
        }
    }

    private void sendResetEmail(String email, HttpServletRequest request) {
        String subject = "Reset Your TOTP Authentication - TigerSign";
        String resetLink = request.getRequestURL().toString() + "?action=confirm&email=" + email;

        String content = "<div style='width: 100%; max-width: 1250px; margin: 0 auto; text-align: center; background-color: #f9f9f9; padding: 20px; font-family: Montserrat, sans-serif;'>"
                        + "<div style='display: inline-block; width: 100%; max-width: 400px; background-color: white; border: 1px solid #ddd; padding: 30px 20px; box-sizing: border-box;'>"
                        + "<img src='https://drive.google.com/uc?id=1BU7bQH5ZnZGwokJlNhyhHGGPn_nk_R7h' alt='TigerSign Logo' style='width: 100px; height: 100px; margin-bottom: 20px; border-radius: 20px; pointer-events: none;'>"
                        + "<hr style='border: none; height: 3px; background-color: #F4BB00; margin-bottom: 20px;'>"
                        + "<h2 style='color: #333; width: fit-content; border-bottom: 3px solid #F4BB00;'>Reset Your TOTP Authentication</h2>"
                        + "<p style='font-size: 14px; color: #555;'>Click the button below to reset your TOTP secret for TigerSign.</p>"
                        + "<form action='" + resetLink + "' method='POST'>"
                        + "<input type='hidden' name='action' value='confirm'>"
                        + "<input type='hidden' name='email' value='" + email + "'>"
                        + "<button type='submit' style='background-color: #F4BB00; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; margin-top: 20px; font-weight: 600; font-family: Montserrat, sans-serif;'>Reset TOTP</button>"
                        + "</form>"
                        + "<p style='font-size: 12px; color: #777; font-style: italic; margin-top: 20px;'>If you did not request your authenticator to be reset, please ignore this email.</p>"
                        + "<p style='font-size: 12px; color: #777;'>Thank you for using TigerSign.</p>"
                        + "</div>"
                        + "</div>";

        // Set up email properties
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session mailSession = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("cipcastro123@gmail.com", "wkymehsbbmwwjfso");
            }
        });

        try {
            MimeMessage message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress("cipcastro123@gmail.com"));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
            message.setSubject(subject);
            message.setContent(content, "text/html");

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        HttpSession session = request.getSession();

        if ("confirm".equals(action) && email != null) {
            try (Connection conn = DatabaseConnection.getConnection()) {
                Boolean resetConfirmed = (Boolean) session.getAttribute("resetConfirmed");

                if (resetConfirmed == null || !resetConfirmed) {
                    resetTOTPSecret(conn, email);
                    session.setAttribute("resetConfirmed", true);  // Prevent multiple resets
                    response.sendRedirect("SuperAdmin/success_reset.jsp");
                } else {
                    response.sendRedirect("SuperAdmin/already_reset.jsp");  // Redirect if already reset
                }
            } catch (SQLException e) {
                response.sendRedirect("error/error_database.jsp");
            }
        }
    }

    private void resetTOTPSecret(Connection conn, String email) throws SQLException {
        String updateQuery = "UPDATE TS_SUPERADMIN SET totp_secret = NULL WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(updateQuery)) {
            stmt.setString(1, email);
            stmt.executeUpdate();
        }
    }
}
