package com.tigersign.config;

import java.io.IOException;

import java.security.SecureRandom;

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code != null) {
            // Exchange code for access token
            String tokenResponse = getTokenResponse(code);
            JSONObject tokenJson = new JSONObject(tokenResponse);

            // Check for errors in the token response
            if (tokenJson.has("error")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error obtaining access token: " + tokenJson.getString("error"));
                return;
            }

            String accessToken = tokenJson.getString("access_token");

            // Get user info
            String userInfoResponse = getUserInfo(accessToken);
            JSONObject userInfoJson = new JSONObject(userInfoResponse);
            String email = userInfoJson.getString("email");
            String name = userInfoJson.optString("name", "N/A");
            String picture = userInfoJson.optString("picture", "");

            // Authenticate user
            if (email.endsWith("@ust.edu.ph")) {
                // Store user details in session
                HttpSession session = request.getSession();
                session.setAttribute("userEmail", email);
                session.setAttribute("userName", name);
                session.setAttribute("userPicture", picture);

                // Login successful, redirect to protected page
                response.sendRedirect("protected-page.jsp");
            } else {
                // Login failed, display error message
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid email domain");
            }
        } else {
            // Redirect to Google authorization page
            String authUrl = getAuthUrl();
            response.sendRedirect(authUrl);
        }
    }

    private static String generateState() {
        Random random = new SecureRandom();
        String state = String.valueOf(random.nextLong());
        return state;
    }

    public static String getAuthUrl() {
        String state = generateState();
        String authUrl = AUTH_URL + "?client_id=" + CLIENT_ID + "&redirect_uri=" + REDIRECT_URI + "&response_type=code&scope=openid+email+profile&state=" + state;
        return authUrl;
    }

    private String getTokenResponse(String code) throws IOException {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpPost httpPost = new HttpPost(TOKEN_URL);

        // Set the Content-Type header
        httpPost.setHeader("Content-Type", "application/x-www-form-urlencoded");

        // URL-encoded parameters
        List<NameValuePair> params = new ArrayList<>();
        params.add(new BasicNameValuePair("grant_type", "authorization_code"));
        params.add(new BasicNameValuePair("code", code));
        params.add(new BasicNameValuePair("redirect_uri", REDIRECT_URI));
        params.add(new BasicNameValuePair("client_id", CLIENT_ID));
        params.add(new BasicNameValuePair("client_secret", CLIENT_SECRET));
        httpPost.setEntity(new UrlEncodedFormEntity(params));

        // Execute the request
        CloseableHttpResponse response = httpClient.execute(httpPost);
        String responseBody = EntityUtils.toString(response.getEntity());

        // Log the response body
        System.out.println("Token Response: " + responseBody);

        return responseBody;
    }

    private String getUserInfo(String accessToken) throws IOException {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpGet httpGet = new HttpGet(USER_INFO_URL);
        httpGet.setHeader("Authorization", "Bearer " + accessToken);

        CloseableHttpResponse response = httpClient.execute(httpGet);
        String responseBody = EntityUtils.toString(response.getEntity());

        // Log the user info response body
        System.out.println("User Info Response: " + responseBody);

        return responseBody;
    }
}

