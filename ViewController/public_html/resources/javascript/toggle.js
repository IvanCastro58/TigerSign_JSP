document.addEventListener('DOMContentLoaded', function() {
    const menuToggle = document.getElementById('menu-toggle');
    
    setTimeout(function() {
        menuToggle.checked = true;
    }, 3000);
});