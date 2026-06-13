# APP-INVENTARIO

## Descripción
Sistema web inteligente diseñado para la gestión de inventarios, que utiliza análisis de datos para predecir ventas y optimizar los niveles de stock. El sistema ayuda a prevenir quiebres de inventario y optimiza la toma de decisiones mediante métricas precisas.

## 🛠️ Funcionalidades Principales
* **Análisis Predictivo:** Cálculo de ritmo de ventas diario y proyección de fechas críticas de agotamiento de stock mediante procesamiento de series temporales.
* **Sistema de Auditoría (Logs):** Registro inmutable de cada acción realizada (ventas, registros, ediciones) para garantizar la trazabilidad.
* **Seguridad RBAC:** Control de acceso basado en roles:
    * **Jefe:** Acceso total, analítica financiera y gestión de personal.
    * **Administrador:** Gestión de stock, categorías y ejecución de reportes de IA.
    * **Vendedor:** Operaciones de Punto de Venta (POS) y consulta de catálogo.
* **Punto de Venta (POS):** Interfaz ágil con buscador predictivo, cálculo automático de cambio y actualización de inventario en tiempo real.
* **Dashboard de Inteligencia:** Panel visual con indicadores de salud de stock (Crítico, Reabastecer, OK) y proyecciones a 30 días.

## Tecnologías Utilizadas
### Frontend
* HTML5, CSS3, JavaScript
* **Librerías:** Chart.js (Visualización de datos)

### Backend 
* **Lenguaje:** Python
* **Framework:** Flask
* **Análisis de Datos:** Pandas
* **Base de Datos:** MySQL (PyMySQL)

## Equipo
* Marianna Mori
* Jhanok León

## Instalación y Configuración

1. **Clonar el repositorio:**
   ```bash
   git clone [https://github.com/mariannamori2006/app-inventario.git](https://github.com/mariannamori2006/app-inventario.git)
   cd app-inventario