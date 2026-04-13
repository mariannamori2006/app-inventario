import mysql.connector
from mysql.connector import Error

def get_db_connection():
    """
    Establece la conexión con la base de datos MySQL.
    Asegúrate de tener XAMPP/MySQL encendido antes de correr el programa.
    """
    try:
        connection = mysql.connector.connect(
            host='localhost',      # Servidor local
            user='root',           # Usuario por defecto de XAMPP
            password='',           # Contraseña por defecto (vía vacía)
            database='InventarioIA' # El nombre exacto de tu BD en el SQL
        )

        if connection.is_connected():
            return connection

    except Error as e:
        print(f"❌ Error al conectar a la base de datos: {e}")
        return None

# Este bloque es opcional, sirve para probar el archivo solo
if __name__ == "__main__":
    prueba = get_db_connection()
    if prueba:
        print("✅ ¡Conexión exitosa a InventarioIA!")
        prueba.close()