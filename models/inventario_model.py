from config import get_db_connection

# ================= CATEGORÍAS =================
def obtener_categorias():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM categorias ORDER BY nombre ASC")
    datos = cursor.fetchall()
    cursor.close()
    conn.close()
    return datos

def guardar_categoria(nombre):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("INSERT INTO categorias (nombre) VALUES (%s)", (nombre,))
        conn.commit()
        return True, "Categoría guardada correctamente"
    except Exception as e:
        return False, str(e)
    finally:
        cursor.close()
        conn.close()

# ================= PRODUCTOS =================
def obtener_productos():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    query = """
    SELECT p.*, c.nombre as categoria_nombre 
    FROM productos p 
    LEFT JOIN categorias c ON p.id_categoria = c.id
    ORDER BY p.nombre ASC
    """
    cursor.execute(query)
    datos = cursor.fetchall()
    cursor.close()
    conn.close()
    return datos

def guardar_producto(codigo, nombre, id_categoria, precio_compra, precio_venta, stock):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        if not codigo:
            cursor.execute("SELECT COUNT(*) as total FROM productos")
            count = cursor.fetchone()['total']
            codigo = f"PROD-{(count + 1):04d}"

        query = """INSERT INTO productos (codigo, nombre, id_categoria, precio_compra, precio_venta, stock_actual) 
                   VALUES (%s, %s, %s, %s, %s, %s)"""
        cursor.execute(query, (codigo, nombre, id_categoria, precio_compra, precio_venta, stock))
        conn.commit()
        return True, f"Producto registrado: {codigo}"
    except Exception as e:
        return False, str(e)
    finally:
        cursor.close()
        conn.close()

# NUEVA FUNCIÓN: ACTUALIZAR PRODUCTO (CRUD)
def actualizar_producto_db(id_prod, nombre, id_categoria, p_compra, p_venta, stock):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        query = """
            UPDATE productos 
            SET nombre = %s, id_categoria = %s, precio_compra = %s, precio_venta = %s, stock_actual = %s 
            WHERE id = %s
        """
        cursor.execute(query, (nombre, id_categoria, p_compra, p_venta, stock, id_prod))
        conn.commit()
        return True, "Producto actualizado correctamente"
    except Exception as e:
        return False, str(e)
    finally:
        cursor.close()
        conn.close()

# NUEVA FUNCIÓN: ELIMINAR PRODUCTO (SOLO JEFE)
def eliminar_producto_db(id_prod):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM productos WHERE id = %s", (id_prod,))
        conn.commit()
        return True, "Producto eliminado permanentemente"
    except Exception as e:
        return False, str(e)
    finally:
        cursor.close()
        conn.close()

# ================= VENTAS =================
def registrar_venta_db(id_producto, cantidad, precio):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("INSERT INTO ventas (id_producto, cantidad, precio_venta_historico) VALUES (%s, %s, %s)",
                       (id_producto, cantidad, precio))
        cursor.execute("UPDATE productos SET stock_actual = stock_actual - %s WHERE id = %s",
                       (cantidad, id_producto))
        conn.commit()
        return True, "Venta exitosa"
    except Exception as e:
        return False, str(e)
    finally:
        cursor.close()
        conn.close()

# ================= REPORTES Y ANALÍTICA =================
def obtener_analitica():
    conn = get_db_connection()
    if not conn: return False, "Error de conexión"
    cursor = conn.cursor(dictionary=True)
    reporte = {}
    try:
        cursor.execute("""
            SELECT SUM(v.cantidad * p.precio_venta) as total 
            FROM ventas v
            JOIN productos p ON v.id_producto = p.id
            WHERE MONTH(v.fecha_venta) = MONTH(CURRENT_DATE()) AND YEAR(v.fecha_venta) = YEAR(CURRENT_DATE())
        """)
        res_mes = cursor.fetchone()
        reporte['ingresos_mes'] = res_mes['total'] if res_mes['total'] else 0

        cursor.execute("SELECT COUNT(*) as total FROM ventas WHERE DATE(fecha_venta) = CURRENT_DATE()")
        res_hoy = cursor.fetchone()
        reporte['ventas_hoy'] = res_hoy['total'] if res_hoy['total'] else 0

        cursor.execute("""
            SELECT DATE_FORMAT(v.fecha_venta, '%d/%m') as fecha, SUM(v.cantidad * p.precio_venta) as total
            FROM ventas v
            JOIN productos p ON v.id_producto = p.id
            WHERE v.fecha_venta >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
            GROUP BY DATE(v.fecha_venta)
            ORDER BY v.fecha_venta ASC
        """)
        reporte['grafico_dias'] = cursor.fetchall()

        cursor.execute("""
            SELECT DATE_FORMAT(v.fecha_venta, '%d/%m %H:%i') as fecha, p.codigo, p.nombre, v.cantidad, (v.cantidad * p.precio_venta) as total
            FROM ventas v 
            JOIN productos p ON v.id_producto = p.id
            ORDER BY v.fecha_venta DESC LIMIT 5
        """)
        reporte['transacciones'] = cursor.fetchall()
        return True, reporte
    except Exception as e:
        return False, str(e)
    finally:
        cursor.close()
        conn.close()