package com.tigersign.dao;

public class ClaimedRequest {
    private String requestId;
    private String orNumber; 
    private String name;
    private String college;
    private String proofDate;
    private String documentsRequested;
    private String documentsDescription;

    // Getters and Setters
    
    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }
    
    public String getOrNumber() {
        return orNumber;
    }

    public void setOrNumber(String orNumber) {
        this.orNumber = orNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCollege() {
        return college;
    }

    public void setCollege(String college) {
        this.college = college;
    }

    public String getProofDate() {
        return proofDate;
    }

    public void setProofDate(String proofDate) {
        this.proofDate = proofDate;
    }

    public String getDocumentsRequested() {
        return documentsRequested;
    }

    public void setDocumentsRequested(String documentsRequested) {
        this.documentsRequested = documentsRequested;
    }
    
    public String getDocumentsDescription() {
        return documentsDescription;
    }

    public void setDocumentsDescription(String documentsDescription) {
        this.documentsDescription = documentsDescription;
    }
}
