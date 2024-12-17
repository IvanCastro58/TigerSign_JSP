package com.tigersign.dao;


public class AuditDetail {
    private String key;
    private String value;

    public AuditDetail(String key, String value) {
        this.key = key;
        this.value = value;
    }

    public String getKey() {
        return key;
    }

    public String getValue() {
        return value;
    }
}

