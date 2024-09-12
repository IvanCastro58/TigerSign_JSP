document.addEventListener('DOMContentLoaded', () => {

    const statusDropdowns = document.querySelectorAll('.status-dropdown');

    function updateStatusStyle(dropdown) {
        const status = dropdown.value;
        
        dropdown.classList.remove('status-paid', 'status-processing', 'status-available');

        switch (status) {
            case 'paid':
                dropdown.classList.add('status-paid');
                break;
            case 'processing':
                dropdown.classList.add('status-processing');
                break;
            case 'available':
                dropdown.classList.add('status-available');
                break;
        }
    }

    statusDropdowns.forEach(dropdown => {
        updateStatusStyle(dropdown);
        dropdown.addEventListener('change', () => {
            updateStatusStyle(dropdown);
        });
    });

    const clickableRows = document.querySelectorAll(".clickable-row");
   clickableRows.forEach(row => {
        row.addEventListener("click", function() {
            const transactionId = this.querySelector('td').innerText.trim();
            window.location.href = contextPath + "/SuperAdmin/claimed_request_details.jsp?transactionId=" + transactionId;
        });
    });
    
    const adminClickableRows = document.querySelectorAll(".admin-clickable-row");
    adminClickableRows.forEach(row => {
        row.addEventListener("click", function() {
           const transactionId = this.querySelector('td').innerText.trim();
            window.location.href = contextPath + "/Admin/claimed_request_details.jsp?transactionId=" + transactionId;
        });
    });
});
