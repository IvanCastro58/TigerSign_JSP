const openIdCameraBtn = document.getElementById('open-id-camera-btn');
const captureIdModal = document.getElementById('capture-id-modal');
const closeIdCaptureModalBtn = document.getElementById('close-id-capture-modal-btn');
const idCaptureBtn = document.getElementById('id-capture-btn');
const idVideo = document.getElementById('id-camera');
const idPhotoControlsModal = document.getElementById('id-photo-controls-modal');
const idRetakeBtn = document.getElementById('id-retake-btn');
const idConfirmBtn = document.getElementById('id-confirm-btn');
const idPhotoField = document.getElementById('id-photo-field');
const idPhotoFilename = document.getElementById('id-photo-filename');
const idCapturedImageContainer = document.querySelector('.id-captured-image-container');
const idCapturedImagePreview = document.getElementById('id-captured-image-preview');
const viewIdImageModal = document.getElementById('view-id-image-modal');
const viewIdImage = document.getElementById('view-id-image');
const closeViewIdImageModalBtn = document.getElementById('close-view-id-image-modal-btn');
let idStream;
let idCapturedDataUrl = null;
let idConfirmedDataUrl = null;
let idCropper; 

openIdCameraBtn.addEventListener('click', async () => {
    captureIdModal.style.display = 'flex';
    idPhotoControlsModal.style.display = 'none';
    idCapturedImageContainer.style.display = 'none';
    try {
        idStream = await navigator.mediaDevices.getUserMedia({ video: true });
        idVideo.srcObject = idStream;
    } catch (err) {
        alert('Error accessing the camera: ' + err.message);
    }
});

closeIdCaptureModalBtn.addEventListener('click', () => {
    if (idStream) {
        idStream.getTracks().forEach(track => track.stop());
    }
    captureIdModal.style.display = 'none';
});

idCaptureBtn.addEventListener('click', () => {
    const canvas = document.createElement('canvas');
    const context = canvas.getContext('2d');
    canvas.width = idVideo.videoWidth;
    canvas.height = idVideo.videoHeight;
    context.drawImage(idVideo, 0, 0, canvas.width, canvas.height);
    idCapturedDataUrl = canvas.toDataURL('image/png');
    
    // Show image in the preview area and initialize Cropper
    idCapturedImagePreview.src = idCapturedDataUrl;
    idPhotoControlsModal.style.display = 'flex';
    idCapturedImageContainer.style.display = 'block';
    captureIdModal.style.display = 'none';
    
    idCropper = new Cropper(idCapturedImagePreview, {
        aspectRatio: NaN, // Allows free aspect ratio (non-square)
        viewMode: 1,
        autoCropArea: 1,
        movable: true,
        scalable: true,
        zoomable: true,
        rotatable: true,
    });
});

idRetakeBtn.addEventListener('click', () => {
    if (idCropper) {
        idCropper.destroy();
    }
    idPhotoControlsModal.style.display = 'none';
    captureIdModal.style.display = 'flex';
    idCapturedDataUrl = null;
});

idConfirmBtn.addEventListener('click', () => {
    if (idCropper) {
        const canvas = idCropper.getCroppedCanvas();
        const croppedDataUrl = canvas.toDataURL('image/png');
        
        const blob = dataURLToBlob(croppedDataUrl);
        const file = new File([blob], "id_photo.png", { type: 'image/png' });
        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(file);
        idPhotoField.files = dataTransfer.files;
        idPhotoFilename.value = "id_photo.png";
        idConfirmedDataUrl = croppedDataUrl; // Store confirmed cropped image URL
        
        idCropper.destroy(); // Remove cropper after confirmation
        idCapturedImageContainer.style.display = 'block';
        idPhotoControlsModal.style.display = 'none';

        idPhotoFilename.classList.add('success');
        document.getElementById('id-photo-check-icon').style.display = 'block';
    }
});

function viewCapturedIdImage() {
    if (idConfirmedDataUrl) {
        viewIdImage.src = idConfirmedDataUrl;
        viewIdImageModal.style.display = 'flex';
    }
}

closeViewIdImageModalBtn.addEventListener('click', () => {
    viewIdImageModal.style.display = 'none';
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
