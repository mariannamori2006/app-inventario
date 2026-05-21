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