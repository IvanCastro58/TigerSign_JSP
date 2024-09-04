const claimerButtons = document.querySelectorAll('.action-button'); 
const claimerPopup = document.getElementById('claimer-type-modal');
const closeButton = document.getElementById('popup-close');

claimerButtons.forEach(button => {
    button.addEventListener('click', (event) => {
        const row = event.target.closest('tr');
        const id = row.querySelector('td:first-child').textContent;
        const transactionId = row.querySelector('td:nth-child(2)').textContent;
        const name = row.querySelector('td:nth-child(3)').textContent;
        const email = row.querySelector('td:nth-child(4)').textContent;
        const files = row.querySelector('td:nth-child(8)').textContent;

        const primaryLink = claimerPopup.querySelector('.claimer-button .primary');
        const representativeLink = claimerPopup.querySelector('.claimer-button .representative');

        primaryLink.href = `../pages/receiving_form_primary.jsp?id=${id}&transactionId=${encodeURIComponent(transactionId)}&name=${encodeURIComponent(name)}&email=${encodeURIComponent(email)}&files=${encodeURIComponent(files)}`;
        representativeLink.href = `../pages/receiving_form_representative.jsp?id=${id}&transactionId=${encodeURIComponent(transactionId)}&name=${encodeURIComponent(name)}&email=${encodeURIComponent(email)}&files=${encodeURIComponent(files)}`;

        claimerPopup.style.display = 'flex';
        setTimeout(() => {
            claimerPopup.querySelector('.popup').classList.add('show');
        }, 10);
    });
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