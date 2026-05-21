document.addEventListener("DOMContentLoaded", () => {
    cargarCategorias();
    cargarProductosMemoria();
});

// ================== NAVEGACIÓN MODERNA ==================
window.mostrarSeccion = function(id) {
    // 1. Ocultamos todas las secciones
    document.querySelectorAll('main > section').forEach(sec => {
        sec.style.display = 'none';
        sec.classList.remove('seccion-activa');
    });
    
    // 2. Quitamos el color de "activo" de todos los botones del menú
    document.querySelectorAll('.nav-item').forEach(li => {
        li.classList.remove('active');
    });
    
    // 3. Mostramos la sección correcta
    const section = document.getElementById(`sec-${id}`);
    if (section) {
        section.style.display = 'block';
        section.classList.add('seccion-activa');
    }
    
    // 4. Pintamos el botón del menú que fue clickeado
    const nav = document.getElementById(`nav-${id}`);
    if (nav) nav.classList.add('active');

    // --- ACTIVADORES DE CARGA DE DATOS ---
    if(id === 'ventas') cargarProductosMemoria(); 
    if(id === 'reportes') cargarReportes();
    if(id === 'catalogo') renderizarCatalogo();
    if(id === 'personal') cargarPersonal(); 

    // 🚀 NUEVO: Cargar operaciones si entramos a esa sección
    if(id === 'operaciones') cargarOperaciones();
}

// ================== SISTEMA DE MENSAJES ==================
function mostrarMensaje(elementId, tipo, texto) {
    const div = document.getElementById(elementId);
    const icono = tipo === 'success' ? '<i class="fa-solid fa-circle-check"></i>' : '<i class="fa-solid fa-circle-exclamation"></i>';
    div.innerHTML = `<div class="alert ${tipo}">${icono} ${texto}</div>`;
    setTimeout(() => div.innerHTML = '', 4000);
}

// ================== MÓDULO: CATEGORÍAS ==================
document.getElementById('formCategoria').addEventListener('submit', async (e) => {
    e.preventDefault();
    const data = Object.fromEntries(new FormData(e.target).entries());
    try {
        const res = await fetch('/api/categorias', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        const result = await res.json();
        mostrarMensaje('msgCategoria', result.status, result.message);
        if(result.status === 'success') {
            e.target.reset();
            cargarCategorias();
        }
    } catch (error) { console.error("Error:", error); }
});

async function cargarCategorias() {
    try {
        const res = await fetch('/api/categorias');
        const result = await res.json();
        const select = document.getElementById('selectCategoria');
        select.innerHTML = '<option value="">Seleccione una categoría...</option>';
        result.data.forEach(cat => {
            select.innerHTML += `<option value="${cat.id}">${cat.nombre}</option>`;
        });
    } catch (error) { console.error("Error:", error); }
}

// ================== MÓDULO: PRODUCTOS (NUEVO EQUIPO) ==================
document.getElementById('formProducto').addEventListener('submit', async (e) => {
    e.preventDefault();
    const data = Object.fromEntries(new FormData(e.target).entries());
    try {
        const res = await fetch('/api/productos', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        const result = await res.json();
        mostrarMensaje('msgProducto', result.status, result.message);
        if(result.status === 'success') {
            e.target.reset();
            cargarProductosMemoria(); 
        }
    } catch (error) { console.error("Error:", error); }
});