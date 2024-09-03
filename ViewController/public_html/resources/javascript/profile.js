document.addEventListener('DOMContentLoaded', function() {
    const profilePic = document.getElementById('profile-pic-img');
    const profilePicPopup = document.getElementById('profile-pic-popup');

    profilePic.addEventListener('click', function(event) {
        profilePicPopup.style.display = profilePicPopup.style.display === 'block' ? 'none' : 'block';
        event.stopPropagation();
    });

    document.addEventListener('click', function() {
        profilePicPopup.style.display = 'none';
    });

    profilePicPopup.addEventListener('click', function(event) {
        event.stopPropagation();
    });
});