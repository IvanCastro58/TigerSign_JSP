package com.tigersign.controller;

import com.tigersign.dao.Admin;
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
    
    private Admin getAdminDetails(String email) {
        Admin admin = null;
        String query = "SELECT ID, FIRSTNAME, LASTNAME, EMAIL, STATUS, PICTURE FROM TS_ADMIN WHERE EMAIL = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    admin = new Admin();
                    admin.setId(rs.getInt("ID"));
                    admin.setFirstname(rs.getString("FIRSTNAME"));
                    admin.setLastname(rs.getString("LASTNAME"));
                    admin.setEmail(rs.getString("EMAIL"));
                    admin.setStatus(rs.getString("STATUS"));
                    admin.setPicture(rs.getString("PICTURE")); 
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return admin;
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("admin-email");

        if (email != null && !email.isEmpty()) {
            if (!isValidDomain(email)) {
                request.setAttribute("showModal", true);
                request.setAttribute("invalidDomain", true);
                request.getRequestDispatcher("manage_account.jsp").forward(request, response);
            }

            Admin admin = getAdminDetails(email);
            if (admin != null) {
                request.setAttribute("userId", admin.getId());
                request.setAttribute("existingFirstname", admin.getFirstname());
                request.setAttribute("existingLastname", admin.getLastname());
                request.setAttribute("existingEmail", admin.getEmail());
                request.setAttribute("existingStatus", admin.getStatus());
                request.setAttribute("existingPicture", admin.getPicture());

                request.getRequestDispatcher("manage_account.jsp").forward(request, response);
            } else {
                boolean emailSent = sendInvitationEmail(email);
                if (emailSent) {
                    response.sendRedirect(request.getContextPath() + "/SuperAdmin/manage_account.jsp?success=true");
                } else {
                    response.sendRedirect(request.getContextPath() + "/SuperAdmin/manage_account.jsp?failed=true");
                }
            }
        } else {
            response.getWriter().write("Invalid email address.");
        }
    }

    private boolean isValidDomain(String email) {
        return email.endsWith("@ust.edu.ph") || email.endsWith("@gmail.com");
        //return email.endsWith("@ust.edu.ph");
    }

    private boolean sendInvitationEmail(String recipientEmail) {
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
            message.setSubject("Admin Invitation - TigerSign");

            String content = "<div style='width: 100%; max-width: 1250px; margin: 0 auto; text-align: center; background-color: #f9f9f9; padding: 20px; font-family: Montserrat, sans-serif;'>"
                            + "<div style='display: inline-block; width: 100%; max-width: 400px; background-color: white; border: 1px solid #ddd; padding: 30px 20px; box-sizing: border-box;'>"
                            + "<img src='https://drive.google.com/uc?id=1BU7bQH5ZnZGwokJlNhyhHGGPn_nk_R7h' alt='TigerSign Logo' style='width: 100px; height: 100px; margin-bottom: 20px; border-radius: 20px; pointer-events: none;'>"
                            + "<hr style='border: none; height: 2px; background-color: #F4BB00; margin-bottom: 20px;'>"
                            + "<h2 style='color: #333; width: fit-content; border-bottom: 3px solid #F4BB00;'>Admin Invitation</h2>"
                            + "<p style='font-size: 14px; color: #555;'>You have been invited to become an Admin for TigerSign. As an Admin, you will have access to select features and responsibilities within the system.</p>"
                            + "<p style='font-size: 14px; color: #555;'>Please click the button below to accept the invitation and create your account. For security reasons, this link will expire in 48 hours. If you have any questions or did not request this invitation, please contact our support team immediately.</p>"
                            + "<a href='http://127.0.0.1:7101/TigerSign-ViewController-context-root/accept-invitation?email=" + recipientEmail + "' "
                            + "style='background-color: #F4BB00; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; margin-top: 20px; font-weight: 600; font-family: Montserrat, sans-serif;'>Accept Invitation</a>"
                            + "<p style='font-size: 12px; color: #999; margin-top: 20px;'>If the button does not work, copy and paste the following link into your browser: "
                            + "http://127.0.0.1:7101/TigerSign-ViewController-context-root/accept-invitation?email=" + recipientEmail + "</p>"
                            + "<p style='font-size: 12px; color: #999;'>Thank you for being part of the TigerSign community. We look forward to your contributions as an Admin!</p>"
                            + "</div>"
                            + "</div>";


            message.setContent(content, "text/html");

            Transport.send(message);
            return true;  
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;  
        }
    }
}
