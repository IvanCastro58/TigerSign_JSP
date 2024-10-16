document.addEventListener('DOMContentLoaded', () => {

    const statusDropdowns = document.querySelectorAll('.status-dropdown');

    function updateStatusStyle(dropdown) {
        const status = dropdown.value;
        
        dropdown.classList.remove('status-PENDING', 'status-PROCESSING', 'status-AVAILABLE');

        switch (status) {
            case 'PENDING':
                dropdown.classList.add('status-PENDING');
                break;
            case 'PROCESSING':
                dropdown.classList.add('status-PROCESSING');
                break;
            case 'AVAILABLE':
                dropdown.classList.add('status-AVAILABLE');
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
            const orNumber = this.querySelector('td').innerText.trim(); // Assuming OR number is in the first column
            const feeName = this.querySelector('td:nth-child(5)').innerText.trim(); // Assuming fee name is in the second column

            window.location.href = contextPath + "/SuperAdmin/claimed_request_details.jsp?orNumber=" + orNumber + "&feeName=" + encodeURIComponent(feeName);
        });
    });
    
    const adminClickableRows = document.querySelectorAll(".admin-clickable-row");
    adminClickableRows.forEach(row => {
        row.addEventListener("click", function() {
          const orNumber = this.querySelector('td').innerText.trim(); // Assuming OR number is in the first column
            const feeName = this.querySelector('td:nth-child(5)').innerText.trim(); // Assuming fee name is in the second column
            window.location.href = contextPath + "/Admin/claimed_request_details.jsp?orNumber=" + orNumber + "&feeName=" + encodeURIComponent(feeName);
        });
    });
});


Ivan Castro
//document.addEventListener('DOMContentLoaded', () => {
//
//    const statusDropdowns = document.querySelectorAll('.status-dropdown');
//
//    function updateStatusStyle(dropdown) {
//        const status = dropdown.value;
//        
//        dropdown.classList.remove('status-PENDING', 'status-PROCESSING', 'status-AVAILABLE');
//
//        switch (status) {
//            case 'pending':
//                dropdown.classList.add('status-PENDING');
//                break;
//            case 'processing':
//                dropdown.classList.add('status-PROCESSING');
//                break;
//            case 'available':
//                dropdown.classList.add('status-AVAILABLE');
//                break;
//        }
//    }
//
//    statusDropdowns.forEach(dropdown => {
//        updateStatusStyle(dropdown);
//        dropdown.addEventListener('change', () => {
//            updateStatusStyle(dropdown);
//        });
//    });
//
//    const clickableRows = document.querySelectorAll(".clickable-row");
//   clickableRows.forEach(row => {
//        row.addEventListener("click", function() {
//            const transactionId = this.querySelector('td').innerText.trim();
//            window.location.href = contextPath + "/SuperAdmin/claimed_request_details.jsp?transactionId=" + transactionId;
//        });
//    });
//    
//    const adminClickableRows = document.querySelectorAll(".admin-clickable-row");
//    adminClickableRows.forEach(row => {
//        row.addEventListener("click", function() {
//           const transactionId = this.querySelector('td').innerText.trim();
//            window.location.href = contextPath + "/Admin/claimed_request_details.jsp?transactionId=" + transactionId;
//        });
//    });
//});
    