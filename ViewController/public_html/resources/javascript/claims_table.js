document.addEventListener('DOMContentLoaded', () => {
    const clickableRows = document.querySelectorAll(".clickable-row");
    clickableRows.forEach(row => {
        row.addEventListener("click", function() {
            const requestId = this.querySelector('td').innerText.trim(); 
            window.location.href = contextPath + "/SuperAdmin/claimed_request_details.jsp?requestId=" + requestId;
        });
    });
    
    const adminClickableRows = document.querySelectorAll(".admin-clickable-row");
    adminClickableRows.forEach(row => {
        row.addEventListener("click", function() {
          const requestId = this.querySelector('td').innerText.trim(); 
            window.location.href = contextPath + "/Admin/claimed_request_details.jsp?requestId=" + requestId;
        });
    });
});

    