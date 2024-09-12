package com.tigersign.dao;

public class ClaimedRequest {
    private String transactionId;
    private String name;
    private String college;
    private String proofDate;
    private String documentsRequested;

    // Getters and Setters
    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
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
}
