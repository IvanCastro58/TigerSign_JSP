package com.tigersign.dao;


public class Survey {
    private String name;
    private String date;
    private String email;
    private String service;
    private int rating;
    private double windowRating;
    private String standout;
    private String feedback;
    private String otherService;
    private String standoutOther;
    private int evaluationCount;

    public String getMaskedName() {
        if ("Anonymous".equals(name)) {
            return "Anonymous"; 
        }

        if (name == null || name.isEmpty()) {
            return "****";
        }

        StringBuilder maskedName = new StringBuilder();
        String[] nameParts = name.split(" ");

        for (String part : nameParts) {
            if (part.length() > 1) {
                maskedName.append(part.charAt(0));
                for (int i = 1; i < part.length() - 1; i++) {
                    maskedName.append('*');
                }
                maskedName.append(part.charAt(part.length() - 1));
            } else {
                maskedName.append(part);
            }
            maskedName.append(" ");
        }

        return maskedName.toString().trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }
    
    public double getWindowRating() {
        return windowRating;
    }

    public void setWindowRating(double windowRating) {
        this.windowRating = windowRating;
    }

    public String getStandout() {
        return standout;
    }

    public void setStandout(String standout) {
        this.standout = standout;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public String getOtherService() {
        return otherService;
    }

    public void setOtherService(String otherService) {
        this.otherService = otherService;
    }

    public String getStandoutOther() {
        return standoutOther;
    }

    public void setStandoutOther(String standoutOther) {
        this.standoutOther = standoutOther;
    }

    public int getEvaluationCount() {
        return evaluationCount;
    }

    public void setEvaluationCount(int evaluationCount) {
        this.evaluationCount = evaluationCount;
    }
}
