package com.tigersign.controller;

import com.tigersign.dao.DatabaseConnection;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

@WebServlet("/SuperAdmin/send-invitation")
public class SendInvitationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("admin-email");

        if (email != null && !email.isEmpty()) {
            if (!isValidDomain(email)) {
                response.getWriter().write("Invalid email domain. Only 'ust.edu.ph' emails are allowed.");
                return;
            }

            if (isEmailExisting(email)) {
                response.getWriter().write("User with this email already exists as an admin.");
            } else {
                sendInvitationEmail(email);
                response.getWriter().write("Invitation sent successfully.");
            }
        } else {
            response.getWriter().write("Invalid email address.");
        }
    }

    private boolean isValidDomain(String email) {
        return email.endsWith("@ust.edu.ph") || email.endsWith("@gmail.com");
        //return email.endsWith("@ust.edu.ph");
    }

    private boolean isEmailExisting(String email) {
        String query = "SELECT COUNT(*) FROM TS_ADMIN WHERE EMAIL = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

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

    private void sendInvitationEmail(String recipientEmail) {
        final String host = "smtp.gmail.com";
        final String user = "cipcastro123@gmail.com";
        final String password = "wkymehsbbmwwjfso";

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(user));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
            message.setSubject("Admin Invitation");

            String content = "<div style='width: 100%; max-width: 1250px; margin: 0 auto; text-align: center; background-color: #f9f9f9; padding: 20px; font-family: Montserrat, sans-serif;'>"
                            + "<div style='display: inline-block; width: 100%; max-width: 400px; background-color: white; border: 1px solid #ddd; padding: 30px 20px; box-sizing: border-box;'>"
                            + "<img src='http://127.0.0.1:7101/TigerSign-ViewController-context-root/resources/images/tigersign-logo.png' alt='TigerSign Logo' style='width: 150px; margin-bottom: 20px;'>"
                            + "<hr style='border: none; height: 2px; background-color: #F4BB00; margin-bottom: 20px;'>"
                            + "<h2 style='color: #333;'>Admin Invitation</h2>"
                            + "<p style='font-size: 14px; color: #555;'>You have been invited to become an Admin for TigerSign. Please click the button below to accept the invitation and create your account.</p>"
                            + "<a href='http://127.0.0.1:7101/TigerSign-ViewController-context-root/accept-invitation?email=" + recipientEmail + "' "
                            + "style='background-color: #F4BB00; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; margin-top: 20px; font-weight: 600; font-family: Montserrat, sans-serif;'>Accept Invitation</a>"
                            + "</div>"
                            + "</div>";

            message.setContent(content, "text/html");

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
