from db import get_db_connection
from werkzeug.security import generate_password_hash, check_password_hash

def crear_usuario_db(nombre, username, password, rol):
    conn = get_db_connection()
    if not conn: return False, "Error de conexión"
    
    cursor = conn.cursor()
    # Encriptamos la contraseña por seguridad
    password_hash = generate_password_hash(password)
    
    try:
        cursor.execute("""
            INSERT INTO usuarios (nombre, username, password, rol, estado)
            VALUES (%s, %s, %s, %s, 'Activo')
        """, (nombre, username, password_hash, rol))
        conn.commit()
        return True, "Usuario creado exitosamente"
    except Exception as e:
        return False, str(e)
    finally:
        cursor.close()
        conn.close()

def verificar_credenciales(username, password):
    conn = get_db_connection()
    if not conn: return None
    
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM usuarios WHERE username = %s AND estado = 'Activo'", (username,))
    usuario = cursor.fetchone()
    cursor.close()
    conn.close()

    if usuario and check_password_hash(usuario['password'], password):
        return usuario
    return None

def obtener_todos_los_usuarios():
    """Retorna la lista de personal para la tabla del Jefe"""
    conn = get_db_connection()
    if not conn: return []
    
    try:
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT id, nombre, username, rol, estado FROM usuarios ORDER BY nombre ASC")
        return cursor.fetchall()
    finally:
        cursor.close()
        conn.close()

def actualizar_rango_usuario(user_id, nuevo_rol):
    """Guarda el cambio de rango (Jefe, Admin, Vendedor) en la BD"""
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("UPDATE usuarios SET rol = %s WHERE id = %s", (nuevo_rol, user_id))
        conn.commit()
        return True, "Rango actualizado correctamente"
    except Exception as e: 
        return False, str(e)
    finally:
        cursor.close()
        conn.close()

def cambiar_estado_usuario(user_id, nuevo_estado):
    """Guarda si el usuario está Activo o Inactivo"""
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("UPDATE usuarios SET estado = %s WHERE id = %s", (nuevo_estado, user_id))
        conn.commit()
        return True, f"Usuario marcado como {nuevo_estado}"
    except Exception as e: 
        return False, str(e)
    finally:
        cursor.close()
        conn.close()