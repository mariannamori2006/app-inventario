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
            divResultados.innerHTML = filtrados.map(p => `
                <div class="item-resultado" onclick="seleccionarProductoPOS(${p.id}, '${p.nombre}', ${p.precio_venta})">
                    <strong>${p.codigo}</strong> | ${p.nombre} 
                    <br><small style="color:var(--text-muted)">Stock: ${p.stock_actual} | S/ ${p.precio_venta}</small>
                </div>
            `).join('');
            divResultados.style.display = 'block';
        } else {
            divResultados.innerHTML = `<div class="item-resultado">No hay coincidencias</div>`;
            divResultados.style.display = 'block';
        }
    });
}

window.seleccionarProductoPOS = function(id, nombre, precio) {
    document.getElementById('pos_id_producto').value = id;
    document.getElementById('pos_buscador').value = nombre;
    document.getElementById('pos_precio').value = precio;
    divResultados.style.display = 'none';
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
            cargarProductosMemoria();
        }
    } catch (error) { console.error("Error:", error); }
});