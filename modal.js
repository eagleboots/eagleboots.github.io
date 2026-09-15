(function () {
    var overlay = document.getElementById('modalOverlay');
    var imagen = document.getElementById('modalImagen');
    var titulo = document.getElementById('modalTitulo');
    var cerrarBtn = document.getElementById('modalCerrar');
    var botones = document.querySelectorAll('.ver-mas');

    function abrirModal(src, alt) {
        imagen.src = src;
        imagen.alt = alt;
        titulo.textContent = alt;
        overlay.classList.add('activo');
        document.body.style.overflow = 'hidden';
    }

    function cerrarModal() {
        overlay.classList.remove('activo');
        document.body.style.overflow = '';
        imagen.src = '';
    }

    botones.forEach(function (btn) {
        btn.addEventListener('click', function () {
            abrirModal(btn.getAttribute('data-img'), btn.getAttribute('data-titulo'));
        });
    });

    cerrarBtn.addEventListener('click', cerrarModal);

    overlay.addEventListener('click', function (e) {
        if (e.target === overlay) {
            cerrarModal();
        }
    });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && overlay.classList.contains('activo')) {
            cerrarModal();
        }
    });
})();
