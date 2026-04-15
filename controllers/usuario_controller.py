from flask import Blueprint, render_template, request, redirect, url_for, session, flash, jsonify
from config import get_db_connection
from models.usuario_model import (
    verificar_credenciales, 
    crear_usuario_db, 
    obtener_todos_los_usuarios, 
    actualizar_rango_usuario, 
    cambiar_estado_usuario,
    registrar_operacion  # <--- Importamos el notario
)

usuario_bp = Blueprint('usuarios', __name__)

@usuario_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user = request.form['username']
        pw = request.form['password']
        
        usuario_valido = verificar_credenciales(user, pw)
        
        if usuario_valido:
            session['user_id'] = usuario_valido['id']
            session['nombre'] = usuario_valido['nombre']
            session['rol'] = usuario_valido['rol']
            session['username'] = usuario_valido['username']
            
            # Opcional: Registrar el inicio de sesión
            registrar_operacion(usuario_valido['id'], "Inició sesión en el sistema", "AUTH")
            
            return redirect(url_for('inventario.index')) 
        else:
            flash("Usuario o contraseña incorrectos", "danger")
            
    return render_template('login.html')

@usuario_bp.route('/logout')
def logout():
    if 'user_id' in session:
        registrar_operacion(session['user_id'], "Cerró sesión", "AUTH")
    session.clear() 
    return redirect(url_for('usuarios.login'))

# =======================================================
# ⚙️ API DE GESTIÓN DE PERSONAL (Solo para el Jefe)
# =======================================================

@usuario_bp.route('/api/usuarios/listar', methods=['GET'])
def listar_usuarios():
    if session.get('rol') != 'Jefe':
        return jsonify({"status": "error", "message": "Acceso denegado"}), 403
    
    usuarios = obtener_todos_los_usuarios()
    return jsonify({"status": "success", "data": usuarios})

@usuario_bp.route('/api/usuarios/registrar', methods=['POST'])
def registrar_personal():
    if session.get('rol') != 'Jefe':
        return jsonify({"status": "error", "message": "No autorizado"}), 403
    
    data = request.json
    exito, mensaje = crear_usuario_db(
        data['nombre'], 
        data['username'], 
        data['password'], 
        data['rol']
    )
    
    if exito:
        registrar_operacion(session['user_id'], f"Creó nuevo usuario: {data['username']} ({data['rol']})", "PERSONAL")
        
    return jsonify({"status": "success" if exito else "error", "message": mensaje})

@usuario_bp.route('/api/usuarios/actualizar/<int:user_id>', methods=['PUT'])
def actualizar_usuario(user_id):
    if session.get('rol') != 'Jefe':
        return jsonify({"status": "error", "message": "No tienes permiso para modificar personal"}), 403
    
    data = request.json
    exito = False
    msj = ""

    # Caso A: Cambiar el Rango (Rol)
    if 'rol' in data:
        exito, msj = actualizar_rango_usuario(user_id, data['rol'])
        if exito:
            registrar_operacion(session['user_id'], f"Cambió rol de usuario ID {user_id} a {data['rol']}", "PERSONAL")
    
    # Caso B: Cambiar el Estado (Activo/Inactivo)
    elif 'estado' in data:
        exito, msj = cambiar_estado_usuario(user_id, data['estado'])
        if exito:
            registrar_operacion(session['user_id'], f"Cambió estado de usuario ID {user_id} a {data['estado']}", "PERSONAL")
    
    else:
        return jsonify({"status": "error", "message": "Faltan datos para actualizar"}), 400
        
    return jsonify({"status": "success" if exito else "error", "message": msj})

# =======================================================
# 📜 API DE AUDITORÍA (Solo para el Jefe)
# =======================================================

@usuario_bp.route('/api/operaciones/listar', methods=['GET'])
def listar_operaciones():
    """Retorna el historial de movimientos para la tabla del Jefe"""
    if session.get('rol') != 'Jefe':
        return jsonify({"status": "error", "message": "Acceso denegado"}), 403
    
    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "Error de conexión"}), 500
    
    cursor = conn.cursor(dictionary=True)
    try:
        # Traemos las últimas 100 acciones con el nombre del responsable
        query = """
            SELECT o.fecha, u.nombre as usuario_nombre, o.modulo, o.accion 
            FROM operaciones o
            LEFT JOIN usuarios u ON o.id_usuario = u.id
            ORDER BY o.fecha DESC
            LIMIT 100
        """
        cursor.execute(query)
        operaciones = cursor.fetchall()
        return jsonify(operaciones)
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500
    finally:
        cursor.close()
        conn.close()