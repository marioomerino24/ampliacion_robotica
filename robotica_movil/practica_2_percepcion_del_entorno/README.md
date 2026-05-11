# Práctica 2: Percepción del entorno

**Tecnología:** ROS 2 Humble / C++ / CoppeliaSim  
**Paquete ROS 2:** `seg_tray` — nodo `corr_nav_wall`

## Objetivo

Extraer información geométrica del entorno a partir del LiDAR de barrido. Se estiman las paredes del pasillo mediante regresión lineal por mínimos cuadrados y se usan los parámetros de la recta ajustada como señales de error para el controlador de seguimiento.

## Estructura

```
practica_2_percepcion_del_entorno/
├── ros2_ws/seg_tray/
│   ├── src/corr_nav_wall.cpp         # Nodo principal con estimación de paredes
│   ├── src/corr_nav.cpp              # Nodo auxiliar (heredado de práctica 1-II)
│   ├── config/corr_params.yaml       # Parámetros del controlador
│   ├── launch/corr_nav_wall_launch.py
│   └── scenes/corridor_scene.ttt
└── enunciado/                        # Enunciado oficial de la práctica
```

## Vídeo de demostración

[Ver en Drive](https://drive.google.com/open?id=1FnFhbGMeaFnEXlVtZfJK5_TjgRE5hLpe)

## Aspectos clave de la implementación

- `extractWall()` sustituye a `averageRangeInWindow()` de la práctica anterior.
- El LiDAR publica en `/PioneerP3DX/laser_scan`.
- El error lateral se calcula a partir de la distancia del robot a la recta ajustada.

## Ejecución

```bash
# 1. Compilar el workspace
cd ~/colcon_ws
colcon build --symlink-install
source install/setup.bash

# 2. Abrir la escena en CoppeliaSim
#    scenes/corridor_scene.ttt

# 3. Lanzar el nodo
ros2 launch seg_tray corr_nav_wall_launch.py
```
