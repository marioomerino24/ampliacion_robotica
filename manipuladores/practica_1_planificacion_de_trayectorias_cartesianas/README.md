# Practica 1: Planificacion de trayectorias cartesianas

## Objetivo

Implementar una interpolacion cartesiana para un manipulador de 6 GDL usando ROS 2 Humble, KDL y quaterniones, primero con interpolacion lineal + slerp y despues con una trayectoria suavizada tipo Taylor entre tres poses.

## Material base

| Archivo | Descripcion |
|---------|-------------|
| `enunciado/enunciado.txt` | Enunciado completo extraido y reorganizado desde el HTML original. |
| `desarrollo/resumen.txt` | Resumen rapido de que pide la practica y que hay que tocar. |
| `../Lab 1_ Cartesian trajectory planning - Advanced Robotics Course.html` | Fuente original guardada en local. |

## Paquete ROS2

| Recurso | Descripcion |
|---------|-------------|
| `ros2_ws/cartesian_trajectory_planning` | Paquete base de la practica ya colocado dentro de esta carpeta. |
| `ros2_ws/cartesian_trajectory_planning/config/poses.yaml` | Define `pose0`, `pose1` y `pose2`. |
| `ros2_ws/cartesian_trajectory_planning/reference_generator/send_trajectory.cpp` | Archivo principal a completar en la practica. |
| `ros2_ws/cartesian_trajectory_planning/experiment_data/` | Carpeta donde se guardan los CSV y desde la que se pueden representar los resultados. |

## Ejecucion

```bash
# 1. Asegurar que el paquete de esta practica esta enlazado al workspace
cd ~/colcon_ws/src/ampliacion_robotica
./scripts/symlink_pkg.sh manipuladores/practica_1_planificacion_de_trayectorias_cartesianas

# 2. Entrar al contenedor ROS 2
cd ~/ros_workspaces/ros2_humble
docker compose exec ros2 bash

# 3. Compilar el workspace dentro del contenedor
cd ~/colcon_ws
colcon build --symlink-install
source install/setup.bash

# 4. Lanzar el controlador del robot
ros2 launch cartesian_trajectory_planning r6bot_controller.launch.py

# 5. En otra terminal, lanzar una demo
ros2 launch cartesian_trajectory_planning send_linear_trajectory.launch.py

# 6. Cuando ya este implementada la practica, ejecutar el generador propio
# asociado a `reference_generator/send_trajectory.cpp`
```

## Notas

- La fuente original del enunciado estaba en HTML, no en PDF.
- El HTML referencia videos de instalacion y de resultados, pero aqui solo se han tenido en cuenta como material asociado.
- Los dos bloques a implementar son `PoseInterpolation(...)` y `ComputeNextCartesianPose(...)`.
- La practica usa un controlador articular por posicion y resuelve la IK con KDL.
- El paquete ya esta preparado dentro de `ros2_ws/` de esta practica y compilado en el contenedor ROS 2.
