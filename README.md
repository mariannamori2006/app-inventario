# APP-INVENTARO

## Descripción
Sistema web que utiliza inteligencia artificial para predecir ventas y calcular cuándo se agotará el stock de un producto.

## 🛠️ Funcionalidades Core:
- Análisis Predictivo: Cálculo de ritmo de ventas diario y proyección de días restantes de stock     mediante procesamiento de datos.
- Sistema de Auditoría (Logs): Registro inmutable de cada acción realizada (Ventas, Registros, Ediciones) para un control total del Jefe.

- Seguridad RBAC: Control de acceso basado en roles:

    - Jefe: Acceso total, analítica financiera y gestión de personal.

    - Administrador: Gestión de stock, categorías y ejecución de IA.

    - Vendedor: Operaciones de Punto de Venta (POS) y consulta de catálogo.

- Punto de Venta (POS): Buscador predictivo, cálculo automático de vueltos y actualización de stock en tiempo real.

- Dashboard Web3: Interfaz moderna y responsive con estados visuales de stock (Crítico, Reabastecer, OK).

## Funcionalidades
- Predicción de ventas mediante regresión lineal
- Cálculo de días restantes de inventario
- Recomendación de abastecimeinto
- Visualización de datos en gráficos

## Tecnologías
### Frontend
- HTML5
- CSS3
- JavaScript
- Chart.js

### Backend 
- Python
- Flask
- sCIKIT-LEARN
- Numpy 
- PyMySQL
- Base de datos: MySQL

## Equipo
- Marianna Mori
- Jhanok León

## Instalación y Uso
```bash
# Clonar el repositorio
git clone https://github.com/mariannamori2006/app-inventario.git

# Crear entorno virtual
python -m venv venv 

# Activar entorno virtual
venv\Scripts\activate

# Desactivar entorno virtual
deactivate

# Instalar dependencias 
pip instal -r requirements.txt

# Ejecutar proyecto
python app.py