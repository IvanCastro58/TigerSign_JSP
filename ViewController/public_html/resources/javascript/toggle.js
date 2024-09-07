document.addEventListener('DOMContentLoaded', function() {
            const menuToggle = document.getElementById('menu-toggle');
            if (sessionStorage.getItem('sidebarOpen') === 'true') {
                menuToggle.checked = true;
            } else {
                menuToggle.checked = false;
            }
            menuToggle.addEventListener('change', function() {
                sessionStorage.setItem('sidebarOpen', menuToggle.checked);
            });
        });