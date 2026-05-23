// ================== MÓDULO: PUNTO DE VENTA (POS) ==================
let inventarioGlobal = [];
let categoriasGlobal = []; // CAMBIO 1: Nueva variable para guardar las categorías

// Cargamos los productos
async function cargarProductosMemoria() {
    try {
        const res = await fetch('/api/productos');
        const result = await res.json();
        if(result.status === 'success') inventarioGlobal = result.data;
    } catch (error) { console.error("Error:", error); }
}

// CAMBIO 2: Nueva función para cargar los nombres de las categorías
async function cargarCategoriasMemoria() {
    try {
        const res = await fetch('/api/categorias');
        const result = await res.json();
        if(result.status === 'success') categoriasGlobal = result.data;
    } catch (error) { console.error("Error:", error); }
}

// Asegúrate de ejecutar ambas funciones cuando inicie tu script
cargarProductosMemoria();
cargarCategoriasMemoria();


const buscadorInput = document.getElementById('pos_buscador');
const divResultados = document.getElementById('pos_resultados');

if(buscadorInput) {
    buscadorInput.addEventListener('input', (e) => {
        // ... (Este bloque del buscador se queda idéntico al que ya tienes) ...
        const texto = e.target.value.toLowerCase();
        if (texto.length < 2) {
            divResultados.style.display = 'none';
            return;
        }
        const filtrados = inventarioGlobal.filter(p => 
            p.nombre.toLowerCase().includes(texto) || p.codigo.toLowerCase().includes(texto)
        );
        if (filtrados.length > 0) {
            divResultados.innerHTML = filtrados.map(p => `
                <div class="item-resultado" onclick="seleccionarProductoPOS(${p.id}, '${p.nombre}', ${p.precio_venta}, '${p.imagen ? p.imagen : ''}', ${p.stock_actual}, '${p.id_categoria}', ${p.stock_minimo || 5})" style="display: flex; align-items: center; gap: 12px; padding: 8px; cursor: pointer;">
                    
                    <div style="width: 40px; height: 40px; flex-shrink: 0; border-radius: 4px; background: #fff; display: flex; align-items: center; justify-content: center; overflow: hidden; border: 1px solid #444;">
                        <img src="/static/img/productos/${p.imagen ? p.imagen : 'default.jpg'}" style="max-width: 100%; max-height: 100%; object-fit: contain;">
                    </div>
                    
                    <div style="flex: 1;">
                        <strong>${p.codigo}</strong> | ${p.nombre} 
                        <br><small style="color:var(--text-muted)">Stock: ${p.stock_actual} | S/ ${p.precio_venta}</small>
                    </div>
                    
                </div>
            `).join('');
            divResultados.style.display = 'block';
        } else {
            divResultados.innerHTML = `<div class="item-resultado">No hay coincidencias</div>`;
            divResultados.style.display = 'block';
        }
    });
}

// CAMBIO 3: Traducimos el ID de la categoría a su nombre real
window.seleccionarProductoPOS = function(id, nombre, precio, imagen, stockActual, idCategoria, stockMinimo) {
    document.getElementById('pos_id_producto').value = id;
    document.getElementById('pos_buscador').value = nombre;
    document.getElementById('pos_precio').value = precio;
    divResultados.style.display = 'none';
    
    const bloqueImagen = document.getElementById('bloque_pos_imagen');
    const imagenPreview = document.getElementById('pos_imagen_preview');
    
    if (imagen && imagen !== "None" && imagen !== "") {
        imagenPreview.src = `/static/img/productos/${imagen}`;
        bloqueImagen.style.display = 'flex'; 
        
        document.getElementById('pos_info_nombre').innerText = nombre;
        
        // --- TRADUCCIÓN DE CATEGORÍA ---
        // Buscamos el ID en nuestra lista de categorías para sacar el nombre
        let nombreCategoriaReal = "Sin Categoría";
        if (categoriasGlobal.length > 0) {
            const categoriaEncontrada = categoriasGlobal.find(c => c.id == idCategoria);
            if (categoriaEncontrada) {
                nombreCategoriaReal = categoriaEncontrada.nombre;
            }
        }
        document.getElementById('pos_info_categoria').innerText = nombreCategoriaReal;
        // -------------------------------

        // Leemos el rol oculto y validamos el riesgo (Igual que antes)
        const userRol = document.getElementById('user_rol_oculto') ? document.getElementById('user_rol_oculto').innerText.trim() : 'Vendedor';
        const contenedorRestringido = document.getElementById('pos_info_restringido');
        
        if (userRol === 'Jefe' || userRol === 'Administrador') {
            contenedorRestringido.style.display = 'flex';
            document.getElementById('pos_info_stock').innerText = stockActual;
            
            const circuloRiesgo = document.getElementById('pos_riesgo_circulo');
            if (parseInt(stockActual) <= parseInt(stockMinimo)) {
                circuloRiesgo.style.backgroundColor = "#ff9800"; 
            } else {
                circuloRiesgo.style.backgroundColor = "#4caf50"; 
            }
        } else {
            contenedorRestringido.style.display = 'none';
        }

    } else {
        bloqueImagen.style.display = 'none';
        imagenPreview.src = '';
    }

    calcularVuelto();
}

window.calcularVuelto = function() {
    const precio = parseFloat(document.getElementById('pos_precio').value) || 0;
    const cantidad = parseFloat(document.getElementById('pos_cantidad').value) || 1;
    const pagado = parseFloat(document.getElementById('pos_pagado').value) || 0;
    const total = precio * cantidad;
    document.getElementById('pos_total').innerText = `S/ ${total.toFixed(2)}`;
    const inputVuelto = document.getElementById('pos_vuelto');
    if (pagado > 0) {
        const vuelto = pagado - total;
        inputVuelto.value = vuelto >= 0 ? `S/ ${vuelto.toFixed(2)}` : "Falta dinero";
        inputVuelto.style.color = vuelto >= 0 ? "var(--success)" : "var(--danger)";
    } else { inputVuelto.value = ""; }
}

document.getElementById('pos_cantidad').addEventListener('input', calcularVuelto);
document.getElementById('pos_pagado').addEventListener('input', calcularVuelto);

document.getElementById('formVenta').addEventListener('submit', async (e) => {
    e.preventDefault();
    const pagado = parseFloat(document.getElementById('pos_pagado').value) || 0;
    const total = parseFloat(document.getElementById('pos_total').innerText.replace('S/ ', ''));
    if (pagado < total) {
        mostrarMensaje('msgVenta', 'error', 'Efectivo insuficiente.');
        return;
    }
    const data = Object.fromEntries(new FormData(e.target).entries());
    try {
        const res = await fetch('/api/ventas', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        const result = await res.json();
        mostrarMensaje('msgVenta', result.status, result.message);
        if(result.status === 'success') {
            e.target.reset();
            document.getElementById('pos_total').innerText = "S/ 0.00";
            
            // LIMPIEZA TOTAL DE LA FICHA TÉCNICA
            document.getElementById('bloque_pos_imagen').style.display = 'none';
            document.getElementById('pos_imagen_preview').src = '';
            document.getElementById('pos_info_nombre').innerText = '-';
            document.getElementById('pos_info_categoria').innerText = '-';
            document.getElementById('pos_info_restringido').style.display = 'none';
            document.getElementById('pos_riesgo_circulo').style.backgroundColor = 'transparent';
            
            cargarProductosMemoria();
        }
    } catch (error) { console.error("Error:", error); }
});