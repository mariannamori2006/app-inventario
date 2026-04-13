from models.usuario_model import crear_usuario_db

# Cambia estos datos por los que tú quieras
nombre_real = "Jhanok Leon"
tu_usuario = "jhanok_jefe"
tu_clave = "admin123" # Luego la podrás cambiar

exito, msj = crear_usuario_db(nombre_real, tu_usuario, tu_clave, "Jefe")

if exito:
    print(f"✅ ¡Felicidades! El Jefe {nombre_real} ha sido creado.")
else:
    print(f"❌ Error: {msj}")