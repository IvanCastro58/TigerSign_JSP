document.addEventListener("DOMContentLoaded", function() {
    // Function to simulate data retrieval
    function fetchData() {
        return new Promise((resolve) => {
            // Simulating an asynchronous data fetch with a delay
            setTimeout(() => {
                resolve("Data loaded");
            }, 500); // Simulate 1 second delay in data fetching
        });
    }

    // Show skeleton loading rows initially
    document.querySelectorAll(".skeleton-row").forEach(function(el) {
        el.style.display = 'table-row';
    });

    // Start fetching data
    fetchData().then(function() {
        // Hide skeleton loading rows and show actual data once data is fetched
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
