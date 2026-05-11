# Práctica 1-II: Seguimiento de caminos implícitos

**Tecnología:** ROS 2 Humble / C++ / CoppeliaSim  
**Paquete ROS 2:** `seg_tray` — nodo `corr_nav`

## Objetivo

Implementar navegación reactiva en pasillo mediante Pure Pursuit. El robot estima su posición en el corredor a partir de un LiDAR de barrido y se dirige al punto de look-ahead sobre la línea central, sin necesidad de waypoints explícitos.

## Estructura

```
practica_1-II_seguimiento_de_caminos_implicitos/
├── ros2_ws/seg_tray/
│   ├── src/corr_nav.cpp              # Nodo principal de seguimiento de pasillo
│   ├── config/corr_params.yaml       # Parámetros del controlador
│   ├── launch/corr_nav_launch.py     # Launch file
│   └── scenes/corridor_scene.ttt     # Escena CoppeliaSim (pasillo)
└── enunciado/                        # Enunciado oficial de la práctica
```

## Parámetros principales (`corr_params.yaml`)

| Parámetro | Valor | Descripción |
|-----------|-------|-------------|
| `corridor_width` | 4.2 m | Anchura del pasillo |
| `look_ahead_distance` | 4.0 m | Distancia de anticipación (Pure Pursuit) |
| `max_linear_speed` | 1.0 m/s | Velocidad lineal máxima |

## Vídeo de demostración

[Ver en Drive](https://drive.google.com/open?id=1I6tOLcURG61m_-ohzUyiiBDkwep3uvLk)

## Ejecución

```bash
# 1. Compilar el workspace
cd ~/colcon_ws
colcon build --symlink-install
source install/setup.bash

# 2. Abrir la escena en CoppeliaSim
#    scenes/corridor_scene.ttt

# 3. Lanzar el nodo
ros2 launch seg_tray corr_nav_launch.py
```
