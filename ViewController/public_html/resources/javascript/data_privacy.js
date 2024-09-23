const privacyModal = document.getElementById('data-privacy-popup');
const privacyClose = document.getElementById('privacy-popup-close');
const privacyAgree = document.getElementById('privacy-agree-btn');
const documentForm = document.getElementById('document-receiving-form');
let hasAgreed = false; // Flag to track consent

window.addEventListener('load', () => {
    privacyModal.style.display = 'flex';
    setTimeout(() => {
        privacyModal.querySelector('.popup').classList.add('show');
    }, 10);
});

privacyClose.addEventListener('click', () => {
    privacyModal.querySelector('.popup').classList.remove('show');
    setTimeout(() => {
        privacyModal.style.display = 'none';
    }, 600);
});

privacyAgree.addEventListener('click', () => {
    hasAgreed = true; // User has agreed
    privacyModal.querySelector('.popup').classList.remove('show');
    setTimeout(() => {
        privacyModal.style.display = 'none';
    }, 600);
});

window.addEventListener('click', (event) => {
    if (event.target === privacyModal) {
        privacyModal.querySelector('.popup').classList.remove('show');
        setTimeout(() => {
            privacyModal.style.display = 'none';
        }, 600);
    }
});

documentForm.addEventListener('submit', (event) => {
    if (!hasAgreed) {
        event.preventDefault(); // Prevent form submission
        privacyModal.style.display = 'flex';
        setTimeout(() => {
            privacyModal.querySelector('.popup').classList.add('show');
        }, 10);
    }
});