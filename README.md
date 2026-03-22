# Ampliacion de Robotica

Repositorio de practicas de la asignatura **Ampliacion de Robotica**.

Entorno: ROS2 Humble + CoppeliaSim (Docker)

**Autores:** Saul Gutierrez Rodriguez, Pablo Haro Garcia, Mario Merino Prado

---

## Estructura

```
ampliacion_robotica/
├── robotica_movil/          # Codigo fuente de practicas de Robotica Movil
├── manipuladores/           # Codigo fuente de practicas de Manipuladores
├── memorias/                # Memorias LaTeX de todas las practicas
│   ├── common/              # Preamble, comandos y assets compartidos
│   ├── robotica_movil/      # Una carpeta por practica con main.tex + figures/
│   └── Makefile             # Compilacion y subida a Google Drive
├── scripts/                 # Scripts auxiliares
└── .templates/              # Plantillas base
```

---

## Memorias (PDFs)

Las memorias de cada practica estan disponibles como PDF compilado dentro del repositorio:

### Robotica Movil

| Lab | Titulo | PDF | Video | Estado |
|-----|--------|-----|-------|--------|
| Lab-MR1-I | Seguimiento de caminos explicitos | [`main.pdf`](memorias/robotica_movil/lab1_caminos_explicitos/main.pdf) | - | Completada |
| Lab-MR1-II | Seguimiento de caminos implicitos | [`main.pdf`](memorias/robotica_movil/lab1_caminos_implicitos/main.pdf) | [Drive](https://drive.google.com/file/d/1I6tOLcURG61m_-ohzUyiiBDkwep3uvLk/view) | Completada |
| Lab-MR2 | Percepcion del entorno | [`main.pdf`](memorias/robotica_movil/lab2_percepcion/main.pdf) | [Drive](https://drive.google.com/file/d/1FnFhbGMeaFnEXlVtZfJK5_TjgRE5hLpe/view) | Completada |
| Lab-MR4 | Campos potenciales | [`main.pdf`](memorias/robotica_movil/lab4_campos_potenciales/main.pdf) | - | Esqueleto |

### Manipuladores

| Lab | Titulo | PDF | Video | Estado |
|-----|--------|-----|-------|--------|
| - | - | - | - | - |

---

## Codigo fuente

### Robotica Movil

| Lab | Paquete ROS2 | Nodo principal | Descripcion |
|-----|-------------|----------------|-------------|
| Lab-MR1-I | `seg_tray` | `nav_p2p` | Navegacion punto a punto con control proporcional |
| Lab-MR1-II | `seg_tray` | `corr_nav` | Corridor-following con Pure Pursuit y LiDAR |
| Lab-MR2 | `seg_tray` | `corr_nav_wall` | Estimacion de paredes por minimos cuadrados |
| Lab-MR4 | - | MATLAB script | Campos potenciales artificiales |

---

## Uso rapido

### Compilar memorias

Requiere `latexmk` y `pdflatex` instalados.

```bash
cd memorias

# Compilar todas las memorias
make all

# Compilar una practica concreta
make lab1i      # Lab-MR1-I
make lab1ii     # Lab-MR1-II
make lab2       # Lab-MR2
make lab4       # Lab-MR4

# Subir PDFs a Google Drive (requiere rclone configurado)
make upload

# Limpiar artefactos de compilacion
make clean
```

### Enlazar paquetes ROS2 al workspace

```bash
# Enlazar todos los paquetes de una practica
./scripts/symlink_pkg.sh robotica_movil/labmr_1i_caminos_explicitos

# Desenlazar
./scripts/symlink_pkg.sh --remove robotica_movil/labmr_1i_caminos_explicitos
```

### Compilar codigo ROS2 dentro del contenedor

```bash
cd ~/colcon_ws
colcon build --symlink-install
source install/setup.bash
```

### Ejecutar una practica

```bash
# Lab-MR1-I: navegacion punto a punto
ros2 launch seg_tray nav_p2p_launch.py

# Lab-MR1-II: corridor following
ros2 launch seg_tray corr_nav_launch.py

# Lab-MR2: corridor following con estimacion de paredes
ros2 launch seg_tray corr_nav_wall_launch.py
```
