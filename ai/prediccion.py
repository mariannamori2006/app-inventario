import pandas as pd
from config import get_db_connection
from datetime import datetime, timedelta

def analizar_ventas_ia():
    conn = get_db_connection()
    if not conn:
        return {"status": "error", "message": "Error de conexión a la BD"}
    
    cursor = conn.cursor(dictionary=True)
    query = """
    SELECT p.id, p.nombre, p.stock_actual, p.precio_compra, p.precio_venta, 
    v.cantidad, v.fecha_venta 
    FROM productos p
    LEFT JOIN ventas v ON p.id = v.id_producto
    AND v.fecha_venta >= DATE_SUB(NOW(), INTERVAL 90 DAY)
    """
    cursor.execute(query)
    data = cursor.fetchall()
    cursor.close()
    conn.close()

    df = pd.DataFrame(data)
    
    if df.empty or df['cantidad'].isnull().all():
        return {"status": "info", "message": "Registra ventas para iniciar la IA"}

    predicciones = []
    hoy = datetime.now()
    
    for producto_id in df['id'].unique():
        prod_data = df[df['id'] == producto_id]
        
        nombre        = str(prod_data['nombre'].iloc[0])
        stock_actual  = int(prod_data['stock_actual'].iloc[0])
        precio_compra = float(prod_data['precio_compra'].iloc[0])
        precio_venta  = float(prod_data['precio_venta'].iloc[0])
        
        ventas_reales = prod_data.dropna(subset=['cantidad']).copy()
        
        if not ventas_reales.empty:
            ventas_reales['fecha_venta'] = pd.to_datetime(ventas_reales['fecha_venta'])
            total_vendido      = float(ventas_reales['cantidad'].sum())
            fecha_inicio       = ventas_reales['fecha_venta'].min()
            dias_transcurridos = max((hoy - fecha_inicio).days + 1, 1)
            ritmo_diario       = total_vendido / dias_transcurridos
            dias_restantes     = int(stock_actual / ritmo_diario) if ritmo_diario > 0 else 999

            if dias_restantes < 999:
                fecha_quiebre = (hoy + timedelta(days=dias_restantes)).strftime("%d/%m/%Y")
            else:
                fecha_quiebre = "Sin datos suficientes"

            # Tendencia semanal
            hace_7  = hoy - timedelta(days=7)
            hace_14 = hoy - timedelta(days=14)
            ventas_7d  = ventas_reales[ventas_reales['fecha_venta'] >= hace_7]['cantidad'].sum()
            ventas_14d = ventas_reales[
                (ventas_reales['fecha_venta'] >= hace_14) &
                (ventas_reales['fecha_venta'] < hace_7)
            ]['cantidad'].sum()

            if ventas_14d > 0:
                cambio_pct = round(((ventas_7d - ventas_14d) / ventas_14d) * 100, 1)
            elif ventas_7d > 0:
                cambio_pct = 100.0
            else:
                cambio_pct = 0.0

            tendencia = "subiendo" if cambio_pct > 10 else ("bajando" if cambio_pct < -10 else "estable")

            # ── TENDENCIA ESTACIONAL — día de la semana ──────────────────
            ventas_reales['dia_semana'] = ventas_reales['fecha_venta'].dt.dayofweek
            ventas_por_dia = ventas_reales.groupby('dia_semana')['cantidad'].sum()
            
            dias_nombres = {0:'lunes', 1:'martes', 2:'miércoles', 3:'jueves', 
                           4:'viernes', 5:'sábado', 6:'domingo'}
            
            if len(ventas_por_dia) >= 3:
                mejor_dia_num = int(ventas_por_dia.idxmax())
                peor_dia_num  = int(ventas_por_dia.idxmin())
                mejor_dia = dias_nombres[mejor_dia_num]
                peor_dia  = dias_nombres[peor_dia_num]
                
                # Ritmo ajustado según el día actual
                dia_hoy = hoy.weekday()
                factor_hoy = float(ventas_por_dia.get(dia_hoy, ventas_por_dia.mean()))
                factor_promedio = float(ventas_por_dia.mean())
                factor_estacional = factor_hoy / factor_promedio if factor_promedio > 0 else 1.0
                ritmo_ajustado = round(ritmo_diario * factor_estacional, 2)
            else:
                mejor_dia = None
                peor_dia  = None
                ritmo_ajustado = round(ritmo_diario, 2)

            ultima_venta   = ventas_reales['fecha_venta'].max()
            dias_sin_venta = (hoy - ultima_venta).days
            dormido        = dias_sin_venta > 30

        else:
            ritmo_diario   = 0.0
            ritmo_ajustado = 0.0
            dias_restantes = 999
            fecha_quiebre  = "Sin ventas registradas"
            cambio_pct     = 0.0
            tendencia      = "sin datos"
            dormido        = True
            dias_sin_venta = 999
            mejor_dia      = None
            peor_dia       = None

        margen_sol = round(precio_venta - precio_compra, 2)
        margen_pct = round((margen_sol / precio_compra) * 100, 1) if precio_compra > 0 else 0

        score = 100
        if dias_restantes < 5:      score -= 50
        elif dias_restantes < 15:   score -= 25
        elif dias_restantes < 30:   score -= 10

        if dormido:                 score -= 30
        elif tendencia == "bajando": score -= 15
        elif tendencia == "subiendo": score += 5

        if margen_pct < 10:         score -= 10
        elif margen_pct > 40:       score += 5

        score = max(0, min(100, score))

        if dormido and stock_actual > 0:
            alerta = "DORMIDO"
        elif dias_restantes <= 5:
            alerta = "CRITICO"
        elif dias_restantes <= 15:
            alerta = "REABASTECER"
        else:
            alerta = "OK"

        # ── PROYECCIÓN 30 días ────────────────────────────────────────────
        proyeccion = []
        if alerta in ["CRITICO", "REABASTECER"] and ritmo_diario > 0:
            for dia in range(0, 31):
                stock_proyectado = round(stock_actual - (ritmo_diario * dia), 1)
                stock_proyectado = max(stock_proyectado, 0)
                fecha_dia = (hoy + timedelta(days=dia)).strftime("%d/%m")
                proyeccion.append({"dia": dia, "fecha": fecha_dia, "stock": stock_proyectado})

        # ── PÉRDIDA ESTIMADA si no reabastece ────────────────────────────
        if alerta in ["CRITICO", "REABASTECER"] and ritmo_diario > 0:
            dias_sin_stock = max(30 - dias_restantes, 0)
            perdida_estimada = round(dias_sin_stock * ritmo_diario * precio_venta, 2)
        else:
            perdida_estimada = 0.0

        predicciones.append({
            "producto":         nombre,
            "stock":            stock_actual,
            "ritmo_venta":      round(ritmo_diario, 2),
            "ritmo_ajustado":   ritmo_ajustado,
            "dias_restantes":   dias_restantes,
            "fecha_quiebre":    fecha_quiebre,
            "tendencia":        tendencia,
            "cambio_pct":       cambio_pct,
            "dormido":          dormido,
            "dias_sin_venta":   dias_sin_venta if dias_sin_venta < 999 else None,
            "margen_sol":       margen_sol,
            "margen_pct":       margen_pct,
            "score_salud":      score,
            "alerta":           alerta,
            "proyeccion":       proyeccion,
            "mejor_dia":        mejor_dia,
            "peor_dia":         peor_dia,
            "perdida_estimada": perdida_estimada,
        })

    predicciones.sort(key=lambda x: x['score_salud'])

    # ── RESUMEN EJECUTIVO ─────────────────────────────────────────────────
    criticos   = [p for p in predicciones if p['alerta'] == 'CRITICO']
    reabast    = [p for p in predicciones if p['alerta'] == 'REABASTECER']
    dormidos   = [p for p in predicciones if p['alerta'] == 'DORMIDO']
    saludables = [p for p in predicciones if p['alerta'] == 'OK']
    
    perdida_total = round(sum(p['perdida_estimada'] for p in predicciones), 2)

    resumen = {
        "criticos":      len(criticos),
        "reabastecer":   len(reabast),
        "dormidos":      len(dormidos),
        "saludables":    len(saludables),
        "perdida_total": perdida_total,
        "total":         len(predicciones),
    }

    return {"status": "success", "data": predicciones, "resumen": resumen}