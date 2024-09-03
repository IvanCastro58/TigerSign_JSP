document.addEventListener('click', function(event) {
    var profileToggle = document.getElementById('profile-toggle');
    var profile = document.getElementById('profile');
    if (!profile.contains(event.target)) {
        profileToggle.checked = false;
    }
});
