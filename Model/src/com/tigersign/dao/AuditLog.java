package com.tigersign.dao;

import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.List;

public class AuditLog {
    private int id;
    private String activity;
    private Timestamp activityDateTime;
    private int adminId;
    private String firstName;
    private String status;
    private String lastName;
    private String position;
    private String picture;
    private List<AuditDetail> details = new ArrayList<>();  

    public void addAuditDetail(String key, String value) {
        details.add(new AuditDetail(key, value));
    }

    public List<AuditDetail> getDetails() {
        return details;
    }
    
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
    
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public String getActivityClass() {
        switch (activity) {
            case "GENERATE":
                return "color: #d9534f;"; 
            case "UPDATE":
                return "color: #3B83FB;"; 
            case "RELEASE":
                return "color: #1C8454;"; 
            case "SEND SURVEY":
                return "color: #F4BB00;"; 
            default:
                return "color: gray;"; 
        }
    }

    public String getActivityIcon() {
        switch (activity) {
            case "GENERATE":
                return "fas fa-file-export";
            case "UPDATE":
                return "far fa-edit";
            case "RELEASE":
                return "far fa-check-square";
            case "SEND SURVEY":
                return "far fa-paper-plane";
            default:
                return "fas fa-question-circle";
        }
    }
}
