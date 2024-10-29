package com.tigersign.dao;

import java.sql.*;

public class PendingClaim {
    private String orNumber;
    private String customerName;
    private Timestamp dateProcessed;
    private String college;
    private String feeName;
    private String feeDesc;
    private String requestId;
    private String fileStatus;  

    // Update constructor to include fileStatus
    public PendingClaim(String orNumber, String customerName, Timestamp dateProcessed, String college, String feeName, String feeDesc, String requestId, String fileStatus) {
        this.orNumber = orNumber;
        this.customerName = customerName;
        this.dateProcessed = dateProcessed;
        this.college = college;
        this.feeName = feeName;
        this.feeDesc = feeDesc;
        this.requestId = requestId; // Set REQUEST_ID
        this.fileStatus = fileStatus; // Set fileStatus
    }

    // Getters
    public String getOrNumber() { return orNumber; }
    public String getCustomerName() { return customerName; }
    public Timestamp getDateProcessed() { return dateProcessed; }
    public String getCollege() { return college; }
    public String getFeeName() { return feeName; }
    public String getFeeDesc() { return feeDesc; }
    public String getRequestId() { return requestId; }
    public String getFileStatus() { return fileStatus; } // Getter for fileStatus
}



