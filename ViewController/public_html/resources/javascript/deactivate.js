const deactivateButton = document.querySelector('.deactivate-btn');
const deactivationPopup = document.getElementById('confirm-deactivation-popup');
const deactivationPopupElement = deactivationPopup.querySelector('.popup');
const deactivationCloseButton = deactivationPopup.querySelector('.popup-close');
const deactivationReasonInput = document.getElementById('deactivation-reason');
const deactivationSubmitBtn = deactivationPopup.querySelector('.submit-btn');

deactivateButton.addEventListener('click', () => {
    deactivationPopup.style.display = 'flex';
    setTimeout(() => {
        deactivationPopupElement.classList.add('show');
    }, 10);
});

deactivationCloseButton.addEventListener('click', () => {
    deactivationPopupElement.classList.remove('show');
    setTimeout(() => {
        deactivationPopup.style.display = 'none';
    }, 600);
});

window.addEventListener('click', (event) => {
    if (event.target === deactivationPopup) {
        deactivationPopupElement.classList.remove('show');
        setTimeout(() => {
            deactivationPopup.style.display = 'none';
        }, 600);
    }
});

deactivationReasonInput.addEventListener('input', () => {
    if (deactivationReasonInput.value.trim() !== '') {
        deactivationSubmitBtn.disabled = false;
    } else {
        deactivationSubmitBtn.disabled = true;
    }
});