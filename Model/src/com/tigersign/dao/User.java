package com.tigersign.dao;


public class User {
    private int id;
    private String picture;  
    private String firstname;
    private String lastname;
    private String email;
    private String status;
    private String position;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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
    
    
}
