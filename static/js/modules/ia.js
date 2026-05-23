// ================== MÓDULO: INTELIGENCIA ARTIFICIAL ==================
let panelChart = null;
let chartComparativa = null;

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

        // ── RESUMEN EJECUTIVO ─────────────────────────────────────────
        const r = result.resumen;
        const resumenEl = document.getElementById('resumenEjecutivo');
        if (resumenEl) {
            const colorPerdida = r.perdida_total > 0 ? '#ef4444' : '#10b981';
            resumenEl.innerHTML = `
                <div style="display:flex; flex-wrap:wrap; gap:12px; align-items:center;">
                    <div style="display:flex; gap:20px; flex-wrap:wrap; flex:1;">
                        ${r.criticos > 0 ? `<span style="color:#ef4444; font-weight:600;">🔴 ${r.criticos} crítico${r.criticos>1?'s':''}</span>` : ''}
                        ${r.reabastecer > 0 ? `<span style="color:#f59e0b; font-weight:600;">🟡 ${r.reabastecer} a reabastecer</span>` : ''}
                        ${r.dormidos > 0 ? `<span style="color:#f59e0b; font-weight:600;">🌙 ${r.dormidos} dormido${r.dormidos>1?'s':''}</span>` : ''}
                        <span style="color:#10b981; font-weight:600;">🟢 ${r.saludables} saludable${r.saludables>1?'s':''}</span>
                    </div>
                    ${r.perdida_total > 0 ? `
                        <div style="background:rgba(239,68,68,0.1); border:1px solid #ef4444; 
                                    border-radius:8px; padding:8px 14px; font-size:13px;">
                            <i class="fa-solid fa-triangle-exclamation" style="color:#ef4444;"></i>
                            <span style="color:#ef4444; font-weight:600;">
                                Pérdida estimada si no reabasteces: S/ ${r.perdida_total.toFixed(2)}
                            </span>
                        </div>` : `
                        <div style="background:rgba(16,185,129,0.1); border:1px solid #10b981;
                                    border-radius:8px; padding:8px 14px; font-size:13px;">
                            <i class="fa-solid fa-circle-check" style="color:#10b981;"></i>
                            <span style="color:#10b981; font-weight:600;">Inventario en buen estado</span>
                        </div>`}
                </div>
            `;
            resumenEl.style.display = 'block';
        }

        // ── GRÁFICO COMPARATIVA DE SCORES ────────────────────────────
        const ctxComp = document.getElementById('chartComparativa');
        if (ctxComp) {
            if (chartComparativa) chartComparativa.destroy();
            const labels  = result.data.map(p => p.producto.split(' ').slice(0,2).join(' '));
            const scores  = result.data.map(p => p.score_salud);
            const colores = scores.map(s => 
                s >= 70 ? 'rgba(16,185,129,0.8)' : 
                s >= 55 ? 'rgba(245,158,11,0.8)' : 
                          'rgba(239,68,68,0.8)'
            );
            chartComparativa = new Chart(ctxComp.getContext('2d'), {
                type: 'bar',
                data: {
                    labels,
                    datasets: [{
                        label: 'Score de Salud',
                        data: scores,
                        backgroundColor: colores,
                        borderRadius: 6,
                        borderSkipped: false,
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: ctx => `Score: ${ctx.parsed.y}/100`
                            }
                        }
                    },
                    scales: {
                        x: {
                            grid: { display: false },
                            ticks: { color: '#94a3b8', font: { size: 10 }, maxRotation: 45 }
                        },
                        y: {
                            min: 0, max: 100,
                            grid: { color: 'rgba(255,255,255,0.05)' },
                            ticks: { color: '#94a3b8', font: { size: 10 } }
                        }
                    }
                }
            });
        }

        // ── TARJETAS ──────────────────────────────────────────────────
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

            // Badge de estacionalidad
            const estacionalBadge = p.mejor_dia 
                ? `<span style="font-size:10px; opacity:.6;">
                        Mejor día: <strong>${p.mejor_dia}</strong>
                   </span>` 
                : '';

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

                    <div style="display:flex; gap:12px; font-size:12px; opacity:.7; margin-bottom:6px;">
                        <span><i class="fa-solid fa-boxes-stacked"></i> ${p.stock} und.</span>
                        <span><i class="fa-solid fa-bolt"></i> ${p.ritmo_venta}/día</span>
                    </div>

                    ${estacionalBadge}

                    ${tieneGrafico ? `
                        <div style="border-top:1px solid rgba(255,255,255,0.07); padding-top:10px; margin-top:8px;">
                            <canvas id="${canvasId}" height="60"></canvas>
                        </div>` : ''}
                </div>
            `;
        });

        // Dibujar gráficos mini
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
                    scales: { x: { display: false }, y: { display: false, min: 0 } }
                }
            });
        });
        document.getElementById('boxComparativa').style.display = 'block';
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
    else if (p.score_salud >= 55) colorScore = '#f59e0b';
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

    // Estacionalidad en el panel
    const panelEstacional = document.getElementById('panel_estacional');
    if (panelEstacional) {
        if (p.mejor_dia) {
            panelEstacional.style.display = 'block';
            panelEstacional.innerHTML = `
                <i class="fa-solid fa-calendar-days" style="color:#8b5cf6;"></i>
                <span style="font-size:13px;">
                    Vende más los <strong>${p.mejor_dia}</strong> · 
                    Menos los <strong>${p.peor_dia}</strong>
                </span>
            `;
        } else {
            panelEstacional.style.display = 'none';
        }
    }

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