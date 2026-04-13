import mysql.connector

def get_db_connection():
    try:
        conexion = mysql.connector.connect(
            host="localhost",
            user="root",      # Usuario por defecto de XAMPP
            password="",      # Contraseña por defecto (vacía)
            database="InventarioIA"
        )
        return conexion
    except mysql.connector.Error as err:
        print(f"Error de conexión a MySQL: {err}")
        return None