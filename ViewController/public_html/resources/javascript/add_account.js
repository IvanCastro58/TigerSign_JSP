const addAdmin = document.querySelector('.add-user-btn');
const adminPopup = document.getElementById('add-admin-popup');
const closeAddAdmin = document.getElementById('popup-close');

addAdmin.addEventListener('click', () => {
    adminPopup.style.display = 'flex';
    setTimeout(() => {
        adminPopup.querySelector('.popup').classList.add('show');
    }, 10);
});

closeAddAdmin.addEventListener('click', () => {
    adminPopup.querySelector('.popup').classList.remove('show');
    setTimeout(() => {
        adminPopup.style.display = 'none';
    }, 600);
});

window.addEventListener('click', (event) => {
    if (event.target === adminPopup) {
        adminPopup.querySelector('.popup').classList.remove('show');
        setTimeout(() => {
            adminPopup.style.display = 'none';
        }, 600);
    }
});
