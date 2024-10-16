const claimButtons = document.querySelectorAll('.action-button');
const claimerPopup = document.getElementById('claimer-type-modal');
const closeButton = document.getElementById('popup-close');

claimButtons.forEach(button => {
        button.addEventListener('click', () => {
            if (!button.disabled) {
                // Get the row of the clicked button
                const row = button.closest('tr');
                const orNumber = row.querySelector('td:nth-child(1)').textContent.trim();
                const customerName = row.querySelector('td:nth-child(2)').textContent.trim();
                const feeName = row.querySelector('td:nth-child(6)').textContent.trim();

                // Get the links for Primary and Representative buttons in the modal
                const primaryLink = claimerPopup.querySelector('.claimer-button .primary');
                const representativeLink = claimerPopup.querySelector('.claimer-button .representative');

                // Set the href attribute with the extracted data
                primaryLink.href = `../pages/redirecting.jsp?redirect=../pages/receiving_form_primary.jsp&orNumber=${encodeURIComponent(orNumber)}&customerName=${encodeURIComponent(customerName)}&feeName=${encodeURIComponent(feeName)}&fullname=${encodeURIComponent(adminFullName)}`;

                representativeLink.href = `../pages/redirecting.jsp?redirect=../pages/receiving_form_representative.jsp&orNumber=${encodeURIComponent(orNumber)}&customerName=${encodeURIComponent(customerName)}&feeName=${encodeURIComponent(feeName)}&fullname=${encodeURIComponent(adminFullName)}`;

                // Display the modal
                claimerPopup.style.display = 'flex';
                setTimeout(() => {
                    claimerPopup.querySelector('.popup').classList.add('show');
                }, 10);
            }
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


//const claimerButtons = document.querySelectorAll('.action-button'); 
//const claimerPopup = document.getElementById('claimer-type-modal');
//const closeButton = document.getElementById('popup-close');
//
//claimerButtons.forEach(button => {
//    button.addEventListener('click', (event) => {
//        const row = event.target.closest('tr');
//        const id = row.querySelector('td:first-child').textContent;
//        const transactionId = row.querySelector('td:nth-child(2)').textContent;
//        const name = row.querySelector('td:nth-child(3)').textContent;
//        const email = row.querySelector('td:nth-child(4)').textContent;
//        const files = row.querySelector('td:nth-child(?').textContent;
//
//        const primaryLink = claimerPopup.querySelector('.claimer-button .primary');
//        const representativeLink = claimerPopup.querySelector('.claimer-button .representative');
//
//        primaryLink.href = ../pages/redirecting.jsp?redirect=../pages/receiving_form_primary.jsp&id=${id}&transactionId=${encodeURIComponent(transactionId)}&name=${encodeURIComponent(name)}&email=${encodeURIComponent(email)}&files=${encodeURIComponent(files)}&fullname=${encodeURIComponent(adminFullName)};
//
//        representativeLink.href = ../pages/redirecting.jsp?redirect=../pages/receiving_form_representative.jsp&id=${id}&transactionId=${encodeURIComponent(transactionId)}&name=${encodeURIComponent(name)}&email=${encodeURIComponent(email)}&files=${encodeURIComponent(files)}&fullname=${encodeURIComponent(adminFullName)};
//
//        claimerPopup.style.display = 'flex';
//        setTimeout(() => {
//            claimerPopup.querySelector('.popup').classList.add('show');
//        }, 10);
//    });
//});
//
//closeButton.addEventListener('click', () => {
//    claimerPopup.querySelector('.popup').classList.remove('show');
//    setTimeout(() => {
//        claimerPopup.style.display = 'none';
//    }, 600);
//});
//
//window.addEventListener('click', (event) => {
//    if (event.target === claimerPopup) {
//        claimerPopup.querySelector('.popup').classList.remove('show');
//        setTimeout(() => {
//            claimerPopup.style.display = 'none';
//        }, 600);
//    }
//});