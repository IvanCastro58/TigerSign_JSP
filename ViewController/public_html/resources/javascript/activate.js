const activateButton = document.querySelector('.activate-btn');
const activationPopup = document.getElementById('confirm-activation-popup');
const activationPopupElement = activationPopup.querySelector('.popup');
const activationCloseButton = activationPopup.querySelector('.popup-close');
const activationConfirmInput = document.getElementById('confirm-input-activation');
const activationSubmitBtn = activationPopup.querySelector('.submit-btn');

activateButton.addEventListener('click', () => {
    activationPopup.style.display = 'flex';
    setTimeout(() => {
        activationPopupElement.classList.add('show');
    }, 10);
});

activationCloseButton.addEventListener('click', () => {
    activationPopupElement.classList.remove('show');
    setTimeout(() => {
        activationPopup.style.display = 'none';
    }, 600);
});

window.addEventListener('click', (event) => {
    if (event.target === activationPopup) {
        activationPopupElement.classList.remove('show');
        setTimeout(() => {
            activationPopup.style.display = 'none';
        }, 600);
    }
});

activationConfirmInput.addEventListener('input', () => {
    if (activationConfirmInput.value.toUpperCase() === 'CONFIRM') {
        activationSubmitBtn.disabled = false;
    } else {
        activationSubmitBtn.disabled = true;
    }
});
