document.addEventListener("DOMContentLoaded", function() {
    function fetchData() {
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve("Data loaded");
            }, 500);
        });
    }

    document.querySelectorAll(".skeleton-row").forEach(function(el) {
        el.style.display = 'table-row';
    });

    fetchData().then(function() {
        document.querySelectorAll(".skeleton-row").forEach(function(el) {
            el.style.display = 'none';
        });

        document.querySelectorAll(".actual-data").forEach(function(el) {
            el.style.display = 'table-row'; 
        });
    }).catch(function(error) {
        console.error("Error loading data:", error);
    });
});
