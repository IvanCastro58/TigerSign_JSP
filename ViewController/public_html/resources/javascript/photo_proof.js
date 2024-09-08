const openCameraBtn = document.getElementById('open-camera-btn');
const captureModal = document.getElementById('capture-modal');
const closeCaptureModalBtn = document.getElementById('close-capture-modal-btn');
const captureBtn = document.getElementById('capture-btn');
const video = document.getElementById('camera');
const photoControlsModal = document.getElementById('photo-controls-modal');
const retakeBtn = document.getElementById('retake-btn');
const confirmBtn = document.getElementById('confirm-btn');
const photoField = document.getElementById('photo-field');
const photoFilename = document.getElementById('photo-filename');
const capturedImageContainer = document.querySelector('.captured-image-container');
const capturedImagePreview = document.getElementById('captured-image-preview');
const viewImageModal = document.getElementById('view-image-modal');
const viewImage = document.getElementById('view-image');
const closeViewImageModalBtn = document.getElementById('close-view-image-modal-btn');
let stream;
let capturedDataUrl = null;
let confirmedDataUrl = null;
let cropper; // Cropper instance

openCameraBtn.addEventListener('click', async () => {
    captureModal.style.display = 'flex';
    photoControlsModal.style.display = 'none';
    capturedImageContainer.style.display = 'none';
    try {
        stream = await navigator.mediaDevices.getUserMedia({ video: true });
        video.srcObject = stream;
    } catch (err) {
        alert('Error accessing the camera: ' + err.message);
    }
});

closeCaptureModalBtn.addEventListener('click', () => {
    if (stream) {
        stream.getTracks().forEach(track => track.stop());
    }
    captureModal.style.display = 'none';
});

captureBtn.addEventListener('click', () => {
    const canvas = document.createElement('canvas');
    const context = canvas.getContext('2d');
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    context.drawImage(video, 0, 0, canvas.width, canvas.height);
    capturedDataUrl = canvas.toDataURL('image/png');
    
    // Show image in the preview area and initialize Cropper
    capturedImagePreview.src = capturedDataUrl;
    photoControlsModal.style.display = 'flex';
    capturedImageContainer.style.display = 'block';
    captureModal.style.display = 'none';
    
    cropper = new Cropper(capturedImagePreview, {
        aspectRatio: NaN, // Allows free aspect ratio (non-square)
        viewMode: 1,
        autoCropArea: 1,
        movable: true,
        scalable: true,
        zoomable: true,
        rotatable: true,
    });
});

retakeBtn.addEventListener('click', () => {
    if (cropper) {
        cropper.destroy();
    }
    photoControlsModal.style.display = 'none';
    captureModal.style.display = 'flex';
    capturedDataUrl = null;
});

confirmBtn.addEventListener('click', () => {
    if (cropper) {
        const canvas = cropper.getCroppedCanvas();
        const croppedDataUrl = canvas.toDataURL('image/png');
        
        const blob = dataURLToBlob(croppedDataUrl);
        const file = new File([blob], "photo.png", { type: 'image/png' });
        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(file);
        photoField.files = dataTransfer.files;
        photoFilename.value = "photo.png";
        confirmedDataUrl = croppedDataUrl; // Store confirmed cropped image URL
        
        cropper.destroy(); // Remove cropper after confirmation
        capturedImageContainer.style.display = 'block';
        photoControlsModal.style.display = 'none';

        photoFilename.classList.add('success');
        document.getElementById('photo-check-icon').style.display = 'block';
    }
});

function viewCapturedImage() {
    if (confirmedDataUrl) {
        viewImage.src = confirmedDataUrl;
        viewImageModal.style.display = 'flex';
    }
}

closeViewImageModalBtn.addEventListener('click', () => {
    viewImageModal.style.display = 'none';
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
