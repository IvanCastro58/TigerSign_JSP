package com.tigersign.dao;

import java.io.UnsupportedEncodingException;

import java.net.URLEncoder;

import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import javax.servlet.http.HttpServletRequest;

public class EmailService {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_USERNAME = "cipcastro123@gmail.com";
    private static final String EMAIL_PASSWORD = "wkymehsbbmwwjfso";  
    private static final ExecutorService executorService = Executors.newFixedThreadPool(5); // Create a thread pool

    public boolean sendSurveyEmail(String email, HttpServletRequest request) {
        try {
            executorService.submit(() -> {
                String subject = "Survey/Evaluation Form Link - TigerSign";
                String surveyLink = "http://127.0.0.1:7101/TigerSign-ViewController-context-root/pages/survey_claimer.jsp"; 
                String redirectPage = "http://127.0.0.1:7101/TigerSign-ViewController-context-root/pages/redirecting.jsp"; 

                String encodedSurveyLink;
                try {
                    encodedSurveyLink = URLEncoder.encode(surveyLink, "UTF-8");
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                    return;
                }

                String content = "<div style='width: 100%; max-width: 1250px; margin: 0 auto; text-align: center; background-color: #f9f9f9; padding: 20px; font-family: Montserrat, sans-serif;'>"
                        + "<div style='display: inline-block; width: 100%; max-width: 700px; background-color: white; border: 1px solid #ddd; padding: 30px 20px; box-sizing: border-box;'>"
                        + "<img src='https://drive.google.com/uc?id=1BU7bQH5ZnZGwokJlNhyhHGGPn_nk_R7h' alt='TigerSign Logo' style='width: 100px; height: 100px; margin-bottom: 20px; border-radius: 20px; pointer-events: none;'>"
                        + "<hr style='border: none; height: 3px; background-color: #F4BB00; margin-bottom: 20px;'>"
                        + "<h2 style='color: #333;'>Thank You for Your Submission</h2>"
                        + "<p style='font-size: 14px; color: #555;'>Your proof of document has been successfully submitted and secured.</p>"
                        + "<p style='font-size: 14px; color: #555;'>We value your feedback! Please take a moment to complete our survey to share your experience with our service.</p>"
                        + "<a href='" + redirectPage + "?redirect=" + encodedSurveyLink + "' style='background-color: #F4BB00; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; margin-top: 20px; font-weight: 600; font-family: Montserrat, sans-serif;'>Take Survey</a>"
                        + "<p style='font-size: 12px; color: #777;'>Thank you for using TigerSign.</p>"
                        + "</div>"
                        + "</div>";

                Properties props = new Properties();
                props.put("mail.smtp.host", SMTP_HOST);
                props.put("mail.smtp.port", SMTP_PORT);
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");

                Session mailSession = Session.getInstance(props, new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
                    }
                });

                try {
                    MimeMessage message = new MimeMessage(mailSession);
                    message.setFrom(new InternetAddress(EMAIL_USERNAME));
                    message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
                    message.setSubject(subject);
                    message.setContent(content, "text/html");
                    Transport.send(message);
                } catch (MessagingException e) {
                    e.printStackTrace();
                }
            });
            return true; // Return true if email was sent
        } catch (Exception e) {
            e.printStackTrace();
            return false; // Return false if there was an error
        }
    }
}
