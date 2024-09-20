package com.tigersign.config;

import com.tigersign.dao.DatabaseConnection;

import com.warrenstrange.googleauth.GoogleAuthenticator;
import com.warrenstrange.googleauth.GoogleAuthenticatorKey;
import com.warrenstrange.googleauth.GoogleAuthenticatorQRGenerator;

import java.io.IOException;

import java.security.SecureRandom;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
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

@WebServlet("/oauth2callback")
public class GoogleOAuthConfig extends HttpServlet {
    private static final String CLIENT_ID = "567397451737-96vf70q3a700obapeov5a43p52aq5mp6.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "#";
    private static final String REDIRECT_URI = "http://127.0.0.1:7101/TigerSign-ViewController-context-root/oauth2callback";
    private static final String AUTH_URL = "https://accounts.google.com/o/oauth2/auth";
    private static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String USER_INFO_URL = "https://openidconnect.googleapis.com/v1/userinfo";
    private GoogleAuthenticator gAuth = new GoogleAuthenticator();

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
                if (isAllowedSuperAdmin(conn, email)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userFirstName", firstName);
                    session.setAttribute("userLastName", lastName);
                    session.setAttribute("userPicture", picture);

                    String secret = getTOTPSecret(conn, email);
                    if (secret != null) {
                        response.sendRedirect("SuperAdmin/verify_superadmin.jsp");
                    } else {
                        String setupUrl = getTOTPSetupUrl(request, email);  
                        request.getRequestDispatcher("SuperAdmin/totp_setup.jsp").forward(request, response);
                    }
                } else {
                    response.sendRedirect("error/error_unauthorized.jsp");
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
        String email = (String) session.getAttribute("userEmail");

        try (Connection conn = DatabaseConnection.getConnection()) {
            String secret = getTOTPSecret(conn, email);
            if (secret != null) {
                GoogleAuthenticator gAuth = new GoogleAuthenticator();
                boolean isCodeValid = gAuth.authorize(secret, Integer.parseInt(otp));

                if (isCodeValid) {
                    response.sendRedirect("SuperAdmin/dashboard.jsp");
                } else {
                    response.sendRedirect("error/error_invalid_otp.jsp");
                }
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "TOTP secret not found for user.");
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private boolean isAllowedSuperAdmin(Connection conn, String email) throws SQLException {
        String query = "SELECT COUNT(*) FROM TS_SUPERADMIN WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }

    private String getTOTPSecret(Connection conn, String email) throws SQLException {
        String query = "SELECT totp_secret FROM TS_SUPERADMIN WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getString("totp_secret") : null;
        }
    }

    private String getTOTPSetupUrl(HttpServletRequest request, String email) {
        GoogleAuthenticatorKey key = gAuth.createCredentials();
        String secret = key.getKey();
        String qrUrl = GoogleAuthenticatorQRGenerator.getOtpAuthURL("TigerSign", email, key);

        try (Connection conn = DatabaseConnection.getConnection()) {
            String updateQuery = "UPDATE TS_SUPERADMIN SET totp_secret = ? WHERE email = ?";
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

    private String getTokenResponse(String code) throws IOException {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpPost httpPost = new HttpPost(TOKEN_URL);
        httpPost.setHeader("Content-Type", "application/x-www-form-urlencoded");

        List<NameValuePair> params = new ArrayList<>();
        params.add(new BasicNameValuePair("grant_type", "authorization_code"));
        params.add(new BasicNameValuePair("code", code));
        params.add(new BasicNameValuePair("redirect_uri", REDIRECT_URI));
        params.add(new BasicNameValuePair("client_id", CLIENT_ID));
        params.add(new BasicNameValuePair("client_secret", CLIENT_SECRET));
        httpPost.setEntity(new UrlEncodedFormEntity(params));

        try (CloseableHttpResponse response = httpClient.execute(httpPost)) {
            return EntityUtils.toString(response.getEntity());
        }
    }

    private String getUserInfo(String accessToken) throws IOException {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpGet httpGet = new HttpGet(USER_INFO_URL);
        httpGet.setHeader("Authorization", "Bearer " + accessToken);

        try (CloseableHttpResponse response = httpClient.execute(httpGet)) {
            return EntityUtils.toString(response.getEntity());
        }
    }

    private static String generateState() {
        Random random = new SecureRandom();
        return String.valueOf(random.nextLong());
    }
}