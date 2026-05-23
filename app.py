from flask import Flask, redirect, url_for, session

from controllers.usuario_controller import usuario_bp
from controllers.inventario_controller import inventario_bp

app = Flask(__name__)

app.secret_key = 'novainventy_clave_super_secreta_2026'

app.register_blueprint(usuario_bp, url_prefix='/auth')

app.register_blueprint(inventario_bp)

# -------------------------------------------------------------------
# RUTA PRINCIPAL (La puerta de entrada)
# -------------------------------------------------------------------
@app.route('/')
def home():
    # Si el usuario ya está logueado, lo mandamos directo al dashboard
    if 'user_id' in session:
        return redirect(url_for('inventario.index'))
    
    # Si no tiene sesión activa, lo rebotamos a la pantalla de login
    return redirect(url_for('usuarios.login'))

# -------------------------------------------------------------------
# ARRANQUE DEL SERVIDOR
# -------------------------------------------------------------------
if __name__ == '__main__':
    print("Iniciando motor principal de NovaInventy...")
    print("Entra a: http://127.0.0.1:5000")
    # debug=True reinicia el servidor solo si haces cambios
    app.run(debug=True)