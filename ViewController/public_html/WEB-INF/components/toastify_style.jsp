<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Toastify Style Component -->
<style>
    @import url('https://fonts.googleapis.com/css2?family=Nunito:ital,wght@0,200..1000;1,200..1000&display=swap');
    
    .loading-icon {
        display: none;
        width: 25px;
        height: 25px;
        margin-right: 10px;
        border: 3px solid #F4BB00;
        border-top: 3px solid #f4f4f4;
        border-radius: 50%;
        animation: spin 1s linear infinite;
    }
    
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
    
    .toast-icon-success, .toast-icon-error {
        margin-right: 8px; 
        vertical-align: middle; 
        font-size: 16px; 
    }
    
    .toast-icon-success {
        color: #1C8454; 
    }
    
    .toast-icon-error {
        color: #d9534f; 
    }
    
    .toast-success {
        font-family: "Nunito", sans-serif;
        font-optical-sizing: auto;
        font-weight: 500;
        font-style: normal;
        font-size: 14px;
        border-radius: 5px;
        width: fit-content; 
        padding: 25px 40px 25px 20px;
        color: #808080;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }
    
    .toast-error {
        font-family: "Nunito", sans-serif;
        font-optical-sizing: auto;
        font-weight: 500;
        font-style: normal;
        font-size: 14px;
        border-radius: 5px;
        width: fit-content; 
        padding: 25px 40px 25px 20px;
        color: #808080;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }

    .toast-error::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 100%;
        border-bottom-left-radius: 5px;
        border-bottom-right-radius: 5px;
        height: 5px;
        background: #d9534f;
        animation: loading-error 3s linear infinite;
    }
    
    .toast-success::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 100%;
        border-bottom-left-radius: 5px;
        border-bottom-right-radius: 5px;
        height: 5px;
        background: #1C8454;
        animation: loading-success 3s linear infinite;
    }
    
    @keyframes loading-error {
        0% {
            width: 100%;
            background: #d9534f;
        }
        100% {
            width: 0;
            background: #d9534f;
        }
    }
    
    @keyframes loading-success {
        0% {
            width: 100%;
            background: #1C8454;
        }
        100% {
            width: 0;
            background: #1C8454;
        }
    }
    
    @media (max-width: 820px) {
         .toast-success,
         .toast-error{
             font-size: 12px;
             padding: 20px 15px; 
             width: 300px;
         }
    }
</style>