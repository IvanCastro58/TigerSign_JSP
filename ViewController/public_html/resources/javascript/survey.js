document.getElementById('other').addEventListener('change', function () {
    document.getElementById('other-text').style.display = 'inline';
});

const radioButtons = document.querySelectorAll('input[name="service"]');
radioButtons.forEach(radio => {
    radio.addEventListener('change', function () {
        if (this.value !== 'other') {
            document.getElementById('other-text').style.display = 'none';
        }
    });
});

document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.standout-options input[type="radio"]').forEach(function(el) {
        el.addEventListener('change', function() {
            document.getElementById('standout-other-text').style.display = this.value === 'other' ? 'block' : 'none';
        });
    });
});