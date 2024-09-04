const claimerSignatureButton = document.querySelector('.claimer-signature .proof-btn');
const claimerPhotoButton = document.querySelector('.claimer-photo .proof-btn');
const claimerLetterButton = document.querySelector('.claimer-id .proof-btn');

const claimerSignatureModal = document.getElementById('claimer-signature-modal');
const claimerPhotoModal = document.getElementById('claimer-photo-modal');
const claimerLetterModal = document.getElementById('claimer-letter-modal');

const closeSignatureButton = claimerSignatureModal.querySelector('.popup-close');
const closePhotoButton = claimerPhotoModal.querySelector('.popup-close');
const closeLetterButton = claimerLetterModal.querySelector('.popup-close');

claimerSignatureButton.addEventListener('click', () => {
    claimerSignatureModal.style.display = 'flex';
    setTimeout(() => {
        claimerSignatureModal.querySelector('.popup').classList.add('show');
    }, 10);
});

claimerPhotoButton.addEventListener('click', () => {
    claimerPhotoModal.style.display = 'flex';
    setTimeout(() => {
        claimerPhotoModal.querySelector('.popup').classList.add('show');
    }, 10);
});

claimerLetterButton.addEventListener('click', () => {
    claimerLetterModal.style.display = 'flex';
    setTimeout(() => {
        claimerLetterModal.querySelector('.popup').classList.add('show');
    }, 10);
});

closeSignatureButton.addEventListener('click', () => {
    claimerSignatureModal.querySelector('.popup').classList.remove('show');
    setTimeout(() => {
        claimerSignatureModal.style.display = 'none';
    }, 600);
});

closePhotoButton.addEventListener('click', () => {
    claimerPhotoModal.querySelector('.popup').classList.remove('show');
    setTimeout(() => {
        claimerPhotoModal.style.display = 'none';
    }, 600);
});

closeLetterButton.addEventListener('click', () => {
    claimerLetterModal.querySelector('.popup').classList.remove('show');
    setTimeout(() => {
        claimerLetterModal.style.display = 'none';
    }, 600);
});

window.addEventListener('click', (event) => {
    if (event.target === claimerSignatureModal) {
        claimerSignatureModal.querySelector('.popup').classList.remove('show');
        setTimeout(() => {
            claimerSignatureModal.style.display = 'none';
        }, 600);
    }
    if (event.target === claimerPhotoModal) {
        claimerPhotoModal.querySelector('.popup').classList.remove('show');
        setTimeout(() => {
            claimerPhotoModal.style.display = 'none';
        }, 600);
    }
    if (event.target === claimerLetterModal) {
        claimerLetterModal.querySelector('.popup').classList.remove('show');
        setTimeout(() => {
            claimerLetterModal.style.display = 'none';
        }, 600);
    }
});

function openPopup(imageSrc) {
    const imagePopup = document.getElementById('imagePopup');
    const popupImage = imagePopup.querySelector('.popup-image');
    
    popupImage.src = imageSrc;
    imagePopup.style.display = 'flex';
}

function closePopup() {
    document.getElementById('imagePopup').style.display = 'none';
}

document.querySelectorAll('.expand-button').forEach(button => {
    button.addEventListener('click', function() {
        const imageSrc = this.nextElementSibling.src;
        openPopup(imageSrc);
    });
});
