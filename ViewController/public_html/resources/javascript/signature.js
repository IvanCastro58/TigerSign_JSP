document.addEventListener('DOMContentLoaded', function() {
    const openSignatureModalBtn = document.getElementById('open-signature-modal-btn');
    const signatureModal = document.getElementById('signature-modal');
    const closeSignatureModalBtn = document.getElementById('close-signature-modal-btn');
    const saveSignatureBtn = document.getElementById('save-signature-btn');
    const retakeSignatureBtn = document.getElementById('retake-signature-btn');
    const signatureCanvas = document.getElementById('signature-canvas');
    const signatureCtx = signatureCanvas.getContext('2d');
    const signatureField = document.getElementById('signature-field');
    const signatureControlsModal = document.getElementById('signature-controls-modal');
    const signaturePreviewImg = document.getElementById('signature-preview');
    const closeSignatureControlsModalBtn = document.getElementById('close-signature-controls-modal-btn');
    const confirmSignatureBtn = document.getElementById('confirm-signature-btn');
    const retakeSignatureControlsBtn = document.getElementById('retake-sig-btn');
    const viewSignatureModal = document.getElementById('view-signature-modal');
    const viewSignatureImg = document.getElementById('view-signature');
    const closeViewSignatureModalBtn = document.getElementById('close-view-signature-modal-btn');
    
    let drawing = false;
    let newSignatureData = null; // Store the new signature data for confirmation

    function resetSignaturePad() {
        signatureCtx.clearRect(0, 0, signatureCanvas.width, signatureCanvas.height);
        signatureCtx.beginPath();
        drawing = false;
    }

    function handleDrawing(e) {
        if (drawing) {
            const rect = signatureCanvas.getBoundingClientRect();
            const x = e.clientX || e.touches[0].clientX;
            const y = e.clientY || e.touches[0].clientY;
            const offsetX = x - rect.left;
            const offsetY = y - rect.top;

            signatureCtx.lineTo(offsetX, offsetY);
            signatureCtx.stroke();
        }
    }

    signatureCanvas.addEventListener('mousedown', (e) => {
        drawing = true;
        signatureCtx.moveTo(e.offsetX, e.offsetY);
    });

    signatureCanvas.addEventListener('mousemove', handleDrawing);
    signatureCanvas.addEventListener('mouseup', () => (drawing = false));
    signatureCanvas.addEventListener('mouseleave', () => (drawing = false));
    
    signatureCanvas.addEventListener('touchstart', (e) => {
        e.preventDefault();
        drawing = true;
        const rect = signatureCanvas.getBoundingClientRect();
        const touch = e.touches[0];
        const offsetX = touch.clientX - rect.left;
        const offsetY = touch.clientY - rect.top;
        signatureCtx.moveTo(offsetX, offsetY);
    });

    signatureCanvas.addEventListener('touchmove', handleDrawing);
    signatureCanvas.addEventListener('touchend', () => (drawing = false));
    signatureCanvas.addEventListener('touchcancel', () => (drawing = false));

    openSignatureModalBtn.addEventListener('click', () => {
        signatureModal.style.display = 'block';
        resetSignaturePad();
        newSignatureData = null; // Clear new signature data
    });

    closeSignatureModalBtn.addEventListener('click', () => {
        signatureModal.style.display = 'none';
    });

    saveSignatureBtn.addEventListener('click', () => {
        const signatureData = signatureCanvas.toDataURL('image/png');
        newSignatureData = signatureData;
        signaturePreviewImg.src = signatureData;
        signatureControlsModal.style.display = 'block';
        signatureModal.style.display = 'none';
    });

    retakeSignatureBtn.addEventListener('click', () => {
        resetSignaturePad();
    });

    closeSignatureControlsModalBtn.addEventListener('click', () => {
        signatureControlsModal.style.display = 'none';
    });

    confirmSignatureBtn.addEventListener('click', () => {
        signatureField.value = 'Signature Uploaded';
        signatureField.dataset.signature = newSignatureData;
        signatureControlsModal.style.display = 'none';
        
        signatureField.classList.add('success');
        document.getElementById('signature-check-icon').style.display = 'block';
    }); 

    retakeSignatureControlsBtn.addEventListener('click', () => {
        signatureModal.style.display = 'block';
        signatureControlsModal.style.display = 'none';
    });

    signatureField.addEventListener('click', () => {
        if (signatureField.dataset.signature) {
            viewSignatureImg.src = signatureField.dataset.signature;
            viewSignatureModal.style.display = 'block';
        }
    });

    closeViewSignatureModalBtn.addEventListener('click', () => {
        viewSignatureModal.style.display = 'none';
    });
});
