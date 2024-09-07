package com.tigersign.config;

import com.tigersign.dao.DatabaseConnection;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

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

@WebServlet("/adminOauth2callback")
public class AdminOAuthConfig extends HttpServlet {
    private static final String CLIENT_ID = "567397451737-96vf70q3a700obapeov5a43p52aq5mp6.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "#";
    private static final String REDIRECT_URI = "http://127.0.0.1:7101/TigerSign-ViewController-context-root/adminOauth2callback";
    private static final String AUTH_URL = "https://accounts.google.com/o/oauth2/auth";
    private static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String USER_INFO_URL = "https://openidconnect.googleapis.com/v1/userinfo";

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
                if (isAllowedAdmin(conn, email)) {
                    // Update admin information in the database
                    updateAdminInfo(conn, email, firstName, lastName, picture);

                    HttpSession session = request.getSession();
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userFirstName", firstName);
                    session.setAttribute("userLastName", lastName);
                    session.setAttribute("userPicture", picture);

                    response.sendRedirect("Admin/dashboard.jsp");
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

    private boolean isAllowedAdmin(Connection conn, String email) throws SQLException {
        String query = "SELECT COUNT(*) FROM TS_ADMIN WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    private void updateAdminInfo(Connection conn, String email, String firstName, String lastName, String pictureUrl) throws SQLException {
        String query = "UPDATE TS_ADMIN SET firstname = ?, lastname = ?, picture = ? WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, firstName);
            stmt.setString(2, lastName);
            stmt.setString(3, pictureUrl); 
            stmt.setString(4, email);
            stmt.executeUpdate();
        }
    }

    public static String getAuthUrl() {
        String state = generateState();
        String authUrl = AUTH_URL + "?client_id=" + CLIENT_ID
                         + "&redirect_uri=" + REDIRECT_URI
                         + "&response_type=code"
                         + "&scope=openid+email+profile"
                         + "&state=" + state
                         + "&prompt=select_account";  
        return authUrl;
    }

    private static String generateState() {
        // Generate a random state string to prevent CSRF attacks
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

            try (CloseableHttpResponse response = httpClient.execute(httpPost)) {
                return EntityUtils.toString(response.getEntity());
            }
        }
    }

    private String getUserInfo(String accessToken) throws IOException {
        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            HttpGet httpGet = new HttpGet(USER_INFO_URL);
            httpGet.setHeader("Authorization", "Bearer " + accessToken);

            try (CloseableHttpResponse response = httpClient.execute(httpGet)) {
                return EntityUtils.toString(response.getEntity());
            }
        }
    }
}
