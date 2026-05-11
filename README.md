# Ampliación de Robótica — Prácticas

**Asignatura:** Ampliación de Robótica  
**Titulación:** Ingeniería Informática — Universidad de Málaga  
**Autores:** Saúl Gutiérrez Rodríguez, Pablo Haro García, Mario Merino Prado  
**Entorno:** ROS 2 Humble + CoppeliaSim (Docker) / MATLAB

---

## Contenido

Este repositorio recoge el código fuente y la memoria de las prácticas de **Robótica Móvil** de la asignatura.

```
ampliacion_robotica/
├── robotica_movil/          # Código fuente de las 6 prácticas
│   ├── practica_1-I_*       # Seguimiento de caminos explícitos  (ROS 2)
│   ├── practica_1-II_*      # Seguimiento de caminos implícitos  (ROS 2)
│   ├── practica_2_*         # Percepción del entorno             (ROS 2)
│   ├── practica_3_*         # Campos potenciales                 (MATLAB)
│   ├── practica_4_*         # Planificación Dijkstra             (MATLAB)
│   ├── practica_5_*         # Planificación A*                   (MATLAB)
│   └── practica_6_*         # Navegación completa                (MATLAB)
└── memorias/
    └── robotica_movil/
        └── memoria_robotica_movil/   # Memoria conjunta (LaTeX + PDF)
```

---

## Memoria

La memoria conjunta de todas las prácticas está disponible en:

[`memorias/robotica_movil/memoria_robotica_movil/main.pdf`](memorias/robotica_movil/memoria_robotica_movil/main.pdf)

---

## Prácticas

| Práctica | Título | Tecnología | Vídeo |
|----------|--------|-----------|-------|
| 1-I | [Seguimiento de caminos explícitos](robotica_movil/practica_1-I_seguimiento_de_caminos_explicitos/) | ROS 2 / C++ | [k=0.4](https://drive.google.com/open?id=1jx27vzaXh6YFGnaX7vWsmnyP7AP53o-K) · [k=1](https://drive.google.com/open?id=1B6tw3tVGNyEisCtlUp-mjeOcuXBJ7G0e) · [k=3](https://drive.google.com/open?id=1_hRtz4IdVE7N9oPTdO6M9ZgvfZ3rZJ2l) |
| 1-II | [Seguimiento de caminos implícitos](robotica_movil/practica_1-II_seguimiento_de_caminos_implicitos/) | ROS 2 / C++ | [Ver](https://drive.google.com/open?id=1I6tOLcURG61m_-ohzUyiiBDkwep3uvLk) |
| 2 | [Percepción del entorno](robotica_movil/practica_2_percepcion_del_entorno/) | ROS 2 / C++ | [Ver](https://drive.google.com/open?id=1FnFhbGMeaFnEXlVtZfJK5_TjgRE5hLpe) |
| 3 | [Campos potenciales](robotica_movil/practica_3_evitar_obstaculos_mediante_campos_potenciales/) | MATLAB | — |
| 4 | [Planificación de caminos I — Dijkstra](robotica_movil/practica_4_planificacion_de_caminos_i_dijkstra/) | MATLAB | — |
| 5 | [Planificación de caminos II — A\*](robotica_movil/practica_5_planificacion_de_caminos_ii_a_estrella/) | MATLAB | — |
| 6 | [Navegación completa](robotica_movil/practica_6_navegacion_completa/) | MATLAB | — |

---

## Ejecución rápida (prácticas ROS 2)

```bash
# 1. Compilar el workspace
cd ~/colcon_ws
colcon build --symlink-install
source install/setup.bash

# 2. Lanzar la práctica deseada
ros2 launch seg_tray nav_p2p_launch.py       # Práctica 1-I
ros2 launch seg_tray corr_nav_launch.py      # Práctica 1-II
ros2 launch seg_tray corr_nav_wall_launch.py # Práctica 2
```
