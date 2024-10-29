package com.tigersign.dao;

import java.sql.Timestamp;

public class AuditLog {
    private int id;
    private String activity;
    private Timestamp activityDateTime;
    private int adminId;
    private String firstName;
    private String lastName;
    private String position;
    private String picture;

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getActivity() {
        return activity;
    }

    public void setActivity(String activity) {
        this.activity = activity;
    }

    public Timestamp getActivityDateTime() {
        return activityDateTime;
    }

    public void setActivityDateTime(Timestamp activityDateTime) {
        this.activityDateTime = activityDateTime;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPosition() {
        if (position == null) {
            return null;
        }

        switch (position) {
            case "academic-clerk":
                return "Academic Clerk";
            case "records-officer":
                return "Records Officer";
            case "ict-support-representative":
                return "ICT Support Representative";
            case "supervisor":
                return "Supervisor";
            case "secretary":
                return "Secretary";
            case "liaison-officer":
                return "Liaison Officer";
            default:
                return position;
        }
    }

    public void setPosition(String position) {
        this.position = position;
    } 

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }
}
