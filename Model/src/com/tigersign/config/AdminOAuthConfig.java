package com.tigersign.config;

import com.tigersign.dao.DatabaseConnection;

import com.warrenstrange.googleauth.GoogleAuthenticator;
import com.warrenstrange.googleauth.GoogleAuthenticatorConfig;
import com.warrenstrange.googleauth.GoogleAuthenticatorConfig.GoogleAuthenticatorConfigBuilder;
import com.warrenstrange.googleauth.GoogleAuthenticatorKey;
import com.warrenstrange.googleauth.GoogleAuthenticatorQRGenerator;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import org.json.JSONObject;

@WebServlet("/adminOauth2callback")
public class AdminOAuthConfig extends HttpServlet {
    private static final String CLIENT_ID = "567397451737-96vf70q3a700obapeov5a43p52aq5mp6.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "#";
    private static final String REDIRECT_URI = "https://registrarbeta.ust.edu.ph/tigersign/adminOauth2callback";
    //private static final String REDIRECT_URI = "http://127.0.0.1:7101/TigerSign-ViewController-context-root/adminOauth2callback";
    private static final String AUTH_URL = "https://accounts.google.com/o/oauth2/auth";
    private static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String USER_INFO_URL = "https://openidconnect.googleapis.com/v1/userinfo";
    private static final GoogleAuthenticatorConfig config = new GoogleAuthenticatorConfigBuilder()
            .setTimeStepSizeInMillis(30000) 
            .setWindowSize(1)              
            .build();

    private final GoogleAuthenticator gAuth = new GoogleAuthenticator(config);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code != null) {
            String tokenResponse = getTokenResponse(code);
            JSONObject tokenJson = new JSONObject(tokenResponse);

            if (tokenJson.has("error")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error obtaining access token: " + tokenJson.getString("error"));
                return;
            }

            String accessToken = tokenJson.getString("access_token");
            String userInfoResponse = getUserInfo(accessToken);
            JSONObject userInfoJson = new JSONObject(userInfoResponse);

            String email = userInfoJson.getString("email");
            String firstName = userInfoJson.optString("given_name", "N/A");
            String lastName = userInfoJson.optString("family_name", "N/A");
            String picture = userInfoJson.optString("picture", "");

            try (Connection conn = DatabaseConnection.getConnection()) {
                String adminStatus = checkAdminStatus(conn, email);
                if ("ACTIVE".equals(adminStatus)) {
                    // Update the admin's information in the database
                    updateAdminInfo(conn, email, firstName, lastName, picture);

                    HttpSession session = request.getSession();
                    session.setAttribute("adminEmail", email);
                    session.setAttribute("adminFirstName", firstName);
                    session.setAttribute("adminLastName", lastName);
                    session.setAttribute("adminPicture", picture);

                    // Get TOTP secret
                    String secret = getTOTPSecret(conn, email);

                    if (secret == null) {
                        String setupUrl = getTOTPSetupUrl(request, email);
                        request.setAttribute("setupUrl", setupUrl);
                        request.getRequestDispatcher("Admin/totp_setup_admin.jsp").forward(request, response);
                        return;
                    }

                    // Check for remember me cookie only if the TOTP secret is not null
                    Cookie[] cookies = request.getCookies();
                    boolean rememberMe = false;

                    if (cookies != null) {
                        for (Cookie cookie : cookies) {
                            if ("rememberMe".equals(cookie.getName()) && cookie.getValue().equals(email)) {
                                rememberMe = true;
                                break;
                            }
                        }
                    }

                    if (rememberMe) {
                        response.sendRedirect("https://registrarbeta.ust.edu.ph/tigersign/Admin/dashboard.jsp");
                        //response.sendRedirect("Admin/dashboard.jsp");
                    } else {
                        response.sendRedirect("https://registrarbeta.ust.edu.ph/tigersign/Admin/verify_admin.jsp");
                        //response.sendRedirect("Admin/verify_admin.jsp");
                    }
                } else if ("DEACTIVATED".equals(adminStatus)) {
                    response.sendRedirect("https://registrarbeta.ust.edu.ph/tigersign/error/error_deactivated_admin.jsp");
                    //response.sendRedirect("error/error_deactivated_admin.jsp");
                } else {
                    response.sendRedirect("https://registrarbeta.ust.edu.ph/tigersign/error/error_unauthorized_admin.jsp");
                    //response.sendRedirect("error/error_unauthorized_admin.jsp");
                }
            } catch (SQLException e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
            }
        } else {
            String authUrl = getAuthUrl();
            response.sendRedirect(authUrl);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String otp = request.getParameter("otp");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("adminEmail");

        boolean rememberMe = request.getParameter("rememberMe") != null;

        try (Connection conn = DatabaseConnection.getConnection()) {
            String secret = getTOTPSecret(conn, email);
            if (secret != null) {
                try {
                    boolean isCodeValid = gAuth.authorize(secret, Integer.parseInt(otp));

                    if (isCodeValid) {
                        if (rememberMe) {
                            Cookie rememberMeCookie = new Cookie("rememberMe", email);
                            rememberMeCookie.setMaxAge(60 * 60 * 24 * 30); // 1 month
                            response.addCookie(rememberMeCookie);
                        }
                        response.sendRedirect("https://registrarbeta.ust.edu.ph/tigersign/Admin/dashboard.jsp");
                        //response.sendRedirect("Admin/dashboard.jsp");
                    } else {
                        request.setAttribute("errorMessage", "Invalid TOTP");
                        request.getRequestDispatcher("/Admin/verify_admin.jsp").forward(request, response);
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid TOTP");
                    request.getRequestDispatcher("/Admin/verify_admin.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Invalid TOTP");
                request.getRequestDispatcher("/Admin/verify_admin.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void updateAdminInfo(Connection conn, String email, String firstName, String lastName, String picture) throws SQLException {
        String updateQuery = "UPDATE TS_ADMIN SET firstname = ?, lastname = ?, picture = ?, is_verified = 'Y' WHERE email = ? AND is_verified = 'N'";
        try (PreparedStatement stmt = conn.prepareStatement(updateQuery)) {
            stmt.setString(1, firstName);
            stmt.setString(2, lastName);
            stmt.setString(3, picture);
            stmt.setString(4, email);
            stmt.executeUpdate();
        }
    }

    private String checkAdminStatus(Connection conn, String email) throws SQLException {
        String query = "SELECT status FROM TS_ADMIN WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("status");
            }
        }
        return null;
    }

    private String getTOTPSecret(Connection conn, String email) throws SQLException {
        String query = "SELECT totp_secret FROM TS_ADMIN WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("totp_secret");
            }
        }
        return null;
    }

    private String getTOTPSetupUrl(HttpServletRequest request, String email) {
        GoogleAuthenticatorKey key = gAuth.createCredentials();
        String secret = key.getKey();
        String qrUrl = GoogleAuthenticatorQRGenerator.getOtpAuthURL("TigerSign", email, key);

        try (Connection conn = DatabaseConnection.getConnection()) {
            String updateQuery = "UPDATE TS_ADMIN SET totp_secret = ? WHERE email = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateQuery)) {
                stmt.setString(1, secret);
                stmt.setString(2, email);
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("setupUrl", qrUrl);
        request.setAttribute("setupKey", secret);

        return qrUrl;
    }

    public static String getAuthUrl() {
        String state = generateState();
        return AUTH_URL + "?client_id=" + CLIENT_ID
                         + "&redirect_uri=" + REDIRECT_URI
                         + "&response_type=code"
                         + "&scope=openid+email+profile"
                         + "&state=" + state
                         + "&prompt=select_account";
    }

    private static String generateState() {
        return java.util.UUID.randomUUID().toString();
    }

    private String getTokenResponse(String code) throws IOException {
        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            HttpPost httpPost = new HttpPost(TOKEN_URL);
            httpPost.setHeader("Content-Type", "application/x-www-form-urlencoded");

            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("grant_type", "authorization_code"));
            params.add(new BasicNameValuePair("code", code));
            params.add(new BasicNameValuePair("redirect_uri", REDIRECT_URI));
            params.add(new BasicNameValuePair("client_id", CLIENT_ID));
            params.add(new BasicNameValuePair("client_secret", CLIENT_SECRET));

            httpPost.setEntity(new UrlEncodedFormEntity(params));

            try (CloseableHttpResponse httpResponse = httpClient.execute(httpPost)) {
                return EntityUtils.toString(httpResponse.getEntity());
            }
        }
    }

    private String getUserInfo(String accessToken) throws IOException {
        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            HttpGet httpGet = new HttpGet(USER_INFO_URL);
            httpGet.setHeader("Authorization", "Bearer " + accessToken);

            try (CloseableHttpResponse httpResponse = httpClient.execute(httpGet)) {
                return EntityUtils.toString(httpResponse.getEntity());
            }
        }
    }
}
