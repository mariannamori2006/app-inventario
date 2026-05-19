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
                <div class="producto-icon"><i class="fa-solid fa-microchip"></i></div>
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

// ================== ANALÍTICA DE VENTAS (DATOS REALES + CHART) ==================
let chartVentas = null;

window.cargarReportes = async function() {
    try {
        const res = await fetch('/api/reportes');
        const result = await res.json();
        
        if(result.status === 'success') {
            const data = result.data;
            // 1. KPIs
            document.getElementById('kpi-ingresos').innerText = `S/ ${parseFloat(data.ingresos_mes).toFixed(2)}`;
            document.getElementById('kpi-ventas').innerText = data.ventas_hoy;

            // 2. Tabla de Transacciones
            const tbody = document.getElementById('tabla-transacciones');
            tbody.innerHTML = data.transacciones.length === 0 
                ? '<tr><td colspan="5" style="text-align:center;">No hay ventas hoy</td></tr>'
                : data.transacciones.map(t => `
                    <tr>
                        <td style="color: var(--text-muted);">${t.fecha}</td>
                        <td><div class="mini-icon"><i class="fa-solid fa-box"></i></div> ${t.codigo}</td>
                        <td>${t.cantidad} und.</td>
                        <td style="font-weight: 600;">S/ ${parseFloat(t.total).toFixed(2)}</td>
                        <td><span class="badge-status success">COMPLETADO</span></td>
                    </tr>
                `).join('');

            // 3. Gráfico (Opcional si habilitaste datos de 7 días)
            if(data.grafico_dias) dibujarGrafico(data.grafico_dias);
        }
    } catch (error) { console.error("Error reportes:", error); }
}

function dibujarGrafico(datosDias) {
    const ctx = document.getElementById('ventasChart').getContext('2d');
    const labels = datosDias.length > 0 ? datosDias.map(d => d.fecha) : ['Hoy'];
    const valores = datosDias.length > 0 ? datosDias.map(d => d.total) : [0];

    const gradient = ctx.createLinearGradient(0, 0, 0, 400);
    gradient.addColorStop(0, 'rgba(139, 92, 246, 0.4)');
    gradient.addColorStop(1, 'rgba(139, 92, 246, 0.0)');

    if(chartVentas) chartVentas.destroy();

    chartVentas = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Ingresos S/',
                data: valores,
                borderColor: '#8b5cf6',
                backgroundColor: gradient,
                borderWidth: 3,
                pointBackgroundColor: '#10b981',
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { display: false }, ticks: { color: '#94a3b8' } },
                y: { grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: '#94a3b8' } }
            }
        }
    });
}

// ================== INTELIGENCIA ARTIFICIAL ==================
let panelChart = null;

window.ejecutarIA = async function() {
    const btn = document.querySelector('.btn-ia-glow');
    btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Analizando...';
    btn.disabled = true;

    try {
        const res = await fetch('/api/ia/prediccion');
        const result = await res.json();
        const contenedor = document.getElementById('contenedorTarjetasIA');
        contenedor.innerHTML = '';

        if (result.status !== 'success') {
            mostrarMensaje('msgIA', result.status, result.message);
            return;
        }

        window.datosIA = result.data;

        result.data.forEach((p, index) => {
            let colorScore, bgScore;
            if (p.score_salud >= 70)      { colorScore = '#10b981'; bgScore = 'rgba(16,185,129,0.1)'; }
            else if (p.score_salud >= 40) { colorScore = '#f59e0b'; bgScore = 'rgba(245,158,11,0.1)'; }
            else                          { colorScore = '#ef4444'; bgScore = 'rgba(239,68,68,0.1)'; }

            const claseAlerta = {
                'CRITICO':     'alerta-critico',
                'REABASTECER': 'alerta-reabastecer',
                'DORMIDO':     'alerta-dormido',
                'OK':          'alerta-ok',
            }[p.alerta] || '';

            const tieneGrafico = p.proyeccion && p.proyeccion.length > 0;
            const canvasId = `chart-mini-${index}`;

            contenedor.innerHTML += `
                <div class="tarjeta-ia ${claseAlerta}" 
                     onclick="abrirPanelIA(${index})"
                     style="cursor:pointer; position:relative; padding:16px;">

                    <div style="position:absolute; top:12px; right:12px; text-align:center;
                                background:${bgScore}; border:1px solid ${colorScore};
                                border-radius:50%; width:44px; height:44px;
                                display:flex; flex-direction:column;
                                align-items:center; justify-content:center;">
                        <span style="font-size:13px; font-weight:700; color:${colorScore}; line-height:1">${p.score_salud}</span>
                        <span style="font-size:8px; color:${colorScore}; opacity:.8">salud</span>
                    </div>

                    <h3 style="padding-right:55px; font-size:14px; margin-bottom:8px;">${p.producto}</h3>

                    <div style="display:flex; gap:12px; font-size:12px; opacity:.7; margin-bottom:10px;">
                        <span><i class="fa-solid fa-boxes-stacked"></i> ${p.stock} und.</span>
                        <span><i class="fa-solid fa-bolt"></i> ${p.ritmo_venta}/día</span>
                    </div>

                    ${tieneGrafico ? `
                        <div style="border-top:1px solid rgba(255,255,255,0.07); padding-top:10px;">
                            <canvas id="${canvasId}" height="60"></canvas>
                        </div>` : ''}
                </div>
            `;
        });

        result.data.forEach((p, index) => {
            if (!p.proyeccion || p.proyeccion.length === 0) return;
            const canvas = document.getElementById(`chart-mini-${index}`);
            if (!canvas) return;

            const colorLinea = p.alerta === 'CRITICO' ? '#ef4444' : '#f59e0b';
            new Chart(canvas.getContext('2d'), {
                type: 'line',
                data: {
                    labels: p.proyeccion.map(d => d.fecha),
                    datasets: [{
                        data: p.proyeccion.map(d => d.stock),
                        borderColor: colorLinea,
                        backgroundColor: colorLinea + '18',
                        borderWidth: 2,
                        pointRadius: 0,
                        fill: true,
                        tension: 0.3,
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false }, tooltip: { enabled: false } },
                    scales: {
                        x: { display: false },
                        y: { display: false, min: 0 }
                    }
                }
            });
        });

    } catch (error) {
        mostrarMensaje('msgIA', 'error', 'Error al conectar con la IA');
    } finally {
        btn.innerHTML = '<i class="fa-solid fa-wand-magic-sparkles"></i> Ejecutar IA';
        btn.disabled = false;
    }
}

window.abrirPanelIA = function(index) {
    const p = window.datosIA[index];
    if (!p) return;

    let colorScore;
    if (p.score_salud >= 70)      colorScore = '#10b981';
    else if (p.score_salud >= 40) colorScore = '#f59e0b';
    else                          colorScore = '#ef4444';

    document.getElementById('panel_titulo').textContent = p.producto;
    document.getElementById('panel_score').textContent = p.score_salud;
    document.getElementById('panel_score').style.color = colorScore;
    document.getElementById('panel_stock').textContent = `${p.stock} und.`;
    document.getElementById('panel_ritmo').textContent = `${p.ritmo_venta}/día`;
    document.getElementById('panel_dias').textContent = p.dias_restantes < 999 ? `${p.dias_restantes} días` : 'Sin datos';
    document.getElementById('panel_margen').textContent = `S/ ${p.margen_sol} (${p.margen_pct}%)`;
    document.getElementById('panel_quiebre').textContent = p.fecha_quiebre;

    const iconTendencia = { 'subiendo': '📈', 'bajando': '📉', 'estable': '➡️' }[p.tendencia] || '❓';
    const signo = p.cambio_pct > 0 ? '+' : '';
    document.getElementById('panel_tendencia').textContent =
        `${iconTendencia} ${p.tendencia} (${signo}${p.cambio_pct}% vs semana anterior)`;

    const alertaConfig = {
        'CRITICO':     { texto: '🔴 CRÍTICO — Reabastecer urgente', bg: 'rgba(239,68,68,0.15)', color: '#ef4444' },
        'REABASTECER': { texto: '🟡 REABASTECER — Stock bajo', bg: 'rgba(245,158,11,0.15)', color: '#f59e0b' },
        'DORMIDO':     { texto: '🌙 DORMIDO — Sin ventas recientes', bg: 'rgba(245,158,11,0.15)', color: '#f59e0b' },
        'OK':          { texto: '🟢 OK — Stock saludable', bg: 'rgba(16,185,129,0.15)', color: '#10b981' },
    }[p.alerta] || { texto: p.alerta, bg: 'transparent', color: '#fff' };

    const alertaEl = document.getElementById('panel_alerta');
    alertaEl.textContent = alertaConfig.texto;
    alertaEl.style.background = alertaConfig.bg;
    alertaEl.style.color = alertaConfig.color;

    const dormidoBox = document.getElementById('panel_dormido_box');
    if (p.dormido && p.dias_sin_venta) {
        dormidoBox.style.display = 'block';
        document.getElementById('panel_dormido').textContent = `Sin ventas hace ${p.dias_sin_venta} días`;
    } else {
        dormidoBox.style.display = 'none';
    }

    const graficoBox = document.getElementById('panel_grafico_box');
    if (p.proyeccion && p.proyeccion.length > 0) {
        graficoBox.style.display = 'block';
        if (panelChart) panelChart.destroy();
        const colorLinea = p.alerta === 'CRITICO' ? '#ef4444' : '#f59e0b';
        panelChart = new Chart(document.getElementById('panel_chart').getContext('2d'), {
            type: 'line',
            data: {
                labels: p.proyeccion.map(d => d.fecha),
                datasets: [
                    {
                        label: 'Stock proyectado',
                        data: p.proyeccion.map(d => d.stock),
                        borderColor: colorLinea,
                        backgroundColor: colorLinea + '18',
                        borderWidth: 2,
                        pointRadius: 0,
                        fill: true,
                        tension: 0.3,
                    },
                    {
                        label: 'Stock mínimo',
                        data: Array(31).fill(5),
                        borderColor: 'rgba(255,255,255,0.2)',
                        borderWidth: 1,
                        borderDash: [4, 4],
                        pointRadius: 0,
                        fill: false,
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: { callbacks: { label: ctx => `Stock: ${ctx.parsed.y} und.` } }
                },
                scales: {
                    x: { grid: { display: false }, ticks: { color: '#94a3b8', font: { size: 10 }, maxTicksLimit: 6 } },
                    y: { min: 0, grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: '#94a3b8', font: { size: 10 } } }
                }
            }
        });
    } else {
        graficoBox.style.display = 'none';
    }

    // Abrir centrado
    document.getElementById('panelDetalleIA').style.opacity = '1';
    document.getElementById('panelDetalleIA').style.transform = 'translate(-50%, -50%) scale(1)';
    document.getElementById('panelDetalleIA').style.pointerEvents = 'auto';
    document.getElementById('overlayIA').style.display = 'block';
}

window.cerrarPanelIA = function() {
    document.getElementById('panelDetalleIA').style.opacity = '0';
    document.getElementById('panelDetalleIA').style.transform = 'translate(-50%, -50%) scale(0.9)';
    document.getElementById('panelDetalleIA').style.pointerEvents = 'none';
    document.getElementById('overlayIA').style.display = 'none';
}

// ================== MÓDULO: GESTIÓN DE PERSONAL ==================

// 1. Enviar el formulario de registro
document.getElementById('formRegistroUsuario').addEventListener('submit', async (e) => {
    e.preventDefault();
    const data = Object.fromEntries(new FormData(e.target).entries());
    
    try {
        const res = await fetch('/auth/api/usuarios/registrar', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        const result = await res.json();
        
        mostrarMensaje('msgRegistro', result.status, result.message);
        
        if(result.status === 'success') {
            e.target.reset();
            cargarPersonal(); // Refrescamos la lista
        }
    } catch (error) { 
        console.error("Error al registrar:", error); 
        mostrarMensaje('msgRegistro', 'error', 'Error de conexión');
    }
});

async function cargarPersonal() {
    const tbody = document.getElementById("tabla-usuarios");
    try {
        const res = await fetch('/auth/api/usuarios/listar');
        const result = await res.json();
        
        if(result.status === 'success') {
            tbody.innerHTML = result.data.map(u => {
                // No permitimos que el Jefe se desactive a sí mismo por error
                const esPropioJefe = u.username === "{{ session['username'] }}" || u.rol === 'Jefe';
                
                return `
                <tr>
                    <td>${u.nombre}</td>
                    <td><small>@${u.username}</small></td>
                    <td>
                        <select onchange="cambiarRol(${u.id}, this.value)" ${esPropioJefe ? 'disabled' : ''} style="padding:5px; font-size:12px;">
                            <option value="Vendedor" ${u.rol === 'Vendedor' ? 'selected' : ''}>Vendedor</option>
                            <option value="Administrador" ${u.rol === 'Administrador' ? 'selected' : ''}>Admin</option>
                            <option value="Jefe" ${u.rol === 'Jefe' ? 'selected' : ''}>Jefe</option>
                        </select>
                    </td>
                    <td>
                        <span class="badge-status ${u.estado === 'Activo' ? 'success' : 'error'}">
                            ${u.estado}
                        </span>
                    </td>
                    <td>
                        <button onclick="toggleEstado(${u.id}, '${u.estado}')" 
                                class="btn-submit" 
                                style="padding: 5px 10px; margin: 0; background: ${u.estado === 'Activo' ? 'var(--danger)' : 'var(--success)'}; font-size: 11px;"
                                ${esPropioJefe ? 'disabled' : ''}>
                            ${u.estado === 'Activo' ? 'Desactivar' : 'Activar'}
                        </button>
                    </td>
                </tr>
                `;
            }).join('');
        }
    } catch (error) { console.error("Error al cargar personal:", error); }
}

// Funciones para hablar con el servidor
window.cambiarRol = async (id, nuevoRol) => {
    try {
        const res = await fetch(`/auth/api/usuarios/actualizar/${id}`, {
            method: 'PUT',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({rol: nuevoRol})
        });
        const data = await res.json();
        
        // Usamos tu sistema de mensajes para confirmar
        mostrarMensaje('msgRegistro', data.status, data.message);
        
        if(data.status === 'success') {
            console.log(`Rol de usuario ${id} cambiado a ${nuevoRol}`);
        }
    } catch (error) {
        console.error("Error al cambiar rol:", error);
    }
};

window.toggleEstado = async (id, estadoActual) => {
    const nuevoEstado = estadoActual === 'Activo' ? 'Inactivo' : 'Activo';
    try {
        const res = await fetch(`/auth/api/usuarios/actualizar/${id}`, {
            method: 'PUT',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({estado: nuevoEstado})
        });
        const data = await res.json();
        
        if(data.status === 'success') {
            cargarPersonal(); // Recargamos la tabla para ver el cambio de color
        }
        mostrarMensaje('msgRegistro', data.status, data.message);
    } catch (error) {
        console.error("Error al cambiar estado:", error);
    }
};

// ================== MÓDULO: AUDITORÍA (OPERACIONES) ==================
async function cargarOperaciones() {
    const tbody = document.getElementById("tabla-operaciones-body");
    
    // Ponemos un mensaje de carga mientras llegan los datos
    tbody.innerHTML = '<tr><td colspan="4" style="text-align:center;">Sincronizando registros con el servidor...</td></tr>';

    try {
        // Llamamos a la API que creamos en el usuario_controller
        // Recuerda que registramos el blueprint de usuarios bajo '/auth'
        const res = await fetch('/auth/api/operaciones/listar');
        const datos = await res.json();

        if (datos.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" style="text-align:center;">No hay movimientos registrados aún.</td></tr>';
            return;
        }

        // Limpiamos la tabla y generamos las filas
        tbody.innerHTML = datos.map(op => {
            // Formateamos la fecha para que sea legible (Formato Perú)
            const fechaFormateada = new Date(op.fecha).toLocaleString('es-PE', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });

            return `
                <tr>
                    <td style="color: var(--text-muted); font-size: 13px;">${fechaFormateada}</td>
                    <td><strong style="color: var(--accent-purple);">@${op.usuario_nombre || 'Sistema'}</strong></td>
                    <td><span class="badge-status" style="background: rgba(255,255,255,0.05); color: var(--text-muted); padding: 2px 8px; border-radius: 4px;">${op.modulo}</span></td>
                    <td style="color: var(--text-main); font-weight: 500;">${op.accion}</td>
                </tr>
            `;
        }).join('');

    } catch (error) {
        console.error("Error al cargar auditoría:", error);
        tbody.innerHTML = '<tr><td colspan="4" style="text-align:center; color: var(--danger);">Error de conexión al obtener el historial.</td></tr>';
    }
}