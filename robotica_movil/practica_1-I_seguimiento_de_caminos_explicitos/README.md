# Práctica 1-I: Seguimiento de caminos explícitos

## Objetivo

[Descripcion breve del objetivo de la practica]

## Escenas CoppeliaSim

| Archivo | Descripcion |
|---------|-------------|
| `scenes/` | [Descripcion de la escena] |

## Paquetes ROS2

| Paquete | Descripcion |
|---------|-------------|
| `ros2_ws/` | [Descripcion del paquete] |

## Ejecucion

```bash
# 1. Enlazar paquetes al workspace (desde la raiz del repo)
./scripts/symlink_pkg.sh robotica_movil/practica_1-I_seguimiento_de_caminos_explicitos

# 2. Compilar
cd ~/colcon_ws && colcon build --symlink-install && source install/setup.bash

# 3. Lanzar
ros2 launch <paquete> <launch_file>
```

## Notas

[Observaciones relevantes]
