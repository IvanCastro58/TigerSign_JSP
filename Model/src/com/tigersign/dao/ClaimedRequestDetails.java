package com.tigersign.dao;


public class ClaimedRequestDetails {
    private String requestId;
    private String orNumber; //ts_request or_number
    private String requesterName; //ts_request customer_name
    private String dateProcessed; //ts_request payment date
    private String requestedDocuments; //ts_request requests
    private String requestedDescription; //ts_request request_description
    private String college; //ts_request college
    private String claimerName; //ts_claimer name
    private String claimerEmail; //ts_claimer email
    private String proofDate; //ts_proofs proof_date
    private String claimerRole; //ts_claimer role
    private String photoPath;//ts_proofs
    private String signaturePath;//ts_proofs
    private String idPhotoBase64;//ts_proofs
    private String letterPhotoBase64;//ts_proofs
    private String releasedBy;//ts_proofs
    private String idPhotoSignatureResult;
    private String letterPhotoSignatureResult;
    private String idSignatureBase64;
    private String letterSignatureBase64;
    private double signatureSimilarityScore;

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

    public String getRequesterName() {
        return requesterName;
    }

    public void setRequesterName(String requesterName) {
        this.requesterName = requesterName;
    }
    
     public String getDateProcessed() {
        return dateProcessed;
    }

    public void setDateProcessed(String dateProcessed) {
        this.dateProcessed = dateProcessed;
    }

    public String getRequestedDocuments() {
        return requestedDocuments;
    }

    public void setRequestedDocuments(String requestedDocuments) {
        this.requestedDocuments = requestedDocuments;
    }
    
    public String getRequestedDescription() {
        return requestedDescription;
    }

    public void setRequestedDescription(String requestedDescription) {
        this.requestedDescription = requestedDescription;
    }
    
    public String getCollege() {
        return college;
    }

    public void setCollege(String college) {
        this.college = college;
    }

    public String getClaimerName() {
        return claimerName;
    }

    public void setClaimerName(String claimerName) {
        this.claimerName = claimerName;
    }

    public String getClaimerEmail() {
        return claimerEmail;
    }

    public void setClaimerEmail(String claimerEmail) {
        this.claimerEmail = claimerEmail;
    }

    public String getProofDate() {
        return proofDate;
    }

    public void setProofDate(String proofDate) {
        this.proofDate = proofDate;
    }

    public String getClaimerRole() {
        return claimerRole;
    }

    public void setClaimerRole(String claimerRole) {
        this.claimerRole = claimerRole;
    }

    public String getPhotoPath() {
        return photoPath;
    }

    public void setPhotoPath(String photoPath) {
        this.photoPath = photoPath;
    }

    public String getSignaturePath() {
        return signaturePath;
    }

    public void setSignaturePath(String signaturePath) {
        this.signaturePath = signaturePath;
    }

    public String getIdPhotoBase64() {
        return idPhotoBase64;
    }

    public void setIdPhotoBase64(String idPhotoBase64) {
        this.idPhotoBase64 = idPhotoBase64;
    }

    public String getLetterPhotoBase64() {
        return letterPhotoBase64;
    }

    public void setLetterPhotoBase64(String letterPhotoBase64) {
        this.letterPhotoBase64 = letterPhotoBase64;
    }
    
    public String getReleasedBy() {
            return releasedBy;
        }

    public void setReleasedBy(String releasedBy) {
        this.releasedBy = releasedBy;
    }
    
    public String getIdPhotoSignatureResult() {
        return idPhotoSignatureResult;
    }

    public void setIdPhotoSignatureResult(String idPhotoSignatureResult) {
        this.idPhotoSignatureResult = idPhotoSignatureResult;
    }

    public String getLetterPhotoSignatureResult() {
        return letterPhotoSignatureResult;
    }

    public void setLetterPhotoSignatureResult(String letterPhotoSignatureResult) {
        this.letterPhotoSignatureResult = letterPhotoSignatureResult;
    }
    
    public String getIdSignatureBase64() {
        return idSignatureBase64;
    }

    public void setIdSignatureBase64(String idSignatureBase64) {
        this.idSignatureBase64 = idSignatureBase64;
    }

    public String getLetterSignatureBase64() {
        return letterSignatureBase64;
    }

    public void setLetterSignatureBase64(String letterSignatureBase64) {
        this.letterSignatureBase64 = letterSignatureBase64;
    }
    
    public double getSignatureSimilarityScore() {
        return signatureSimilarityScore;
    }

    public void setSignatureSimilarityScore(double signatureSimilarityScore) {
        this.signatureSimilarityScore = signatureSimilarityScore;
    }


}