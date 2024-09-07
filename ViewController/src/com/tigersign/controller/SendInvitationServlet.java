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
        return email.endsWith("@ust.edu.ph");
    }

    private boolean isEmailExisting(String email) {
        String query = "SELECT COUNT(*) FROM TS_ADMIN WHERE EMAIL = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // Return true if the email exists in the table
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // Email does not exist in the table
    }

    private void sendInvitationEmail(String recipientEmail) {
        final String host = "smtp.gmail.com";
        final String user = "cipcastro123@gmail.com"; 
        final String password = "wkymehsbbmwwjfso"; 

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", "587"); // Gmail SMTP port
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // Enable TLS

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

            String content = "<p>You have been invited to become an Admin.</p>" +
                             "<p><a href='http://127.0.0.1:7101/TigerSign-ViewController-context-root/accept-invitation?email=" + recipientEmail + "'>Accept Invitation</a></p>";

            message.setContent(content, "text/html");

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
