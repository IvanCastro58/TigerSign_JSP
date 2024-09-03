const deactivateButton = document.querySelector('.deactivate-btn');
const deactivationPopup = document.getElementById('confirm-deactivation-popup');
const deactivationPopupElement = deactivationPopup.querySelector('.popup');
const deactivationCloseButton = deactivationPopup.querySelector('.popup-close');
const deactivationConfirmInput = document.getElementById('confirm-input-deactivation');
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

deactivationConfirmInput.addEventListener('input', () => {
    if (deactivationConfirmInput.value.toUpperCase() === 'CONFIRM') {
        deactivationSubmitBtn.disabled = false;
    } else {
        deactivationSubmitBtn.disabled = true;
    }
});
