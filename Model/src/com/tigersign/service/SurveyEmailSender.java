import com.tigersign.dao.AuditLogger;
import com.tigersign.dao.DatabaseConnection;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SendSurveyServlet")
public class SurveyEmailSender extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ExecutorService emailExecutor;

    @Override
    public void init() throws ServletException {
        emailExecutor = Executors.newFixedThreadPool(5);
    }

    @Override
    public void destroy() {
        if (emailExecutor != null) {
            emailExecutor.shutdown();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = request.getParameter("email");

        String adminEmail = (String) session.getAttribute("adminEmail");
        String userEmail = (String) session.getAttribute("userEmail");

        if (email != null && !email.isEmpty()) {
            emailExecutor.submit(() -> {
                boolean emailSent = sendSurveyEmail(email, request);
                try {
                    if (!emailSent) {
                        redirectToSessionBasedPage(request, response, adminEmail, userEmail, email, false);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });
            redirectToSessionBasedPage(request, response, adminEmail, userEmail, email, true);
        } else {
            response.sendRedirect("error.jsp");
        }
    }

    private boolean sendSurveyEmail(String email, HttpServletRequest request) {
        String subject = "Survey/Evaluation Form Link - TigerSign";
        String surveyLink = "http://127.0.0.1:7101/TigerSign-ViewController-context-root/pages/survey_claimer.jsp";
        String redirectPage = "http://127.0.0.1:7101/TigerSign-ViewController-context-root/pages/redirecting.jsp";

        String encodedSurveyLink;
        try {
            encodedSurveyLink = java.net.URLEncoder.encode(surveyLink, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return false;
        }

        String content = "<div style='width: 100%; max-width: 1250px; margin: 0 auto; text-align: center; background-color: #f9f9f9; padding: 20px; font-family: Montserrat, sans-serif;'>"
                + "<div style='display: inline-block; width: 100%; max-width: 700px; background-color: white; border: 1px solid #ddd; padding: 30px 20px; box-sizing: border-box;'>"
                + "<img src='https://drive.google.com/uc?id=1DatL3-tYjSd9heipRcjXJsFTw64LyeaB' alt='TigerSign Logo' style='width: 400px; height: 50px; margin-bottom: 20px; pointer-events: none;'>"
                + "<hr style='border: none; height: 3px; background-color: #F4BB00; margin-bottom: 20px;'>"
                + "<center>"
                + "<h2 style='color: #333; width: fit-content; border-bottom: 3px solid #F4BB00;'>Survey/Evaluation Form</h2>"
                + "</center>"
                + "<p style='font-size: 14px; color: #555; margin-top: 20px;'>Thank you for visiting the Office of the Registrar and completing your procedures.</p>"
                + "<p style='font-size: 14px; color: #555;'>We strive to improve our services and would greatly appreciate it if you could take a moment to share your feedback through a brief survey. Your input is essential in helping us enhance the experience for all our visitors.</p>"
                + "<p style='font-size: 14px; color: #555;'>Please complete the survey by clicking the button below. Your responses will be treated with the utmost care and confidentiality.</p>"
                + "<a href='" + redirectPage + "?redirect=" + encodedSurveyLink
                + "' style='background-color: #F4BB00; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; margin-top: 20px; font-weight: 600; font-family: Montserrat, sans-serif;'>Take the Survey</a>"
                + "<p style='font-size: 12px; color: #777;'>We appreciate your time and thank you for helping us serve you better.</p>"
                + "</div>" + "</div>";

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
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private int getAdminId(String adminEmail) {
            int adminId = -1;
            String query = "SELECT ID FROM TS_ADMIN WHERE EMAIL = ?";
            try (Connection connection = DatabaseConnection.getConnection();
                 PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                preparedStatement.setString(1, adminEmail);
                ResultSet resultSet = preparedStatement.executeQuery();
                if (resultSet.next()) {
                    adminId = resultSet.getInt("ID");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return adminId;
    }

    private void redirectToSessionBasedPage(HttpServletRequest request, HttpServletResponse response, String adminEmail, String userEmail, String email, boolean success)
            throws IOException {
        String contextPath = request.getContextPath();
        String redirectPage = success ? "evaluation.jsp?success=true" : "evaluation.jsp?failed=true";

        if (adminEmail != null) {
            response.sendRedirect(contextPath + "/Admin/" + redirectPage);
            if (adminEmail != null) {
                AuditLogger.logActivity(adminEmail, "Sent a survey/evaluation form to the email address " + email);
            }
        } else if (userEmail != null) {
            response.sendRedirect(contextPath + "/SuperAdmin/" + redirectPage);
        } else {
            response.sendRedirect(contextPath + "/error.jsp");
        }
    }
}
