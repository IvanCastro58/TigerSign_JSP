package com.tigersign.dao;

import java.sql.*;

public class PendingClaim {
    private String orNumber;
    private String customerName;
    private Timestamp dateProcessed;
    private String college;
    private String feeName;
    private String fileStatus;

    // Constructor for package
    public PendingClaim(String orNumber, String customerName, Timestamp dateProcessed, String college, String feeName) {
        this.orNumber = orNumber;
        this.customerName = customerName;
        this.dateProcessed = dateProcessed;
        this.college = college;
        this.feeName = feeName;
    }
    
    // Constructor for TS_REQUEST TABLE
    public PendingClaim(String orNumber, String feeName, String fileStatus, String customerName, String college, Timestamp dateProcessed) {
        this.orNumber = orNumber;
        this.feeName = feeName;
        this.fileStatus = fileStatus; 
        this.customerName = customerName;
        this.college = college;
        this.dateProcessed = dateProcessed;
    }

    // Getters
    public String getOrNumber() { return orNumber; }
    public String getCustomerName() { return customerName; }
    public Timestamp getDateProcessed() { return dateProcessed; }
    public String getCollege() { return college; }
    public String getFeeName() { return feeName; }
    public String getFileStatus() { return fileStatus; }
    
    // Setter for fileStatus
    public void setFileStatus(String fileStatus) {
        this.fileStatus = fileStatus;
    }
}


//public class PendingClaim {
//    private int id;
//    private String transactionId;
//    private String name;
//    private String email;
//    private String status;
//    private String college;
//    private String dateProcessed;
//    private String files;
//
//    // Getters and Setters
//    public int getId() {
//        return id;
//    }
//
//    public void setId(int id) {
//        this.id = id;
//    }
//
//    public String getTransactionId() {
//        return transactionId;
//    }
//
//    public void setTransactionId(String transactionId) {
//        this.transactionId = transactionId;
//    }
//
//    public String getName() {
//        return name;
//    }
//
//    public void setName(String name) {
//        this.name = name;
//    }
//
//    public String getEmail() {
//        return email;
//    }
//
//    public void setEmail(String email) {
//        this.email = email;
//    }
//
//    public String getStatus() {
//        return status;
//    }
//
//    public void setStatus(String status) {
//        this.status = status;
//    }
//
//    public String getCollege() {
//        return college;
//    }
//
//    public void setCollege(String college) {
//        this.college = college;
//    }
//
//    public String getDateProcessed() {
//        return dateProcessed;
//    }
//
//    public void setDateProcessed(String dateProcessed) {
//        this.dateProcessed = dateProcessed;
//    }
//
//    public String getFiles() {
//        return files;
//    }
//
//    public void setFiles(String files) {
//        this.files = files;
//    }
//}
