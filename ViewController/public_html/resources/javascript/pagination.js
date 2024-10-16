
document.addEventListener("DOMContentLoaded", function() {
    const rowsPerPageSelect = document.querySelector('#rows-per-page');
    const paginationContainer = document.querySelector('.pagination-list');
    const table = document.querySelector('#pending_table');
    const tableBody = table.querySelector('tbody');

    let rowsPerPage = parseInt(rowsPerPageSelect.value, 10);
    let currentPage = 1;

    function updateTable() {
        const rows = Array.from(tableBody.rows);
        const totalRows = rows.length;
        const pageCount = Math.ceil(totalRows / rowsPerPage);

        // Show or hide rows based on current page
        rows.forEach((row, index) => {
            const isVisible = index >= (currentPage - 1) * rowsPerPage && index < currentPage * rowsPerPage;
            row.style.display = isVisible ? '' : 'none';
        });

        updatePagination(pageCount);
    }

    function updatePagination(pageCount) {
        paginationContainer.innerHTML = ''; // Clear the current pagination

        // Add the "Prev" button
        if (currentPage > 1) {
            paginationContainer.innerHTML += '<li class="pagination-item"><a href="#" class="pagination-link">Prev</a></li>';
        }

        // Add the first page
        paginationContainer.innerHTML += `<li class="pagination-item"><a href="#" class="pagination-link">1</a></li>`;

        // Add ellipsis if necessary before the current page range
        if (currentPage > 4) {
            paginationContainer.innerHTML += '<li class="pagination-item">...</li>';
        }

        // Show pages around the current page (3 before and 3 after)
        let start = Math.max(currentPage - 2, 2);
        let end = Math.min(currentPage + 2, pageCount - 1);

        for (let i = start; i <= end; i++) {
            paginationContainer.innerHTML += `<li class="pagination-item"><a href="#" class="pagination-link">${i}</a></li>`;
        }

        // Add ellipsis after the current page range
        if (currentPage < pageCount - 3) {
            paginationContainer.innerHTML += '<li class="pagination-item">...</li>';
        }

        // Add the last page if it's not included
        if (pageCount > 1 && end < pageCount) {
            paginationContainer.innerHTML += `<li class="pagination-item"><a href="#" class="pagination-link">${pageCount}</a></li>`;
        }

        // Add the "Next" button
        if (currentPage < pageCount) {
            paginationContainer.innerHTML += '<li class="pagination-item"><a href="#" class="pagination-link">Next</a></li>';
        }

        // Highlight the current page
        const links = paginationContainer.querySelectorAll('.pagination-link');
        links.forEach(link => {
            const pageNum = parseInt(link.textContent, 10);
            if (pageNum === currentPage) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });
    }

    // Handle pagination clicks
    paginationContainer.addEventListener('click', (event) => {
        event.preventDefault();
        if (event.target.classList.contains('pagination-link')) {
            const text = event.target.textContent;
            if (text === 'Prev') {
                if (currentPage > 1) currentPage--;
            } else if (text === 'Next') {
                if (currentPage < Math.ceil(tableBody.rows.length / rowsPerPage)) currentPage++;
            } else {
                currentPage = parseInt(text, 10);
            }
            updateTable();
        }
    });

    // Handle change in rows per page
    rowsPerPageSelect.addEventListener('change', () => {
        rowsPerPage = parseInt(rowsPerPageSelect.value, 10);
        currentPage = 1; // Reset to the first page
        updateTable();
    });

    // Initialize table and pagination
    updateTable();
});


//document.addEventListener("DOMContentLoaded", function() {
//    const rowsPerPageSelect = document.querySelector('#rows-per-page');
//    const paginationContainer = document.querySelector('.pagination-list');
//    const table = document.querySelector('#pending_table');
//    const tableBody = table.querySelector('tbody');
//    const dropIcon = document.querySelector('.drop-icon');
//
//    let rowsPerPage = parseInt(rowsPerPageSelect.value, 10);
//    let currentPage = 1;
//
//    function updateTable() {
//        const rows = Array.from(tableBody.rows);
//        const totalRows = rows.length;
//        const pageCount = Math.ceil(totalRows / rowsPerPage);
//        
//        rows.forEach((row, index) => {
//            const isVisible = index >= (currentPage - 1) * rowsPerPage && index < currentPage * rowsPerPage;
//            row.style.display = isVisible ? '' : 'none';
//        });
//        
//        updatePagination(pageCount);
//    }
//
//    function updatePagination(pageCount) {
//        paginationContainer.innerHTML = '';
//
//        // Add Prev link
//        if (currentPage > 1) {
//            paginationContainer.innerHTML += '<li class="pagination-item"><a href="#" class="pagination-link">Prev</a></li>';
//        }
//
//        // Show first page
//        if (pageCount <= 5) {  // Show all if total pages are less than or equal to 5
//            for (let i = 1; i <= pageCount; i++) {
//                paginationContainer.innerHTML += <li class="pagination-item"><a href="#" class="pagination-link">${i}</a></li>;
//            }
//        } else {
//            // Always show the first page
//            paginationContainer.innerHTML += <li class="pagination-item"><a href="#" class="pagination-link">1</a></li>;
//
//            // Show ellipsis if needed
//            if (currentPage > 3) {
//                paginationContainer.innerHTML += '<li class="pagination-item"><span>...</span></li>';
//            }
//
//            // Show current and adjacent pages
//            const startPage = Math.max(2, currentPage - 1);
//            const endPage = Math.min(pageCount - 1, currentPage + 1);
//
//            for (let i = startPage; i <= endPage; i++) {
//                paginationContainer.innerHTML += <li class="pagination-item"><a href="#" class="pagination-link">${i}</a></li>;
//            }
//
//            // Show ellipsis if needed
//            if (currentPage < pageCount - 2) {
//                paginationContainer.innerHTML += '<li class="pagination-item"><span>...</span></li>';
//            }
//
//            // Always show the last page
//            paginationContainer.innerHTML += <li class="pagination-item"><a href="#" class="pagination-link">${pageCount}</a></li>;
//        }
//
//        // Add Next link
//        if (currentPage < pageCount) {
//            paginationContainer.innerHTML += '<li class="pagination-item"><a href="#" class="pagination-link">Next</a></li>';
//        }
//
//        // Set active class for current page
//        const links = paginationContainer.querySelectorAll('.pagination-link');
//        links.forEach(link => {
//            if (parseInt(link.textContent, 10) === currentPage) {
//                link.classList.add('active');
//            } else {
//                link.classList.remove('active');
//            }
//        });
//    }
//
//    paginationContainer.addEventListener('click', (event) => {
//        event.preventDefault();
//        if (event.target.classList.contains('pagination-link')) {
//            const text = event.target.textContent;
//            if (text === 'Prev') {
//                if (currentPage > 1) currentPage--;
//            } else if (text === 'Next') {
//                if (currentPage < Math.ceil(tableBody.rows.length / rowsPerPage)) currentPage++;
//            } else {
//                currentPage = parseInt(text, 10);
//            }
//            updateTable();
//        }
//    });
//
//    rowsPerPageSelect.addEventListener('change', () => {
//        rowsPerPage = parseInt(rowsPerPageSelect.value, 10);
//        currentPage = 1;
//        updateTable();
//    });
//
//    updateTable();
//});