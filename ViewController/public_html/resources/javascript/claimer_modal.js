const claimerModal = document.querySelector('.action-button');
const claimerPopup = document.getElementById('claimer-type-modal');
const closeButton = document.getElementById('popup-close');

claimerModal.addEventListener('click', () => {
    claimerPopup.style.display = 'flex';
    setTimeout(() => {
        claimerPopup.querySelector('.popup').classList.add('show');
    }, 10);
});

closeButton.addEventListener('click', () => {
    claimerPopup.querySelector('.popup').classList.remove('show');
    setTimeout(() => {
        claimerPopup.style.display = 'none';
    }, 600);
});

window.addEventListener('click', (event) => {
    if (event.target === claimerPopup) {
        claimerPopup.querySelector('.popup').classList.remove('show');
        setTimeout(() => {
            claimerPopup.style.display = 'none';
        }, 600);
    }
});
