document.addEventListener("DOMContentLoaded", function() {
    setTimeout(function() {
        document.querySelectorAll(".skeleton-row").forEach(function(el) {
            el.style.display = 'none';
        });
    
        document.querySelectorAll(".actual-data").forEach(function(el) {
            el.style.display = 'table-row'; 
        });
    }, 1000); 
});