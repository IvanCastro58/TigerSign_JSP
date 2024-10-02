package com.tigersign.dao;


public class Survey {
    private String name;
    private String date;
    private String email;
    private String service;
    private int rating;
    private String standout;
    private String feedback;
    private String otherService;
    private String standoutOther;

    public String getName() {
        return name;
    }

    public String getDate() {
        return date;
    }

    public String getEmail() {
        return email;
    }

    public String getService() {
        return service;
    }

    public int getRating() {
        return rating;
    }

    public String getStandout() {
        return standout;
    }

    public String getFeedback() {
        return feedback;
    }

    public String getOtherService() {
        return otherService;
    }

    public String getStandoutOther() {
        return standoutOther;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setService(String service) {
        this.service = service;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public void setStandout(String standout) {
        this.standout = standout;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public void setOtherService(String otherService) {
        this.otherService = otherService;
    }

    public void setStandoutOther(String standoutOther) {
        this.standoutOther = standoutOther;
    }
}
