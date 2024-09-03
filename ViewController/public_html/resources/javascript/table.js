document.addEventListener('DOMContentLoaded', () => {

    const rows = document.querySelectorAll('.transaction-table tbody tr');
    
    rows.forEach(row => {
        row.addEventListener('click', () => {
            rows.forEach(r => {
                r.querySelectorAll('.expandable-text').forEach(textElement => {
                    textElement.classList.remove('expanded');
                });
            });

            row.querySelectorAll('.expandable-text').forEach(textElement => {
                textElement.classList.add('expanded');
            });
        });
    });

});