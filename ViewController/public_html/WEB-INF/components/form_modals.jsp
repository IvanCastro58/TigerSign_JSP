<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!--Modals for Photo, Signature, and Document Scan-->

<!--LETTER MODALS START-->
    <!-- Modal for capturing Letter photo -->
    <div class="modal" id="capture-letter-modal">
        <div class="modal-content">
            <div class="popup-header">
                <strong>AUTHORIZATION LETTER</strong>
                <span class="close-modal-btn" id="close-letter-capture-modal-btn">&times;</span>
            </div>
            <div class="popup-content">
                <video id="letter-camera" autoplay></video>
                <button type="button" class="capture-btn" id="letter-capture-btn"><i class="bi bi-camera"></i></button>
            </div>
        </div>
    </div>
    <!-- Modal for Letter photo controls (Retake/Confirm) -->
    <div class="modal" id="letter-photo-controls-modal">
        <div class="modal-content">
            <div class="popup-header">
                <strong>AUTHORIZATION LETTER</strong>
                <span class="close-modal-btn" id="close-letter-photo-controls-modal-btn">&times;</span>
            </div>
            <div class="popup-content">
                <div class="letter-captured-image-container">
                    <img id="letter-captured-image-preview" class="letter-captured-image-preview" alt="Captured Preview">
                </div>
                <div class="signature-buttons">
                    <button type="button" class="confirm-btn" id="letter-confirm-btn" title="Save Letter">
                        <i class="fa-solid fa-check"></i>
                        <span class="button-text">Confirm Authorization Letter</span>
                    </button>
                    <button type="button" class="retake-btn" id="letter-retake-btn" title="Retake Letter">
                        <i class="fa fa-arrow-rotate-left"></i>
                        <span class="button-text">Retake Authorization Letter</span>
                    </button>           
                </div>
            </div>
        </div>
    </div>
    <!-- Modal for viewing the captured Letter -->
    <div class="modal" id="view-letter-image-modal">
        <div class="modal-content">
            <div class="popup-header">
                <strong>VIEW AUTHORIZATION LETTER</strong>
                <span class="close-modal-btn" id="close-view-letter-image-modal-btn">&times;</span>
            </div>
            <div class="popup-content">
                <div class="image-container">
                    <img id="view-letter-image" class="image-preview" src="" alt="Captured Authorization Letter">
                </div>
            </div>
        </div>
    </div>
<!--LETTER MODALS END-->

<!--ID PHOTO MODALS START-->
    <!-- Modal for capturing ID photo -->
    <div class="modal" id="capture-id-modal">
        <div class="modal-content">
            <div class="popup-header">
                <strong>ID PHOTO</strong>
                <span class="close-modal-btn" id="close-id-capture-modal-btn">&times;</span>
            </div>
            <div class="popup-content">
                <video id="id-camera" autoplay></video>
                <button type="button" class="capture-btn" id="id-capture-btn"><i class="bi bi-camera"></i></button>
            </div>
        </div>
    </div>
    <!-- Modal for ID photo controls (Retake/Confirm) -->
    <div class="modal" id="id-photo-controls-modal">
        <div class="modal-content">
            <div class="popup-header">
                <strong>ID PHOTO</strong>
                <span class="close-modal-btn" id="close-id-photo-controls-modal-btn">&times;</span>
            </div>
            <div class="popup-content">
                <div class="id-captured-image-container">
                    <img id="id-captured-image-preview" class="id-captured-image-preview" alt="Captured Preview">
                </div>
                <div class="signature-buttons">
                    <button type="button" class="confirm-btn" id="id-confirm-btn" title="Save ID Photo">
                        <i class="fa-solid fa-check"></i>
                        <span class="button-text">Confirm ID Photo</span>
                    </button>
                    <button type="button" class="retake-btn" id="id-retake-btn" title="Retake ID Photo">
                        <i class="fa fa-arrow-rotate-left"></i>
                        <span class="button-text">Retake ID Photo</span>
                    </button>           
                </div>
            </div>
        </div>
    </div>
    <!-- Modal for viewing the captured ID -->
    <div class="modal" id="view-id-image-modal">
        <div class="modal-content">
            <div class="popup-header">
                <strong>VIEW CAPTURED ID IMAGE</strong>
                <span class="close-modal-btn" id="close-view-id-image-modal-btn">&times;</span>
            </div>
            <div class="popup-content">
                <div class="image-container">
                    <img id="view-id-image" class="image-preview" src="" alt="Captured ID Image">
                </div>
            </div>
        </div>
    </div>
<!--ID PHOTO MODALS END-->

<!--SELF PHOTO MODALS START-->
    <!-- Modal for capturing photo -->
    <div class="modal" id="capture-modal">
        <div class="modal-content">
            <div class="popup-header">
                <strong>SELF-CAPTURED PHOTO</strong>
                <span class="close-modal-btn" id="close-capture-modal-btn">&times;</span>
            </div>
            <div class="popup-content">
                <video id="camera" autoplay></video>
                <button type="button" class="capture-btn" id="capture-btn"><i class="bi bi-camera"></i></button>
            </div>
        </div>
    </div>
    <!-- Modal for photo controls (Retake/Confirm) -->
    <div class="modal" id="photo-controls-modal">
        <div class="modal-content">
            <div class="popup-header">
                <strong>SELF-CAPTURED PHOTO</strong>
                <span class="close-modal-btn" id="close-photo-controls-modal-btn">&times;</span>
            </div>
            <div class="popup-content">
                <div class="captured-image-container">
                    <img id="captured-image-preview" class="captured-image-preview" alt="Captured Preview">
                </div>
                <div class="signature-buttons">
                    <button type="button" class="confirm-btn" id="confirm-btn" title="Save Signature">
                        <i class="fa-solid fa-check"></i>
                        <span class="button-text">Confirm Photo</span>
                    </button>
                    <button type="button" class="retake-btn" id="retake-btn" title="Retake Signature">
                        <i class="fa fa-arrow-rotate-left"></i>
                        <span class="button-text">Retake Photo</span>
                    </button>           
                </div>
            </div>
        </div>
    </div>
    <!-- Modal for viewing the captured image -->
    <div class="modal" id="view-image-modal">
        <div class="modal-content">
            <div class="popup-header">
                <strong>VIEW CAPTURED IMAGE</strong>
                <span class="close-modal-btn" id="close-view-image-modal-btn">&times;</span>
            </div>
            <div class="popup-content">
                <div class="image-container">
                    <img id="view-image" class="image-preview" src="" alt="Captured Image">
                </div>
            </div>
        </div>
    </div>
<!--SELF PHOTO MODALS END-->

<!--SIGNATURE MODALS START-->
    <!-- Modal for E-Signature -->
    <div class="modal" id="signature-modal">
        <div class="modal-content">
            <div class="popup-header">
                <strong>E-SIGNATURE INSERTION</strong>
                <span class="close-modal-btn" id="close-signature-modal-btn">&times;</span>
            </div>
            <div class="popup-content">
                <div class="popup-message">
                    <strong>Insert your E-Signature</strong>
                    <div class="info-text">
                        <i class="bi bi-info-circle"></i>
                        <p>Please sign in the area below. Click "Save Signature" to save or "Retake Signature" to draw again.</p>
                    </div>
                </div>
                <canvas id="signature-canvas" width="500" height="200"></canvas>
                <div class="signature-buttons">
                    <button type="button" class="sign-btn" id="save-signature-btn" title="Save Signature">
                        <i class="fa fa-save"></i>
                        <span class="button-text">Save Signature</span>
                    </button>
                    <button type="button" class="retake-btn" id="retake-signature-btn" title="Retake Signature">
                        <i class="fa fa-arrow-rotate-left"></i>
                        <span class="button-text">Reset Signature</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal for E-Signature Controls (Retake/Confirm) -->
    <div class="modal" id="signature-controls-modal">
        <div class="modal-content">
            <div class="popup-header">
                <strong>E-SIGNATURE</strong>
                <span class="close-modal-btn" id="close-signature-controls-modal-btn">&times;</span>
            </div>
            <div class="popup-content">
                <div class="signature-preview-container">
                    <img id="signature-preview" class="signature-preview" alt="Signature Preview">
                </div>
                <div class="signature-buttons">
                    <button type="button" class="confirm-btn" id="confirm-signature-btn" title="Save Signature">
                        <i class="fa-solid fa-check"></i>
                        <span class="button-text">Confirm Signature</span>
                    </button>
                    <button type="button" class="retake-btn" id="retake-sig-btn" title="Retake Signature">
                        <i class="fa fa-arrow-rotate-left"></i>
                        <span class="button-text">Retake Signature</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal for Viewing Signature -->
    <div class="modal" id="view-signature-modal">
        <div class="modal-content">
            <div class="popup-header">
                <strong>VIEW SIGNATURE</strong>
                <span class="close-modal-btn" id="close-view-signature-modal-btn">&times;</span>
            </div>
            <div class="popup-content">
                <div class="image-container">
                    <img id="view-signature" class="image-preview" src="" alt="Signature Image">
                </div>
            </div>
        </div>
    </div>
<!--SIGNATURE MODALS END-->