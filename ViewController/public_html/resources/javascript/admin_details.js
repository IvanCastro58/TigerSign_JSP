document.addEventListener('DOMContentLoaded', () => {
    const rows = document.querySelectorAll(".account-row");
    rows.forEach(row => {
        row.addEventListener("click", function() {
            const userId = this.getAttribute('data-user-id');
            window.location.href = `${contextPath}/SuperAdmin/admin_details.jsp?userId=${userId}`;
        });
    });
});
