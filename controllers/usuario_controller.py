from flask import Blueprint, render_template, request, redirect, url_for, session, flash, jsonify
from models.usuario_model import (
    verificar_credenciales, 
    crear_usuario_db, 
    obtener_todos_los_usuarios, 
    actualizar_rango_usuario, 
    cambiar_estado_usuario
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
            return redirect(url_for('inventario.index')) 
        else:
            flash("Usuario o contraseña incorrectos", "danger")
            
    return render_template('login.html')

@usuario_bp.route('/logout')
def logout():
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
    return jsonify({"status": "success" if exito else "error", "message": mensaje})

@usuario_bp.route('/api/usuarios/actualizar/<int:user_id>', methods=['PUT'])
def actualizar_usuario(user_id):
    # Seguridad: Solo tú puedes disparar esta ruta
    if session.get('rol') != 'Jefe':
        return jsonify({"status": "error", "message": "No tienes permiso para modificar personal"}), 403
    
    data = request.json
    
    # Caso A: Cambiar el Rango (Rol)
    if 'rol' in data:
        exito, msj = actualizar_rango_usuario(user_id, data['rol'])
    
    # Caso B: Cambiar el Estado (Activo/Inactivo)
    elif 'estado' in data:
        exito, msj = cambiar_estado_usuario(user_id, data['estado'])
    
    else:
        return jsonify({"status": "error", "message": "Faltan datos para actualizar"}), 400
        
    return jsonify({"status": "success" if exito else "error", "message": msj})