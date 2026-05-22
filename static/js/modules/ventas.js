// ================== MÓDULO: PUNTO DE VENTA (POS) ==================
let inventarioGlobal = [];

async function cargarProductosMemoria() {
    try {
        const res = await fetch('/api/productos');
        const result = await res.json();
        if(result.status === 'success') inventarioGlobal = result.data;
    } catch (error) { console.error("Error:", error); }
}

const buscadorInput = document.getElementById('pos_buscador');
const divResultados = document.getElementById('pos_resultados');

if(buscadorInput) {
    buscadorInput.addEventListener('input', (e) => {
        const texto = e.target.value.toLowerCase();
        if (texto.length < 2) {
            divResultados.style.display = 'none';
            return;
        }
        const filtrados = inventarioGlobal.filter(p => 
            p.nombre.toLowerCase().includes(texto) || p.codigo.toLowerCase().includes(texto)
        );
        if (filtrados.length > 0) {
            // AJUSTE 1: LE PASAMOS LA PROPIEDAD p.imagen COMO CUARTO PARÁMETRO EN EL ONCLICK
            divResultados.innerHTML = filtrados.map(p => `
                <div class="item-resultado" onclick="seleccionarProductoPOS(${p.id}, '${p.nombre}', ${p.precio_venta}, '${p.imagen ? p.imagen : ''}')" style="display: flex; align-items: center; gap: 12px; padding: 8px; cursor: pointer;">
                    
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

// AJUSTE 2: AHORA LA FUNCIÓN RECIBE EL PARÁMETRO 'imagen'
window.seleccionarProductoPOS = function(id, nombre, precio, imagen) {
    document.getElementById('pos_id_producto').value = id;
    document.getElementById('pos_buscador').value = nombre;
    document.getElementById('pos_precio').value = precio;
    divResultados.style.display = 'none';
    
    const bloqueImagen = document.getElementById('bloque_pos_imagen');
    const imagenPreview = document.getElementById('pos_imagen_preview');
    
    if (imagen && imagen !== "None" && imagen !== "") {
        imagenPreview.src = `/static/img/productos/${imagen}`;
        bloqueImagen.style.display = 'block'; // Al activarse, Flexbox lo empuja elegantemente a la derecha
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
            
            // AJUSTE 3: LIMPIAMOS EL VISOR DE IMAGEN AL FINALIZAR LA VENTA CON ÉXITO
            document.getElementById('bloque_pos_imagen').style.display = 'none';
            document.getElementById('pos_imagen_preview').src = '';
            
            cargarProductosMemoria();
        }
    } catch (error) { console.error("Error:", error); }
});