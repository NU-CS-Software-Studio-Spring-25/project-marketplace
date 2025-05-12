document.addEventListener("DOMContentLoaded", function () {
    const toggleButton = document.getElementById("toggle-password");
    const passwordField = document.getElementById("password-input");

    toggleButton.addEventListener("click", function () {
        const isHidden = passwordField.type === "password";
        passwordField.type = isHidden ? "text" : "password";
        toggleButton.textContent = isHidden ? "Hide" : "Show";
    });
})