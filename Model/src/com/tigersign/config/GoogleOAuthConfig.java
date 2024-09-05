package com.tigersign.config;


public class GoogleOAuthConfig {
    public static final String CLIENT_ID = "567397451737-9mus0q9n4gfialaqk323u58sair6iiuj.apps.googleusercontent.com";
    public static final String REDIRECT_URI = "http://127.0.0.1:7101/TigerSign-ViewController-context-root/oauth2callback";
    public static final String CLIENT_SECRET = "#"; 
    public static final String TOKEN_URI = "https://oauth2.googleapis.com/token";
    public static final String USERINFO_URI = "https://www.googleapis.com/oauth2/v3/userinfo";

    public static String getAuthorizationUrl() {
        String scope = "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile openid";
        return "https://accounts.google.com/o/oauth2/auth?" +
                "client_id=" + CLIENT_ID + 
                "&redirect_uri=" + REDIRECT_URI +
                "&response_type=code" +
                "&scope=" + scope +
                "&access_type=offline";
    }
}
