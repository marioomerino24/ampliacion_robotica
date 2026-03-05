# Ampliacion de Robotica

Repositorio de practicas de la asignatura **Ampliacion de Robotica**.

Entorno: ROS2 Humble + CoppeliaSim (Docker)

---

## Estructura

```
ampliacion_robotica/
├── robotica_movil/          # Practicas de Robotica Movil (LabMR)
├── manipuladores/           # Practicas de Manipuladores (LabMAN)
├── scripts/                 # Scripts auxiliares
│   ├── nueva_practica.sh    # Genera una practica nueva desde plantilla
│   └── symlink_pkg.sh       # Enlaza paquetes ROS2 al workspace
└── .templates/              # Plantillas base
```

## Practicas

### Robotica Movil

| Lab | Titulo | Estado |
|-----|--------|--------|
| LabMR 1-I | Seguimiento de caminos explicitos | En curso |
| LabMR 1-II | Seguimiento de caminos implicitos | Pendiente |

### Manipuladores

| Lab | Titulo | Estado |
|-----|--------|--------|
| - | - | - |

---

## Uso rapido

### Crear una practica nueva

```bash
./scripts/nueva_practica.sh robotica_movil labmr_2i "LabMR 2-I: Titulo de la practica"
```

### Enlazar paquetes ROS2 al workspace

```bash
# Enlazar todos los paquetes de una practica
./scripts/symlink_pkg.sh robotica_movil/labmr_1i_caminos_explicitos

# Desenlazar
./scripts/symlink_pkg.sh --remove robotica_movil/labmr_1i_caminos_explicitos
```

### Compilar dentro del contenedor

```bash
cd ~/colcon_ws
colcon build --symlink-install
source install/setup.bash
```
