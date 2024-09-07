<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!--View Signature,Photo, Letter & ID Comparison-->

<div id="claimer-signature-modal" class="popup-overlay">
    <div class="popup">
        <div class="popup-header">
            <strong>CLAIMER'S SIGNATURE</strong>
            <span class="popup-close" id="popup-close">&times;</span>
        </div>
        <div class="popup-content">
            <div class="info-text">
                <i class="bi bi-info-circle"></i>
                <p class="smaller-text">Viewing signatures is strictly for <strong>verification purposes only</strong>. Ensure you access this information responsibly and <strong>avoid sharing or displaying it publicly</strong> to protect the claimer's privacy and prevent unauthorized use.  Always prioritize data security and confidentiality.</p>
            </div>
            <div class="image-container">
                <button class="expand-button" onclick="openPopup()"><i class="fa-solid fa-up-right-and-down-left-from-center"></i></button> <!-- Expand icon -->
                <img src="../resources/images/logo1.png" alt="Sample Image">
            </div>
        </div>
    </div>
</div>
<div id="claimer-photo-modal" class="popup-overlay">
    <div class="popup">
        <div class="popup-header">
            <strong>CLAIMER'S PHOTO</strong>
            <span class="popup-close" id="popup-close">&times;</span>
        </div>
        <div class="popup-content">
            <div class="info-text">
                <i class="bi bi-info-circle"></i>
                <p class="smaller-text">Viewing photos is strictly for <strong>verification purposes only</strong>. Ensure you access this information responsibly and <strong>avoid sharing or displaying it publicly</strong> to protect the claimer's privacy and prevent unauthorized use.  Always prioritize data security and confidentiality.</p>
            </div>
            <div class="image-container">
                <button class="expand-button" onclick="openPopup()"><i class="fa-solid fa-up-right-and-down-left-from-center"></i></button> 
                <img src="../resources/images/google.png" alt="Sample Image">
            </div>
        </div>
    </div>
</div>
<div id="claimer-letter-modal" class="popup-overlay">
    <div class="popup">
        <div class="popup-header">
            <strong>AUTHORIZATION LETTER & ID PHOTO AUTHENTICITY</strong>
            <span class="popup-close" id="popup-close">&times;</span>
        </div>
        <div class="popup-content">
            <div class="info-text">
                <i class="bi bi-info-circle"></i>
                <p class="smaller-text">Please note that while the system provides an initial assessment of signature matching, the result is <strong>not guaranteed to be 100% accurate</strong>. Factors such as blurry images, different angles, or variations in handwriting can affect the accuracy of the match. <strong>Admins are required to manually review and verify that the signatures and documents align correctly to ensure proper authentication.</strong></p>
            </div>
            <div class="image-container-wrapper">
                <div class="image-container-left">
                    <button class="expand-button" onclick="openPopup()"><i class="fa-solid fa-up-right-and-down-left-from-center"></i></button>
                    <img src="../resources/images/background.jpg" alt="Authorization Letter Image">
                </div>
                <div class="image-container-right">
                    <button class="expand-button" onclick="openPopup()"><i class="fa-solid fa-up-right-and-down-left-from-center"></i></button>
                    <img src="../resources/images/tigersign.png" alt="ID Photo Image">
                </div>
            </div>
            <div class="signature-result">
                <i class="bi bi-check-circle"></i> Signature Matched
            </div>
        </div>
    </div>
</div>
<div id="imagePopup" class="image-popup">
    <span class="close-button" onclick="closePopup()">&times;</span>
    <img class="popup-image" alt="Expanded Image">
</div>