const openLetterCameraBtn = document.getElementById('open-letter-camera-btn');
const captureLetterModal = document.getElementById('capture-letter-modal');
const closeLetterCaptureModalBtn = document.getElementById('close-letter-capture-modal-btn');
const letterCaptureBtn = document.getElementById('letter-capture-btn');
const letterVideo = document.getElementById('letter-camera');
const letterPhotoControlsModal = document.getElementById('letter-photo-controls-modal');
const letterRetakeBtn = document.getElementById('letter-retake-btn');
const letterConfirmBtn = document.getElementById('letter-confirm-btn');
const letterPhotoField = document.getElementById('letter-photo-field');
const letterPhotoFilename = document.getElementById('letter-photo-filename');
const letterCapturedImageContainer = document.querySelector('.letter-captured-image-container');
const letterCapturedImagePreview = document.getElementById('letter-captured-image-preview');
const viewLetterImageModal = document.getElementById('view-letter-image-modal');
const viewLetterImage = document.getElementById('view-letter-image');
const closeViewLetterImageModalBtn = document.getElementById('close-view-letter-image-modal-btn');
let letterStream;
let letterCapturedDataUrl = null;
let letterConfirmedDataUrl = null;
let letterCropper; 

openLetterCameraBtn.addEventListener('click', async () => {
    captureLetterModal.style.display = 'flex';
    letterPhotoControlsModal.style.display = 'none';
    letterCapturedImageContainer.style.display = 'none';
    try {
        letterStream = await navigator.mediaDevices.getUserMedia({ video: true });
        letterVideo.srcObject = letterStream;
    } catch (err) {
        alert('Error accessing the camera: ' + err.message);
    }
});

closeLetterCaptureModalBtn.addEventListener('click', () => {
    if (letterStream) {
        letterStream.getTracks().forEach(track => track.stop());
    }
    captureLetterModal.style.display = 'none';
});

letterCaptureBtn.addEventListener('click', () => {
    const canvas = document.createElement('canvas');
    const context = canvas.getContext('2d');
    canvas.width = letterVideo.videoWidth;
    canvas.height = letterVideo.videoHeight;
    context.drawImage(letterVideo, 0, 0, canvas.width, canvas.height);
    letterCapturedDataUrl = canvas.toDataURL('image/png');
    
    // Show image in the preview area and initialize Cropper
    letterCapturedImagePreview.src = letterCapturedDataUrl;
    letterPhotoControlsModal.style.display = 'flex';
    letterCapturedImageContainer.style.display = 'block';
    captureLetterModal.style.display = 'none';
    
    letterCropper = new Cropper(letterCapturedImagePreview, {
        aspectRatio: NaN, // Allows free aspect ratio (non-square)
        viewMode: 1,
        autoCropArea: 1,
        movable: true,
        scalable: true,
        zoomable: true,
        rotatable: true,
    });
});

letterRetakeBtn.addEventListener('click', () => {
    if (letterCropper) {
        letterCropper.destroy();
    }
    letterPhotoControlsModal.style.display = 'none';
    captureLetterModal.style.display = 'flex';
    letterCapturedDataUrl = null;
});

letterConfirmBtn.addEventListener('click', () => {
    if (letterCropper) {
        const canvas = letterCropper.getCroppedCanvas();
        const croppedDataUrl = canvas.toDataURL('image/png');
        
        const blob = dataURLToBlob(croppedDataUrl);
        const file = new File([blob], "authorization_letter.png", { type: 'image/png' });
        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(file);
        letterPhotoField.files = dataTransfer.files;
        letterPhotoFilename.value = "authorization_letter.png";
        letterConfirmedDataUrl = croppedDataUrl; // Store confirmed cropped image URL
        
        letterCropper.destroy(); // Remove cropper after confirmation
        letterCapturedImageContainer.style.display = 'block';
        letterPhotoControlsModal.style.display = 'none';

        letterPhotoFilename.classList.add('success');
        document.getElementById('letter-photo-check-icon').style.display = 'block';
    }
});

function viewCapturedLetterImage() {
    if (letterConfirmedDataUrl) {
        viewLetterImage.src = letterConfirmedDataUrl;
        viewLetterImageModal.style.display = 'flex';
    }
}

closeViewLetterImageModalBtn.addEventListener('click', () => {
    viewLetterImageModal.style.display = 'none';
});

function dataURLToBlob(dataURL) {
    const [header, data] = dataURL.split(',');
    const mime = header.match(/:(.*?);/)[1];
    const binary = atob(data);
    const array = [];
    for (let i = 0; i < binary.length; i++) {
        array.push(binary.charCodeAt(i));
    }
    return new Blob([new Uint8Array(array)], { type: mime });
}
