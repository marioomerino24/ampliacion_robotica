# LabMR 2: Percepcion del entorno

## Objetivo

Extraer informacion del entorno util para la tarea a partir de datos del laser de barrido.
Se estiman las paredes del pasillo mediante regresion lineal por minimos cuadrados (least squares fitting)
y se usan para calcular los errores de seguimiento de trayectoria.

## Escenas CoppeliaSim

| Archivo | Descripcion |
|---------|-------------|
| `ros2_ws/seg_tray/scenes/corridor_scene.ttt` | Escena del pasillo con robot Pioneer P3DX |
| `ros2_ws/seg_tray/scenes/p2p_scene.ttt` | Escena punto a punto |

## Paquetes ROS2

| Paquete | Descripcion |
|---------|-------------|
| `ros2_ws/seg_tray` | Nodo de seguimiento de pasillo con percepcion por paredes (`corr_nav_wall`) |

## Ejecucion

```bash
# 1. Enlazar paquetes al workspace (desde la raiz del repo)
./scripts/symlink_pkg.sh robotica_movil/labmr_2_percepcion_entorno

# 2. Compilar
cd ~/colcon_ws && colcon build --symlink-install && source install/setup.bash

# 3. Lanzar
ros2 launch seg_tray corr_nav_wall_launch.py
```

## Notas

- El sensor laser publica en `/PioneerP3DX/laser_scan`
- La funcion `extractWall()` reemplaza a `averageRangeInWindow()` de la practica anterior
- Se eliminó el servicio de la practica anterior (no necesario aqui)
- Archivo de configuracion reutilizado de la practica anterior: `config/corr_params.yaml`
