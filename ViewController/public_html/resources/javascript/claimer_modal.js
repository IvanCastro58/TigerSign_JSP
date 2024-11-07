document.addEventListener("DOMContentLoaded", function() {
    const claimButtons = document.querySelectorAll('.action-button');
    const claimerPopup = document.getElementById('claimer-type-modal');
    const confirmHoldPopup = document.getElementById('confirm-hold-popup'); 
    const closeClaimerPopupButton = document.getElementById('popup-close'); 
    const closeConfirmHoldPopupButton = document.getElementById('confirm-hold-popup-close');

    let previousStatusValue = null; // Store the previous dropdown value
    let currentDropdown = null; // Track the current dropdown being modified

    // Function to show any popup with fade-in effect
    window.showPopup = function(popup) { // Attach to window for global access
        popup.style.display = 'flex';
        requestAnimationFrame(() => {
            popup.querySelector('.popup').classList.add('show');
        });
    }

    // Function to close any popup with fade-out effect
    function closePopup(popup) {
        const popupContent = popup.querySelector('.popup');
        popupContent.classList.remove('show');
        setTimeout(() => {
            popup.style.display = 'none';
        }, 300); // Adjust delay to match CSS transition duration
    }

    // Store the previous status before changing it to "HOLD"
    document.getElementById('confirm-hold-form').addEventListener('submit', function(event) {
    event.preventDefault(); // Prevent the default form submission

    const requestId = document.getElementById('request-id-hold').value; // Get request ID
    const reason = document.getElementById('deactivation-reason').value; // Get reason

    // Make an AJAX call to update the status to "HOLD"
    $.ajax({
       url: contextPath + '/UpdateStatusServlet',
        type: 'POST',
        data: {
            requestId: requestId,
            newStatus: 'HOLD',
            reason: reason // Pass reason to the servlet
        },
        success: function(response) {
            closePopup(confirmHoldPopup); // Close the popup
        },
        error: function(xhr, status, error) {
            alert("Error updating status: " + error); // Handle errors
        }
    });
});

    // Close the confirm-hold-popup and revert the dropdown value
    closeConfirmHoldPopupButton.addEventListener('click', () => {
        closePopup(confirmHoldPopup);
        if (currentDropdown) {
            currentDropdown.value = previousStatusValue; // Revert to previous value
        }
    });

    window.addEventListener('click', (event) => {
        if (event.target === confirmHoldPopup) {
            closePopup(confirmHoldPopup);
            if (currentDropdown) {
                currentDropdown.value = previousStatusValue; // Revert to previous value
            }
        }
    });

    // Show claimerPopup when action-button is clicked
    claimButtons.forEach(button => {
        button.addEventListener('click', () => {
            if (!button.disabled) {
                const row = button.closest('tr');
                const orNumber = row.querySelector('td:nth-child(1)').textContent.trim();
                const customerName = row.querySelector('td:nth-child(2)').textContent.trim();
                const feeName = row.querySelector('td:nth-child(6)').textContent.trim();
                const requestId = row.querySelector('.status-dropdown').dataset.requestId;

                const primaryLink = claimerPopup.querySelector('.claimer-button .primary');
                const representativeLink = claimerPopup.querySelector('.claimer-button .representative');

                primaryLink.href = `../pages/redirecting.jsp?redirect=../pages/receiving_form_primary.jsp&orNumber=${encodeURIComponent(orNumber)}&customerName=${encodeURIComponent(customerName)}&feeName=${encodeURIComponent(feeName)}&fullname=${encodeURIComponent(adminFullName)}&email=${encodeURIComponent(adminEmail)}&requestId=${encodeURIComponent(requestId)}`;

                representativeLink.href = `../pages/redirecting.jsp?redirect=../pages/receiving_form_representative.jsp&orNumber=${encodeURIComponent(orNumber)}&customerName=${encodeURIComponent(customerName)}&feeName=${encodeURIComponent(feeName)}&fullname=${encodeURIComponent(adminFullName)}&email=${encodeURIComponent(adminEmail)}&requestId=${encodeURIComponent(requestId)}`;

                showPopup(claimerPopup);
            }
        });
    });

    // Close the claimer popup
    closeClaimerPopupButton.addEventListener('click', () => closePopup(claimerPopup));
    window.addEventListener('click', (event) => {
        if (event.target === claimerPopup) {
            closePopup(claimerPopup);
        }
    });
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