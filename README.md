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

| Práctica | Titulo | PDF | Video | Estado |
|-----|--------|-----|-------|--------|
| Práctica 1-I | Seguimiento de caminos explícitos | [`main.pdf`](memorias/robotica_movil/lab1-I_caminos_explicitos/main.pdf) | [Drive](https://drive.google.com/drive/folders/1ne8Xvr6KsiIRRmqDgXzSwK89ENE5QpWu?usp=drive_link) | Completada |
| Práctica 1-II | Seguimiento de caminos implícitos | [`main.pdf`](memorias/robotica_movil/lab1-II_caminos_implicitos/main.pdf) | [Drive](https://drive.google.com/file/d/1I6tOLcURG61m_-ohzUyiiBDkwep3uvLk/view) | Completada |
| Práctica 2 | Percepción del entorno | [`main.pdf`](memorias/robotica_movil/lab2_percepcion/main.pdf) | [Drive](https://drive.google.com/file/d/1FnFhbGMeaFnEXlVtZfJK5_TjgRE5hLpe/view) | Completada |
| Práctica 3 | Evitar obstáculos mediante campos potenciales | [`main.pdf`](memorias/robotica_movil/lab3_campos_potenciales/main.pdf) | - | Esqueleto |
| Práctica 6 | Navegación completa | [`main.pdf`](memorias/robotica_movil/lab6_navegacion_completa/main.pdf) | - | Esqueleto |

### Manipuladores

| Lab | Titulo | PDF | Video | Estado |
|-----|--------|-----|-------|--------|
| - | - | - | - | - |

---

## Codigo fuente

### Robotica Movil

| Práctica | Paquete ROS2 | Nodo principal | Descripcion |
|-----|-------------|----------------|-------------|
| Práctica 1-I | `seg_tray` | `nav_p2p` | Navegacion punto a punto con control proporcional |
| Práctica 1-II | `seg_tray` | `corr_nav` | Corridor-following con Pure Pursuit y LiDAR |
| Práctica 2 | `seg_tray` | `corr_nav_wall` | Estimacion de paredes por minimos cuadrados |
| Práctica 3 | - | MATLAB script | Campos potenciales artificiales |
| Práctica 4 | - | `dijkstra.m` | Planificacion global en grafos mediante Dijkstra |
| Práctica 5 | - | - | Carpeta preparada con el enunciado oficial de A* |
| Práctica 6 | - | MATLAB script | Integracion de Dijkstra/A* con campos potenciales |

---

## Uso rapido

### Compilar memorias

Requiere `latexmk` y `pdflatex` instalados.

```bash
cd memorias

# Compilar todas las memorias
make all

# Compilar una practica concreta
make lab1-I     # Práctica 1-I (caminos explícitos)
make lab1-II    # Práctica 1-II (caminos implícitos)
make lab2       # Práctica 2
make lab3       # Práctica 3
make lab6       # Práctica 6

# Subir PDFs a Google Drive (requiere rclone configurado)
make upload

# Limpiar artefactos de compilacion
make clean
```

### Enlazar paquetes ROS2 al workspace

```bash
# Enlazar todos los paquetes de una practica
./scripts/symlink_pkg.sh robotica_movil/practica_1-I_seguimiento_de_caminos_explicitos

# Desenlazar
./scripts/symlink_pkg.sh --remove robotica_movil/practica_1-I_seguimiento_de_caminos_explicitos
```

### Compilar codigo ROS2 dentro del contenedor

```bash
cd ~/colcon_ws
colcon build --symlink-install
source install/setup.bash
```

### Ejecutar una practica

```bash
# Práctica 1-I: navegacion punto a punto
ros2 launch seg_tray nav_p2p_launch.py

# Práctica 1-II: corridor following
ros2 launch seg_tray corr_nav_launch.py

# Práctica 2: corridor following con estimacion de paredes
ros2 launch seg_tray corr_nav_wall_launch.py
```
