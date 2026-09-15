(function () {
    var STORAGE_KEY = 'theme';
    var root = document.documentElement;
    var toggle = document.getElementById('themeToggle');

    function applyTheme(theme) {
        if (theme === 'dark') {
            root.setAttribute('data-theme', 'dark');
            if (toggle) {
                toggle.textContent = '☀️';
                toggle.setAttribute('aria-label', 'Cambiar a modo claro');
            }
        } else {
            root.removeAttribute('data-theme');
            if (toggle) {
                toggle.textContent = '🌙';
                toggle.setAttribute('aria-label', 'Cambiar a modo oscuro');
            }
        }
    }

    var saved = localStorage.getItem(STORAGE_KEY);
    var prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    applyTheme(saved || (prefersDark ? 'dark' : 'light'));

    if (toggle) {
        toggle.addEventListener('click', function () {
            var isDark = root.getAttribute('data-theme') === 'dark';
            var next = isDark ? 'light' : 'dark';
            applyTheme(next);
            localStorage.setItem(STORAGE_KEY, next);
        });
    }
})();
