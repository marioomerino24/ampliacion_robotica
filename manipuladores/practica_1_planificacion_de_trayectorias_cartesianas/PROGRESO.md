# Progreso - Practica 1: Planificacion de trayectorias cartesianas

## Punto de partida

- Material proporcionado: HTML local del Lab 1 y referencia al repo `cartesian_trajectory_planning`.
- Objetivo principal: implementar interpolacion cartesiana y suavizado de trayectoria entre tres poses.
- Entregables: enunciado estructurado, guia rapida de la practica y base para el desarrollo.

## Sesiones

### 2026-04-22
- **Hecho:**
  - Se ha extraido el contenido relevante de la primera practica de manipuladores.
  - Se ha creado una carpeta propia con `README.md`, `PROGRESO.md`, `desarrollo/resumen.txt` y `enunciado/enunciado.txt`.
  - Se han identificado las funciones, comandos, matrices y resultados esperados de la practica.
  - Se ha creado `ros2_ws/` dentro de la propia practica.
  - Se ha clonado `cartesian_trajectory_planning` dentro de `ros2_ws/cartesian_trajectory_planning`.
  - Se han instalado las dependencias necesarias en el contenedor ROS 2 y se ha compilado el paquete.
  - Se ha enlazado el paquete al workspace general mediante `./scripts/symlink_pkg.sh`.
- **Estado actual:**
  - Entorno y documentacion preparados.
  - Desarrollo de codigo aun pendiente.
- **Siguiente paso:**
  - Empezar por `reference_generator/send_trajectory.cpp` implementando `PoseInterpolation(...)`.

## Estado: EN CURSO
