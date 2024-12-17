document.addEventListener('DOMContentLoaded', function() {
    const menuToggle = document.getElementById('menu-toggle');
    
    if (window.innerWidth >= 992) {
        setTimeout(function() {
            menuToggle.checked = true;
        }, 3000);
    }
});
