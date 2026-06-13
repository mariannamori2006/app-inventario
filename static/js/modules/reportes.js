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

            // 3. Gráfico 
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