from flask import Blueprint, request, jsonify, render_template, session, redirect, url_for

# Importamos las funciones del Modelo
from models.inventario_model import (
    obtener_categorias, guardar_categoria,
    obtener_productos, guardar_producto,
    registrar_venta_db, obtener_analitica,
    actualizar_producto_db, eliminar_producto_db
)
from ai.prediccion import analizar_ventas_ia

inventario_bp = Blueprint('inventario', __name__)

@inventario_bp.route('/dashboard')
def index():
    if 'user_id' not in session:
        return redirect(url_for('usuarios.login'))
    return render_template('index.html', nombre_jefe=session.get('nombre', 'Usuario'))

# --- RUTAS DE CATEGORÍAS ---
@inventario_bp.route('/api/categorias', methods=['GET', 'POST'])
def gestionar_categorias():
    if request.method == 'POST':
        if session.get('rol') not in ['Jefe', 'Administrador']:
            return jsonify({"status": "error", "message": "No tienes permiso para crear categorías"}), 403
        data = request.json
        exito, mensaje = guardar_categoria(data['nombre'])
        return jsonify({"status": "success" if exito else "error", "message": mensaje})
    return jsonify({"status": "success", "data": obtener_categorias()})

# --- RUTAS DE PRODUCTOS ---
@inventario_bp.route('/api/productos', methods=['GET', 'POST'])
def gestionar_productos():
    if request.method == 'POST':
        if session.get('rol') not in ['Jefe', 'Administrador']:
            return jsonify({"status": "error", "message": "No autorizado"}), 403
        data = request.json
        exito, mensaje = guardar_producto(
            data.get('codigo'), data['nombre'], data['id_categoria'], 
            data['precio_compra'], data['precio_venta'], data['stock']
        )
        return jsonify({"status": "success" if exito else "error", "message": mensaje})
    return jsonify({"status": "success", "data": obtener_productos()})

# --- NUEVA RUTA: EDITAR PRODUCTO (ADMIN Y JEFE) ---
@inventario_bp.route('/api/productos/editar/<int:id_prod>', methods=['PUT'])
def editar_producto(id_prod):
    if session.get('rol') not in ['Jefe', 'Administrador']:
        return jsonify({"status": "error", "message": "Acceso denegado"}), 403
    
    data = request.json
    # Python procesa la actualización. 
    # La lógica de "qué campos se envían" ya la controlamos en el script.js según el rol.
    exito, mensaje = actualizar_producto_db(
        id_prod, data['nombre'], data['id_categoria'], 
        data['precio_compra'], data['precio_venta'], data['stock']
    )
    return jsonify({"status": "success" if exito else "error", "message": mensaje})

# --- NUEVA RUTA: ELIMINAR PRODUCTO (SOLO JEFE) ---
@inventario_bp.route('/api/productos/eliminar/<int:id_prod>', methods=['DELETE'])
def eliminar_producto(id_prod):
    if session.get('rol') != 'Jefe':
        return jsonify({"status": "error", "message": "¡Solo el Jefe puede eliminar equipos permanentemente!"}), 403
    
    exito, mensaje = eliminar_producto_db(id_prod)
    return jsonify({"status": "success" if exito else "error", "message": mensaje})

# --- RUTAS DE VENTAS Y ANALÍTICA ---
@inventario_bp.route('/api/ventas', methods=['POST'])
def registrar_venta():
    data = request.json
    exito, mensaje = registrar_venta_db(data['id_producto'], data['cantidad'], data['precio'])
    return jsonify({"status": "success" if exito else "error", "message": mensaje})

@inventario_bp.route('/api/reportes', methods=['GET'])
def datos_analitica():
    exito, datos = obtener_analitica()
    return jsonify({"status": "success" if exito else "error", "data": datos if exito else str(datos)})

@inventario_bp.route('/api/ia/prediccion', methods=['GET'])
def ejecutar_ia():
    return jsonify(analizar_ventas_ia())