# 📦 NovaInventy — Sistema Inteligente de Gestión de Inventario & POS con IA

<p align="center">
  <img src="static/img/logo.png" alt="NovaInventy Logo" width="120" onerror="this.style.display='none'"/>
</p>

<p align="center">
  <strong>Plataforma web integral para el control de inventarios, punto de venta (POS) y analítica predictiva de demanda impulsada por Inteligencia Artificial.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Python-3.10+-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python" />
  <img src="https://img.shields.io/badge/Flask-3.1.3-000000?style=for-the-badge&logo=flask&logoColor=white" alt="Flask" />
  <img src="https://img.shields.io/badge/MySQL-8.0%20%2F%20MariaDB-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL" />
  <img src="https://img.shields.io/badge/Pandas-Data%20Analysis-150458?style=for-the-badge&logo=pandas&logoColor=white" alt="Pandas" />
  <img src="https://img.shields.io/badge/Chart.js-Analytics-FF6384?style=for-the-badge&logo=chartdotjs&logoColor=white" alt="Chart.js" />
</p>

---

## 📋 Descripción del Proyecto

**NovaInventy** es una solución web empresarial diseñada para optimizar la cadena de suministro y la operación comercial de micro, pequeñas y medianas empresas. Integra un sistema de **Punto de Venta (POS)** en tiempo real, un catálogo estructurado con control de existencias y un **motor analítico de IA** basado en series temporales que previene quiebres de stock y calcula proyecciones de demanda a 30 días.

---

## 🌟 Funcionalidades Principales

### 🧠 1. Motor de Inteligencia Artificial & Proyecciones (`ai/prediccion.py`)
* **Ritmo Diario y Días de Stock:** Cálculo dinámico del promedio de consumo diario y días restantes de inventario por producto.
* **Proyección de Fecha de Quiebre:** Predice con precisión la fecha estimada en que un producto quedará desabastecido.
* **Ajuste por Estacionalidad Semanal:** Detecta el mejor y peor día de venta de la semana para ponderar el ritmo de reposición.
* **Detección de Tendencias y Productos Dormidos:** Clasifica el comportamiento de ventas (*Subiendo*, *Bajando*, *Estable*) e identifica productos sin rotación (>30 días).
* **Score de Salud del Inventario (0 a 100):** Algoritmo multifactorial que evalúa la rotación, margen de ganancia y nivel de agotamiento.
* **Estimación de Pérdida Financiera:** Proyecta el impacto económico en soles/divisa si un producto crítico no es reabastecido a tiempo.

### 🛡️ 2. Seguridad y Control de Acceso Basado en Roles (RBAC)
El sistema implementa políticas estrictas de autenticación con contraseñas encriptadas (`Werkzeug/Scrypt`) y vistas segmentadas:

| Rol | Permisos y Capacidades |
| :--- | :--- |
| **👑 Jefe (Superadmin)** | Acceso global, analítica financiera ejecutiva, auditoría completa del sistema, gestión y alta de personal, activación/desactivación de usuarios y eliminación de productos. |
| **🛠️ Administrador** | Gestión de catálogo de productos (crear, editar, subir imágenes), gestión de categorías y visualización del panel de analítica/IA. |
| **🛒 Vendedor** | Operación rápida de Punto de Venta (POS), consulta de disponibilidad y registro de transacciones. |

### 💳 3. Punto de Venta (POS) & Transacciones en Vivo
* Búsqueda predictiva e interactiva de productos por código o nombre.
* Cálculo automático de totales, importes recibidos y cambio a entregar.
* Descuento y actualización de inventario atómico e inmediato en base de datos.

### 📦 4. Gestión de Productos y Categorías
* Registro, edición y eliminación de productos con código autogenerado (`PROD-XXXX`).
* Carga y almacenamiento seguro de imágenes de productos (`static/img/productos`).
* Control de stock mínimo y alertas visuales de advertencia.
* Organización jerárquica por categorías (Electrónica, Accesorios, Redes, Almacenamiento, Audio, etc.).

### 📜 5. Sistema Notarial & Auditoría Integral (`operaciones`)
* Bitácora inmutable de eventos con registro de fecha, hora, responsable y módulo (`AUTH`, `INVENTARIO`, `VENTAS`, `CATEGORIAS`, `PERSONAL`).
* Trazabilidad total de cada movimiento crítico dentro de la plataforma.

### 📊 6. Dashboard Financiero & Analítica Visual
* Indicadores clave de desempeño (KPIs): ingresos mensuales acumulados y ventas del día.
* Gráficos dinámicos e interactivos de ingresos diarios generados con **Chart.js**.
* Resumen de las últimas transacciones realizadas en la tienda.

---

## 🏗️ Arquitectura y Estructura del Proyecto

El proyecto sigue una arquitectura modular inspirada en el patrón **MVC (Modelo - Vista - Controlador)** con Blueprints de Flask:

```plaintext
app-inventario/
├── ai/
│   └── prediccion.py           # Algoritmos de análisis predictivo y métricas de IA
├── controllers/
│   ├── inventario_controller.py # Endpoints de productos, categorías, ventas y reportes
│   └── usuario_controller.py    # Autenticación, gestión de personal y auditoría
├── models/
│   ├── inventario_model.py     # Consultas y operaciones SQL de inventario/ventas
│   └── usuario_model.py        # Consultas de usuarios, hashing de contraseñas y auditoría
├── static/
│   ├── css/
│   │   ├── login.css           # Estilos para la pantalla de autenticación
│   │   └── style.css           # Sistema de diseño principal, temas y componentes
│   ├── img/
│   │   └── productos/          # Almacenamiento local de fotografías de productos
│   └── js/
│       ├── modules/            # Módulos JS independientes (ia, ventas, catalogo, etc.)
│       └── script.js           # Orquestador frontend y navegación SPA de secciones
├── templates/
│   ├── components/             # Modales, panel de IA y sidebar reutilizable
│   ├── secciones/              # Vistas parciales (dashboard, POS, personal, etc.)
│   ├── index.html              # Template principal con layout responsivo
│   └── login.html              # Vista de inicio de sesión
├── app.py                      # Punto de entrada y servidor principal Flask
├── config.py                   # Parámetros y fábrica de conexión a la Base de Datos
├── db.py                       # Conexión utilitaria para pruebas locales
├── crear_jefe.py               # Script para sembrar/crear usuarios administradores
├── InventarioIA.sql            # Script DDL/DML con esquema y datos de prueba
└── requirements.txt            # Dependencias del proyecto en Python
```

---

## 💻 Tecnologías Utilizadas

* **Backend:** Python 3.10+, Flask 3.1.3, Werkzeug (Scrypt hashing), PyMySQL, mysql-connector-python.
* **Procesamiento de Datos & IA:** Pandas, NumPy.
* **Frontend:** HTML5 semántico, CSS3 moderno (Variables CSS, diseño responsivo, glassmorphism), JavaScript ES6+ modular.
* **Visualización de Datos:** Chart.js.
* **Base de Datos:** MySQL 8.0+ / MariaDB (XAMPP compatible).

---

## 🚀 Instalación y Puesta en Marcha

Sigue estos sencillos pasos para configurar y ejecutar el proyecto en tu entorno local:

### 1. Prerrequisitos
* **Python 3.10 o superior** instalado.
* **MySQL Server** o **XAMPP / MariaDB** en ejecución.
* **Git** instalado.

---

### 2. Clonar el Repositorio
```bash
git clone https://github.com/mariannamori2006/app-inventario.git
cd app-inventario
```

---

### 3. Crear y Activar un Entorno Virtual (Recomendado)

* **En Windows (PowerShell / CMD):**
  ```bash
  python -m venv venv
  venv\Scripts\activate
  ```

* **En Linux / macOS:**
  ```bash
  python3 -m venv venv
  source venv/bin/activate
  ```

---

### 4. Instalar Dependencias
```bash
pip install -r requirements.txt
```

---

### 5. Configurar la Base de Datos
1. Inicia tu gestor de base de datos MySQL (por ejemplo, mediante el panel de control de **XAMPP** o servicio de MySQL).
2. Importa el archivo [`InventarioIA.sql`](file:///c:/app-inventario/InventarioIA.sql) en tu servidor MySQL (puedes usar **phpMyAdmin**, **MySQL Workbench** o la línea de comandos):
   ```bash
   mysql -u root -p < InventarioIA.sql
   ```
3. Verifica la configuración de conexión en [`config.py`](file:///c:/app-inventario/config.py) y [`db.py`](file:///c:/app-inventario/db.py):
   ```python
   # Ajusta el puerto (3306 o 3307), usuario y contraseña según tu entorno local:
   conexion = mysql.connector.connect(
       host="localhost",
       user="root",
       password="",
       database="InventarioIA",
       port=3307  # Cambia a 3306 si tu MySQL usa el puerto estándar
   )
   ```

---

### 6. Crear el Usuario Inicial (Jefe)
Para generar un usuario inicial con rol de **Jefe** y contraseña encriptada, ejecuta:
```bash
python crear_jefe.py
```
*(Puedes editar los valores por defecto en [`crear_jefe.py`](file:///c:/app-inventario/crear_jefe.py) antes de ejecutarlo).*

---

### 7. Iniciar el Servidor de Desarrollo
```bash
python app.py
```

Abre tu navegador web e ingresa a:
👉 **[http://127.0.0.1:5000](http://127.0.0.1:5000)**

---

## 🔑 Cuentas y Accesos de Prueba

El script SQL incluye cuentas de prueba precargadas para probar los diferentes niveles de acceso:

| Usuario | Contraseña | Rol | Acceso |
| :--- | :--- | :--- | :--- |
| `mari` | `admin123` | **Jefe** | Acceso total, auditoría, personal e IA |
| `oscar_admin` | *admin123* | **Administrador** | Inventario, productos, categorías e IA |
| `perez_vendedor`| *admin123* | **Vendedor** | Punto de Venta (POS) y catálogo |

> [!TIP]
> Si deseas crear un nuevo usuario con credenciales personalizadas, puedes utilizar directamente el script `crear_jefe.py` o crearlo desde el panel del Jefe en la sección **Personal**.

---

## 👥 Equipo de Desarrollo

* **Marianna Mori** — *Desarrollo & Arquitectura* ([@mariannamori2006](https://github.com/mariannamori2006))
* **Jhanok León** — *Desarrollo & Arquitectura*

---

## 📄 Licencia

Este proyecto fue desarrollado con fines educativos y de demostración técnica de soluciones tecnológicas aplicadas a la gestión empresarial.