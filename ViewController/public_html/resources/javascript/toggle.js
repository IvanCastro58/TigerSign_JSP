document.addEventListener('DOMContentLoaded', function() {
    const menuToggle = document.getElementById('menu-toggle');
    const sidebar = document.querySelector('.sidebar');
    const mainContent = document.querySelector('.main-content');

    // Immediately set the sidebar state based on session storage
    if (sessionStorage.getItem('sidebarOpen') === 'true') {
        menuToggle.checked = true;
    } else {
        menuToggle.checked = false;
    }

    // Remove transitions initially to avoid flickering
    sidebar.style.transition = 'none';
    mainContent.style.transition = 'none';

    // Apply the transition effect after the page has loaded
    window.onload = function() {
        sidebar.style.transition = 'transform 0.2s ease, width 0.2s ease';
        mainContent.style.transition = 'margin-left 0.2s ease';  // Add transition for the main content shift
    };

    // Add event listener to update the state when the user toggles the sidebar
    menuToggle.addEventListener('change', function() {
        sessionStorage.setItem('sidebarOpen', menuToggle.checked);
    });
});
