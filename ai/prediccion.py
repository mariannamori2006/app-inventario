import pandas as pd
from config import get_db_connection

def analizar_ventas_ia():
    # 1. Nos conectamos
    conn = get_db_connection()
    if not conn:
        return {"status": "error", "message": "Error de conexión a la BD"}
    
    cursor = conn.cursor(dictionary=True)
    
    # 2. Extraemos los datos
    query = """
    SELECT p.id, p.nombre, p.stock_actual, v.cantidad, v.fecha_venta 
    FROM productos p
    LEFT JOIN ventas v ON p.id = v.id_producto
    """
    cursor.execute(query)
    data = cursor.fetchall()
    
    cursor.close()
    conn.close()

    # 3. Metemos los datos a Pandas
    df = pd.DataFrame(data)
    
    if df.empty or 'cantidad' not in df or df['cantidad'].isnull().all():
        return {"status": "info", "message": "Registra ventas para iniciar la IA"}

    predicciones = []
    
    # 4. Matemáticas Predictivas por cada producto
    for producto_id in df['id'].unique():
        prod_data = df[df['id'] == producto_id]
        
        # ¡EL PARCHE ESTÁ AQUÍ! Forzamos a que sean tipos nativos de Python (str, int)
        nombre = str(prod_data['nombre'].iloc[0])
        stock_actual = int(prod_data['stock_actual'].iloc[0])
        
        ventas_reales = prod_data.dropna(subset=['cantidad'])
        
        if not ventas_reales.empty:
            # También forzamos el total_vendido a float nativo
            total_vendido = float(ventas_reales['cantidad'].sum())
            fecha_inicio = pd.to_datetime(ventas_reales['fecha_venta']).min()
            dias_transcurridos = (pd.Timestamp.now() - fecha_inicio).days + 1
            
            ritmo = total_vendido / dias_transcurridos
            dias_para_fin = int(stock_actual / ritmo) if ritmo > 0 else 999
        else:
            ritmo = 0
            dias_para_fin = 999

        # Sistema de Alertas
        alerta = "OK"
        if dias_para_fin < 3: alerta = "CRÍTICO"
        elif dias_para_fin < 7: alerta = "REABASTECER"

        predicciones.append({
            "producto": nombre,
            "stock": stock_actual,
            "ritmo_venta": round(ritmo, 2),
            "dias_restantes": dias_para_fin,
            "alerta": alerta
        })

    return {"status": "success", "data": predicciones}