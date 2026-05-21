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