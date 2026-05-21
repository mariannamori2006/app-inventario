// ================== MÓDULO: CATÁLOGO VISUAL & EDICIÓN POR ROLES (VERSIÓN FINAL) ==================

// 1. Dibujar el catálogo y activar clics solo para los que mandan
function renderizarCatalogo(filtro = "") {
    const contenedor = document.getElementById('contenedor-catalogo');
    contenedor.innerHTML = "";
    
    // Leemos el rol real (limpiando espacios con trim)
    const roleElem = document.querySelector('.user-role');
    const userRol = roleElem ? roleElem.innerText.trim() : "";

    const productos = inventarioGlobal.filter(p => 
        p.nombre.toLowerCase().includes(filtro.toLowerCase()) || 
        (p.codigo && p.codigo.toLowerCase().includes(filtro.toLowerCase()))
    );

    if(productos.length === 0) {
        contenedor.innerHTML = `<p style="color:var(--text-muted); text-align:center; grid-column: 1/-1; padding: 40px;">No se encontraron productos.</p>`;
        return;
    }

    productos.forEach(p => {
        // VALIDACIÓN: ¿Es Jefe o Admin?
        const esAutorizado = (userRol === "Jefe" || userRol === "Administrador");
        const eventoClick = esAutorizado ? `onclick="abrirModalProducto(${p.id})"` : "";
        const estiloCursor = esAutorizado ? "cursor: pointer;" : "cursor: default;";

        contenedor.innerHTML += `
            <div class="producto-card" ${eventoClick} style="${estiloCursor}">
                <div class="producto-badge">${p.codigo || 'S/C'}</div>
                <div class="producto-icon">
                    ${p.imagen 
                        ? `<img src="/static/img/productos/${p.imagen}" 
                                style="width:60px; height:60px; object-fit:cover; border-radius:8px;">`
                        : `<i class="fa-solid fa-microchip"></i>`
                    }
                </div>
                <div class="producto-info">
                    <h3>${p.nombre}</h3>
                    <div class="producto-stats">
                        <div class="stat">
                            <span>Stock</span>
                            <strong class="${p.stock_actual < 5 ? 'text-danger' : ''}">${p.stock_actual} und.</strong>
                        </div>
                        <div class="stat">
                            <span>Venta</span>
                            <strong>S/ ${parseFloat(p.precio_venta).toFixed(2)}</strong>
                        </div>
                    </div>
                </div>
            </div>
        `;
    });
}

// 2. Abrir detalle y aplicar los candados de seguridad
window.abrirModalProducto = function(id) {
    // 1. Buscamos el producto en nuestra memoria local
    const p = inventarioGlobal.find(item => item.id === id);
    if (!p) return; // Seguridad por si no encuentra el ID

    // 2. Detectamos el rol real (quitando espacios en blanco invisibles)
    const roleElem = document.querySelector('.user-role');
    const userRol = roleElem ? roleElem.innerText.trim() : "";
    
    // Llenar datos
    document.getElementById('edit_id').value = p.id;
    document.getElementById('edit_nombre').value = p.nombre;
    document.getElementById('edit_stock').value = p.stock_actual;
    document.getElementById('edit_p_compra').value = p.precio_compra;
    document.getElementById('edit_p_venta').value = p.precio_venta;

    // Sincronizar categorías
    const selectCatModal = document.getElementById('edit_categoria');
    const selectOriginal = document.getElementById('selectCategoria');
    if (selectOriginal) {
        selectCatModal.innerHTML = selectOriginal.innerHTML; 
        selectCatModal.value = p.id_categoria;
    }

    const campos = {
        nombre: document.getElementById('edit_nombre'),
        cat: document.getElementById('edit_categoria'),
        stock: document.getElementById('edit_stock'),
        p_compra: document.getElementById('edit_p_compra'),
        p_venta: document.getElementById('edit_p_venta')
    };
    const btnBox = document.getElementById('btnContenedorEdicion');

    // Resetear bloqueos
    Object.values(campos).forEach(c => { c.disabled = false; c.style.opacity = "1"; });

    // Aplicar restricciones según rol
    if (userRol === "Administrador") {
        campos.nombre.disabled = true;
        campos.p_compra.disabled = true;
        campos.p_venta.disabled = true;
        campos.nombre.style.opacity = "0.5";
        campos.p_compra.style.opacity = "0.5";
        campos.p_venta.style.opacity = "0.5";

        btnBox.innerHTML = '<button type="submit" class="btn-submit">Actualizar Inventario</button>';
    } 
    else if (userRol === "Jefe") {
        btnBox.innerHTML = '<button type="submit" class="btn-submit" style="background:var(--accent-purple)">Guardar Cambios Totales</button>';
    }

        // Mostrar imagen actual del producto
    const preview = document.getElementById('preview_imagen');
    const placeholder = document.getElementById('placeholder_imagen');
    if (p.imagen) {
        preview.src = `/static/img/productos/${p.imagen}`;
        preview.style.display = 'block';
        placeholder.style.display = 'none';
    } else {
        preview.style.display = 'none';
        placeholder.style.display = 'flex';
    }
    document.getElementById('nombre_imagen').textContent = '';
    document.getElementById('input_imagen').value = '';

    document.getElementById('modalProducto').style.display = 'block';
}

// 3. Cerrar modal
window.cerrarModal = function() {
    document.getElementById('modalProducto').style.display = 'none';
}

// 4. Guardar cambios (PUT)
document.getElementById('formEdicionRapida').addEventListener('submit', async (e) => {
    e.preventDefault();
    const id = document.getElementById('edit_id').value;
    
    const datos = {
        nombre: document.getElementById('edit_nombre').value,
        id_categoria: document.getElementById('edit_categoria').value,
        stock: document.getElementById('edit_stock').value,
        precio_compra: document.getElementById('edit_p_compra').value,
        precio_venta: document.getElementById('edit_p_venta').value
    };

    try {
        const res = await fetch(`/api/productos/editar/${id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(datos)
        });
        const result = await res.json();
        
        if(result.status === 'success') {
            // Subir imagen si se seleccionó una
            const inputImagen = document.getElementById('input_imagen');
            if (inputImagen.files.length > 0) {
                const formData = new FormData();
                formData.append('imagen', inputImagen.files[0]);
                const resImg = await fetch(`/api/productos/imagen/${id}`, {
                    method: 'POST',
                    body: formData
                });
                const resultImg = await resImg.json();
                if (resultImg.status === 'success') {
                    await cargarProductosMemoria();
                    renderizarCatalogo();
                }
            }
            cerrarModal();
            await cargarProductosMemoria(); 
            renderizarCatalogo(); 
            alert("✅ " + result.message);
            
        } else {
            alert("❌ " + result.message);
        }
    } catch (error) { 
        alert("Fallo de conexión con el servidor.");
    }
});

// 5. Buscador
window.filtrarCatalogo = function() {
    const texto = document.getElementById('buscarCatalogo').value;
    renderizarCatalogo(texto);
}

// Preview de imagen antes de subir
window.previewImagen = function(input) {
    const file = input.files[0];
    if (!file) return;
    document.getElementById('nombre_imagen').textContent = file.name;
    const reader = new FileReader();
    reader.onload = (e) => {
        const preview = document.getElementById('preview_imagen');
        const placeholder = document.getElementById('placeholder_imagen');
        preview.src = e.target.result;
        preview.style.display = 'block';
        placeholder.style.display = 'none';
    };
    reader.readAsDataURL(file);
}