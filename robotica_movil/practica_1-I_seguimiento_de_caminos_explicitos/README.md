# Práctica 1-I: Seguimiento de caminos explícitos

**Tecnología:** ROS 2 Humble / C++ / CoppeliaSim  
**Paquete ROS 2:** `seg_tray` — nodo `nav_p2p`

## Objetivo

Implementar un controlador de navegación punto a punto para un robot Pioneer P3DX. El robot recorre una secuencia de waypoints predefinidos usando control proporcional sobre el ángulo de orientación.

## Estructura

```
practica_1-I_seguimiento_de_caminos_explicitos/
├── ros2_ws/seg_tray/
│   ├── src/nav_p2p.cpp          # Nodo principal de navegación
│   ├── config/nav_params.yaml   # Waypoints y parámetros del controlador
│   ├── launch/nav_p2p_launch.py # Launch file
│   └── scenes/p2p_scene.ttt     # Escena CoppeliaSim
└── enunciado/                   # Enunciado oficial de la práctica
```

## Parámetros principales (`nav_params.yaml`)

| Parámetro | Valor | Descripción |
|-----------|-------|-------------|
| `control_gain` | 1.0 | Ganancia proporcional del controlador angular |
| `max_linear_speed` | 1.2 m/s | Velocidad lineal máxima |
| `num_waypoints` | 7 | Número de waypoints en la trayectoria |

## Vídeos de demostración

| Ganancia | Enlace |
|----------|--------|
| k = 0.4 | [Ver en Drive](https://drive.google.com/open?id=1jx27vzaXh6YFGnaX7vWsmnyP7AP53o-K) |
| k = 1.0 | [Ver en Drive](https://drive.google.com/open?id=1B6tw3tVGNyEisCtlUp-mjeOcuXBJ7G0e) |
| k = 3.0 | [Ver en Drive](https://drive.google.com/open?id=1_hRtz4IdVE7N9oPTdO6M9ZgvfZ3rZJ2l) |

## Ejecución

```bash
# 1. Compilar el workspace
cd ~/colcon_ws
colcon build --symlink-install
source install/setup.bash

# 2. Abrir la escena en CoppeliaSim
#    scenes/p2p_scene.ttt

# 3. Lanzar el nodo
ros2 launch seg_tray nav_p2p_launch.py
```
