(function () {
    var toggle = document.getElementById('menuToggle');
    var menu = document.getElementById('menuNav');

    if (!toggle || !menu) {
        return;
    }

    function cerrarMenu() {
        menu.classList.remove('activo');
        toggle.classList.remove('activo');
        toggle.setAttribute('aria-expanded', 'false');
    }

    function toggleMenu() {
        var abierto = menu.classList.toggle('activo');
        toggle.classList.toggle('activo', abierto);
        toggle.setAttribute('aria-expanded', String(abierto));
    }

    toggle.addEventListener('click', function (e) {
        e.stopPropagation();
        toggleMenu();
    });

    menu.addEventListener('click', function (e) {
        if (e.target.tagName === 'A') {
            cerrarMenu();
        }
    });

    document.addEventListener('click', function (e) {
        if (!menu.contains(e.target) && !toggle.contains(e.target)) {
            cerrarMenu();
        }
    });

    window.addEventListener('resize', function () {
        if (window.innerWidth >= 768) {
            cerrarMenu();
        }
    });
})();
