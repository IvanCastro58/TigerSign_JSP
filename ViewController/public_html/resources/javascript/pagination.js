document.addEventListener("DOMContentLoaded", function() {
    const rowsPerPageSelect = document.querySelector('#rows-per-page');
    const paginationContainer = document.querySelector('.pagination-list');
    const table = document.querySelector('#pending_table');
    const tableBody = table.querySelector('tbody');
    const dropIcon = document.querySelector('.drop-icon');

    let rowsPerPage = parseInt(rowsPerPageSelect.value, 10);
    let currentPage = 1;

    function updateTable() {
        const rows = Array.from(tableBody.rows);
        const totalRows = rows.length;
        const pageCount = Math.ceil(totalRows / rowsPerPage);
        
        rows.forEach((row, index) => {
            const isVisible = index >= (currentPage - 1) * rowsPerPage && index < currentPage * rowsPerPage;
            row.style.display = isVisible ? '' : 'none';
        });
        
        updatePagination(pageCount);
    }

    function updatePagination(pageCount) {
        paginationContainer.innerHTML = '';
        
        if (currentPage > 1) {
            paginationContainer.innerHTML += '<li class="pagination-item"><a href="#" class="pagination-link">Prev</a></li>';
        }
        
        for (let i = 1; i <= pageCount; i++) {
            paginationContainer.innerHTML += `<li class="pagination-item"><a href="#" class="pagination-link">${i}</a></li>`;
        }
        
        if (currentPage < pageCount) {
            paginationContainer.innerHTML += '<li class="pagination-item"><a href="#" class="pagination-link">Next</a></li>';
        }
        
        const links = paginationContainer.querySelectorAll('.pagination-link');
        links.forEach(link => {
            if (parseInt(link.textContent, 10) === currentPage) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });
    }

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

    rowsPerPageSelect.addEventListener('change', () => {
        rowsPerPage = parseInt(rowsPerPageSelect.value, 10);
        currentPage = 1;
        updateTable();
    });

    updateTable();
});
