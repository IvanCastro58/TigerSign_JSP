document.getElementById('other').addEventListener('change', function () {
    const otherText = document.getElementById('other-text');
    otherText.style.display = 'inline';
    otherText.setAttribute('required', true);
    otherText.value = ''; 
});

const radioButtons = document.querySelectorAll('input[name="service"]');
radioButtons.forEach(radio => {
    radio.addEventListener('change', function () {
        const otherText = document.getElementById('other-text');
        if (this.value !== 'other') {
            otherText.style.display = 'none';
            otherText.removeAttribute('required');
            otherText.value = '';  
        }
    });
});

document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.standout-options input[type="radio"]').forEach(function(el) {
        el.addEventListener('change', function() {
            const standoutOtherText = document.getElementById('standout-other-text');
            if (this.value === 'other') {
                standoutOtherText.style.display = 'block';
                standoutOtherText.setAttribute('required', true);
                standoutOtherText.value = '';  
            } else {
                standoutOtherText.style.display = 'none';
                standoutOtherText.removeAttribute('required');
                standoutOtherText.value = '';  
            }
        });
    });
});
