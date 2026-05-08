# Entrega — Ampliación de Robótica · Bloque Robótica Móvil

**Autores:** Saúl Gutiérrez Rodríguez, Pablo Haro García, Mario Merino Prado
**Curso:** 2025/2026 · Máster — Ampliación de Robótica
**Entorno:** ROS 2 Humble (Docker) + CoppeliaSim · MATLAB
**Fecha de revisión:** 2026-04-29

Este documento resume, para cada práctica de robótica móvil, qué se entrega: código, memorias LaTeX/PDF, escenas de CoppeliaSim, enunciados originales, figuras y estado actual de cada bloque.

---

## Índice de prácticas

| Lab | Directorio código | Memoria LaTeX | Estado código | Estado memoria |
|---|---|---|---|---|
| Lab-MR 1-I | [practica_1-I_seguimiento_de_caminos_explicitos](robotica_movil/practica_1-I_seguimiento_de_caminos_explicitos/) | [lab1-I_caminos_explicitos](memorias/robotica_movil/lab1-I_caminos_explicitos/) | Funcional | PDF compilado (sin figuras) |
| Lab-MR 1-II | [practica_1-II_seguimiento_de_caminos_implicitos](robotica_movil/practica_1-II_seguimiento_de_caminos_implicitos/) | [lab1-II_caminos_implicitos](memorias/robotica_movil/lab1-II_caminos_implicitos/) | Funcional | PDF compilado + 2 figuras |
| Lab-MR 2 | [practica_2_percepcion_del_entorno](robotica_movil/practica_2_percepcion_del_entorno/) | [lab2_percepcion](memorias/robotica_movil/lab2_percepcion/) | Funcional | PDF compilado + 1 figura |
| Lab-MR 3 | [practica_3_evitar_obstaculos_mediante_campos_potenciales](robotica_movil/practica_3_evitar_obstaculos_mediante_campos_potenciales/) | [lab3_campos_potenciales](memorias/robotica_movil/lab3_campos_potenciales/) | Funcional (MATLAB) | Texto completo, figura pendiente |
| Lab-MR 4 | [practica_4_planificacion_de_caminos_i_dijkstra](robotica_movil/practica_4_planificacion_de_caminos_i_dijkstra/) | [lab4_dijkstra](memorias/robotica_movil/lab4_dijkstra/) | Implementación MATLAB | Texto completo, figura pendiente |
| Lab-MR 5 | [practica_5_planificacion_de_caminos_ii_a_estrella](robotica_movil/practica_5_planificacion_de_caminos_ii_a_estrella/) | [lab5_a_estrella](memorias/robotica_movil/lab5_a_estrella/) | `astar.m` reutilizado de P6 | Texto completo, figura pendiente |
| Lab-MR 6 | [practica_6_navegacion_completa](robotica_movil/practica_6_navegacion_completa/) | [lab6_navegacion_completa](memorias/robotica_movil/lab6_navegacion_completa/) | Completada (script integrado) | Texto completo, sin compilar PDF, sin figuras |

---

## Lab-MR 1-I · Seguimiento de caminos explícitos

**Objetivo.** Implementar navegación punto a punto (P2P) sobre un robot Pioneer P3DX simulado en CoppeliaSim, recorriendo una secuencia de waypoints con control proporcional sobre la odometría.

### Código fuente — `robotica_movil/practica_1-I_seguimiento_de_caminos_explicitos/`
- Paquete ROS 2: [seg_tray](robotica_movil/practica_1-I_seguimiento_de_caminos_explicitos/ros2_ws/seg_tray/)
  - Nodo: [src/nav_p2p.cpp](robotica_movil/practica_1-I_seguimiento_de_caminos_explicitos/ros2_ws/seg_tray/src/nav_p2p.cpp) (251 líneas) — implementa el `controlLoop()` con cinemática diferencial.
  - Launch: [launch/nav_p2p_launch.py](robotica_movil/practica_1-I_seguimiento_de_caminos_explicitos/ros2_ws/seg_tray/launch/nav_p2p_launch.py)
  - Parámetros: [config/nav_params.yaml](robotica_movil/practica_1-I_seguimiento_de_caminos_explicitos/ros2_ws/seg_tray/config/nav_params.yaml)
  - `CMakeLists.txt`, `package.xml`
- Escenas CoppeliaSim: [scenes/p2p_scene.ttt](robotica_movil/practica_1-I_seguimiento_de_caminos_explicitos/scenes/p2p_scene.ttt), [scenes/corridor_scene.ttt](robotica_movil/practica_1-I_seguimiento_de_caminos_explicitos/scenes/corridor_scene.ttt)
- Enunciado: [enunciado/AmpRob_LabMR_1_I_seg_tray_pto_a_pto.pdf](robotica_movil/practica_1-I_seguimiento_de_caminos_explicitos/enunciado/AmpRob_LabMR_1_I_seg_tray_pto_a_pto.pdf)
- Resumen de desarrollo: [desarrollo/resumen.txt](robotica_movil/practica_1-I_seguimiento_de_caminos_explicitos/desarrollo/resumen.txt)

### Lo implementado
- Cálculo del error de orientación `φ_e = atan2(Δy, Δx) − θ` con normalización a `[−π, π]`.
- Ley de control proporcional sobre curvatura: `γ = K · φ_e`.
- Cinemática diferencial: `ω_i = v(1−γ)/R`, `ω_d = v(1+γ)/R` (`2K=0.331 m`, `R=0.097518 m`).
- Limitación de velocidad angular a `±0.79 rad/s`. Velocidad lineal fija `v=1.2 m/s`.
- Detección de waypoint alcanzado por tolerancia y opción `loop_waypoints`.

### Memoria — `memorias/robotica_movil/lab1-I_caminos_explicitos/`
- [main.tex](memorias/robotica_movil/lab1-I_caminos_explicitos/main.tex) (238 líneas) — secciones de introducción, fundamentos, implementación y resultados.
- [main.pdf](memorias/robotica_movil/lab1-I_caminos_explicitos/main.pdf) (217 KB) — compilado.
- Figuras: ninguna en `figures/` (la memoria no incorpora capturas).

### Pendiente / observaciones
- Añadir capturas de la simulación en CoppeliaSim a la memoria.
- `PROGRESO.md` y `README.md` siguen con plantilla por rellenar.

---

## Lab-MR 1-II · Seguimiento de caminos implícitos

**Objetivo.** Seguimiento de pasillo (corridor following) usando láser de barrido y un controlador Pure Pursuit con detección anticipada de curvas a la derecha.

### Código fuente — `robotica_movil/practica_1-II_seguimiento_de_caminos_implicitos/`
- Paquete ROS 2: [seg_tray](robotica_movil/practica_1-II_seguimiento_de_caminos_implicitos/ros2_ws/seg_tray/)
  - Nodo: [src/corr_nav.cpp](robotica_movil/practica_1-II_seguimiento_de_caminos_implicitos/ros2_ws/seg_tray/src/corr_nav.cpp) (227 líneas)
  - Launch: [launch/corr_nav_launch.py](robotica_movil/practica_1-II_seguimiento_de_caminos_implicitos/ros2_ws/seg_tray/launch/corr_nav_launch.py)
  - Parámetros: [config/nav_params.yaml](robotica_movil/practica_1-II_seguimiento_de_caminos_implicitos/ros2_ws/seg_tray/config/nav_params.yaml), [config/corr_params.yaml](robotica_movil/practica_1-II_seguimiento_de_caminos_implicitos/ros2_ws/seg_tray/config/corr_params.yaml)
- Escenas CoppeliaSim: [scenes/corridor_scene.ttt](robotica_movil/practica_1-II_seguimiento_de_caminos_implicitos/scenes/corridor_scene.ttt), [scenes/p2p_scene.ttt](robotica_movil/practica_1-II_seguimiento_de_caminos_implicitos/ros2_ws/seg_tray/scenes/p2p_scene.ttt)
- Enunciado: [enunciado/AmpRob_LabMR_1_II_seg_pasillo.pdf](robotica_movil/practica_1-II_seguimiento_de_caminos_implicitos/enunciado/AmpRob_LabMR_1_II_seg_pasillo.pdf)
- Resumen de desarrollo: [desarrollo/resumen.txt](robotica_movil/practica_1-II_seguimiento_de_caminos_implicitos/desarrollo/resumen.txt)

### Lo implementado
- `averageRangeInWindow()` para promediar lecturas láser por ventanas angulares (±90°, 0°, −45°).
- Estimación del signo de orientación `θ` comparando rayos a ±15° de cada pared.
- `θ = acos(W / (d_left + d_right)) · signo`.
- Pure Pursuit en tramos rectos: `y_L = e_lat·cos(θ) − L·sin(θ)`, `γ = 2·y_L / L²`.
- Detección anticipada de curvas a la derecha mediante el rayo a −45° → reduce velocidad a `v/8` y aplica `−ω_max`.
- Parámetros: `corridor_width = 4.2 m`, `look_ahead_distance = 4.0 m`, `v_max = 1.0 m/s`.

### Memoria — `memorias/robotica_movil/lab1-II_caminos_implicitos/`
- [main.tex](memorias/robotica_movil/lab1-II_caminos_implicitos/main.tex) (262 líneas).
- [main.pdf](memorias/robotica_movil/lab1-II_caminos_implicitos/main.pdf) (615 KB) — compilado.
- Figuras:
  - [figures/dibujo_rayos.png](memorias/robotica_movil/lab1-II_caminos_implicitos/figures/dibujo_rayos.png) — esquema de las ventanas angulares del láser.
  - [figures/curvas.png](memorias/robotica_movil/lab1-II_caminos_implicitos/figures/curvas.png) — comportamiento ante curvas.

### Pendiente / observaciones
- `PROGRESO.md` y `README.md` siguen con plantilla por rellenar.

---

## Lab-MR 2 · Percepción del entorno

**Objetivo.** Sustituir el promediado de rayos por una estimación de paredes mediante regresión lineal por mínimos cuadrados, y reescribir el controlador Pure Pursuit usando esos modelos de pared.

### Código fuente — `robotica_movil/practica_2_percepcion_del_entorno/`
- Paquete ROS 2: [seg_tray](robotica_movil/practica_2_percepcion_del_entorno/ros2_ws/seg_tray/)
  - Nodo nuevo: [src/corr_nav_wall.cpp](robotica_movil/practica_2_percepcion_del_entorno/ros2_ws/seg_tray/src/corr_nav_wall.cpp) (215 líneas)
  - Nodo de la práctica anterior conservado: [src/corr_nav.cpp](robotica_movil/practica_2_percepcion_del_entorno/ros2_ws/seg_tray/src/corr_nav.cpp)
  - Launches: [launch/corr_nav_wall_launch.py](robotica_movil/practica_2_percepcion_del_entorno/ros2_ws/seg_tray/launch/corr_nav_wall_launch.py), [launch/corr_nav_launch.py](robotica_movil/practica_2_percepcion_del_entorno/ros2_ws/seg_tray/launch/corr_nav_launch.py)
  - Parámetros: [config/corr_params.yaml](robotica_movil/practica_2_percepcion_del_entorno/ros2_ws/seg_tray/config/corr_params.yaml), [config/nav_params.yaml](robotica_movil/practica_2_percepcion_del_entorno/ros2_ws/seg_tray/config/nav_params.yaml)
- Escenas: [scenes/corridor_scene.ttt](robotica_movil/practica_2_percepcion_del_entorno/ros2_ws/seg_tray/scenes/corridor_scene.ttt), [scenes/p2p_scene.ttt](robotica_movil/practica_2_percepcion_del_entorno/ros2_ws/seg_tray/scenes/p2p_scene.ttt)
- Enunciado: [enunciado/AmpRob_LabMR_2_percepcion.pdf](robotica_movil/practica_2_percepcion_del_entorno/enunciado/AmpRob_LabMR_2_percepcion.pdf)
- Resumen de desarrollo: [desarrollo/resumen.txt](robotica_movil/practica_2_percepcion_del_entorno/desarrollo/resumen.txt)

### Lo implementado
- `extractWall(msg, angle_min, angle_max)`: convierte rayos `(r, θ)` a `(x, y)`, filtra inválidos y ajusta `y = m·x + b` por mínimos cuadrados ordinarios.
- Pared izquierda en `[60°, 120°]`, derecha en `[−120°, −60°]`, frontal media en `[−15°, 15°]`.
- Pure Pursuit con paredes: `y_goal = (m_L·L + b_L + m_R·L + b_R)/2`, `γ = 2·y_goal / L²`.
- Guard de seguridad: si una pared no se detecta (`b = ∞`), el robot para.
- Velocidad lineal al 50 % del máximo (0.5 m/s) y `ω` saturada a `±0.79 rad/s`.

### Memoria — `memorias/robotica_movil/lab2_percepcion/`
- [main.tex](memorias/robotica_movil/lab2_percepcion/main.tex) (313 líneas).
- [main.pdf](memorias/robotica_movil/lab2_percepcion/main.pdf) (1.0 MB) — compilado.
- Figura: [figures/coppelia_resultado.png](memorias/robotica_movil/lab2_percepcion/figures/coppelia_resultado.png) — captura del resultado en CoppeliaSim.

### Pendiente / observaciones
- `PROGRESO.md` con plantilla por rellenar.
- `README.md` ya completo.

---

## Lab-MR 3 · Evitar obstáculos por campos potenciales

**Objetivo.** Navegación reactiva con campos potenciales artificiales en MATLAB, sobre mapa de ocupación binario y láser simulado por `rayIntersection`.

### Código fuente — `robotica_movil/practica_3_evitar_obstaculos_mediante_campos_potenciales/`
- Implementación MATLAB: [matlab/plantilla_campos_potenciales.m](robotica_movil/practica_3_evitar_obstaculos_mediante_campos_potenciales/matlab/plantilla_campos_potenciales.m) (103 líneas).
- Mapa: [matlab/mapa1_150.png](robotica_movil/practica_3_evitar_obstaculos_mediante_campos_potenciales/matlab/mapa1_150.png).
- Enunciado: [enunciado/Práctica4_2024-2025.pdf](robotica_movil/practica_3_evitar_obstaculos_mediante_campos_potenciales/enunciado/Práctica4_2024-2025.pdf).
- Resumen: [desarrollo/resumen.txt](robotica_movil/practica_3_evitar_obstaculos_mediante_campos_potenciales/desarrollo/resumen.txt).

### Lo implementado
- `SimulaLidar` evaluado en cada iteración; filtrado de NaN y de obstáculos fuera de rango `D`.
- `F_atr = α · (q_dest − q) / ||q_dest − q||`.
- `F_rep_i = β · (1/d_i − 1/D) · (1/d_i²) · (q − q_obs_i) / ||q − q_obs_i||`.
- Combinación: `θ = atan2(F_res_y, F_res_x)`, `q_new = q + v·[cosθ, sinθ]`.
- Parámetros base: `v=0.4`, `D=1.5`, `α=1`, `β=100`. Detección de mínimo local por límite de 1000 iteraciones.

### Memoria — `memorias/robotica_movil/lab3_campos_potenciales/`
- [main.tex](memorias/robotica_movil/lab3_campos_potenciales/main.tex) — **completa** (introducción, fundamentos, diseño, resultados, discusión, conclusiones).
- Figura pendiente: `\pendiente{...}` dentro del entorno `figure` en sección de resultados.

### Pendiente / observaciones
- Recompilar (`make lab3`) y añadir captura de la trayectoria sobre `mapa1_150.png`.

---

## Lab-MR 4 · Planificación de caminos I (Dijkstra)

**Objetivo.** Planificación global por Dijkstra sobre un grafo topológico almacenado en `grafos.mat`.

### Código fuente — `robotica_movil/practica_4_planificacion_de_caminos_i_dijkstra/`
- Implementación MATLAB: [matlab/dijkstra.m](robotica_movil/practica_4_planificacion_de_caminos_i_dijkstra/matlab/dijkstra.m) (122 líneas) — acepta directamente la `struct` devuelta por `load(...)`.
- Datos: [matlab/grafos.mat](robotica_movil/practica_4_planificacion_de_caminos_i_dijkstra/matlab/grafos.mat).
- Enunciado: [enunciado/Practica5_2024-25.pdf](robotica_movil/practica_4_planificacion_de_caminos_i_dijkstra/enunciado/Practica5_2024-25.pdf).
- Borrador LaTeX suelto: [desarrollo/main.tex](robotica_movil/practica_4_planificacion_de_caminos_i_dijkstra/desarrollo/main.tex) + [desarrollo/logo_uma.png](robotica_movil/practica_4_planificacion_de_caminos_i_dijkstra/desarrollo/logo_uma.png) (no integrado en `memorias/`).

### Memoria — `memorias/robotica_movil/lab4_dijkstra/`
- [main.tex](memorias/robotica_movil/lab4_dijkstra/main.tex) — **completa** (introducción, fundamentos, diseño, resultados, discusión, conclusiones).
- Figura pendiente: `\pendiente{...}` con la captura del grafo y la ruta óptima.

### Pendiente / observaciones
- Compilar (`make lab4`) tras añadir la figura del grafo y la ruta resultante.

---

## Lab-MR 5 · Planificación de caminos II (A*)

**Objetivo.** A* con heurística euclídea consistente sobre el mismo grafo topológico, mediante construcción de una matriz de costes compatible con la métrica.

### Código fuente — `robotica_movil/practica_5_planificacion_de_caminos_ii_a_estrella/`
- Carpeta MATLAB vacía (`.gitkeep`). La implementación funcional de A* vive en la práctica 6: [robotica_movil/practica_6_navegacion_completa/matlab/astar.m](robotica_movil/practica_6_navegacion_completa/matlab/astar.m) (108 líneas).
- Enunciado: [enunciado/Práctica6_2024-2025.pdf](robotica_movil/practica_5_planificacion_de_caminos_ii_a_estrella/enunciado/Práctica6_2024-2025.pdf).
- Resumen: [desarrollo/resumen.txt](robotica_movil/practica_5_planificacion_de_caminos_ii_a_estrella/desarrollo/resumen.txt).

### Memoria — `memorias/robotica_movil/lab5_a_estrella/`
- [main.tex](memorias/robotica_movil/lab5_a_estrella/main.tex) — **completa** (fundamentos de A*, admisibilidad/consistencia, construcción de la matriz euclídea, comparativa con Dijkstra).
- Figura pendiente: `\pendiente{...}` con la comparativa de nodos expandidos por Dijkstra y A*.

### Pendiente / observaciones
- Copiar `astar.m` desde la práctica 6 a `practica_5_*/matlab/` (o referenciarlo explícitamente) para entregar el código junto a la memoria.
- Compilar (`make lab5`) tras añadir la figura comparativa.

---

## Lab-MR 6 · Navegación completa (Dijkstra/A* + campos potenciales)

**Objetivo.** Integrar planificación global sobre grafo (Dijkstra o A*) con navegación local reactiva por campos potenciales, incluyendo mejoras anti-mínimos locales.

### Código fuente — `robotica_movil/practica_6_navegacion_completa/`
- Script principal: [matlab/navegacion_autonoma_p7.m](robotica_movil/practica_6_navegacion_completa/matlab/navegacion_autonoma_p7.m) (393 líneas).
- Planificadores: [matlab/dijkstra.m](robotica_movil/practica_6_navegacion_completa/matlab/dijkstra.m) (122) y [matlab/astar.m](robotica_movil/practica_6_navegacion_completa/matlab/astar.m) (108).
- Datos: [matlab/datos/mapa2.pgm](robotica_movil/practica_6_navegacion_completa/matlab/datos/mapa2.pgm), [matlab/datos/mapa2.m](robotica_movil/practica_6_navegacion_completa/matlab/datos/mapa2.m), [matlab/README_DATOS.md](robotica_movil/practica_6_navegacion_completa/matlab/README_DATOS.md).
- Enunciado: [enunciado/Practica7_2024-2025.pdf](robotica_movil/practica_6_navegacion_completa/enunciado/Practica7_2024-2025.pdf).

### Lo implementado
- Pregunta interactiva al usuario: planificador (Dijkstra/A*) y nodos origen/destino.
- A* con matriz de costes euclídea (consistencia): `C^eucl_ij = ||p_i − p_j||₂` y `h(i) = ||p_i − p_dest||₂`.
- Navegación local reactiva con `F_res = F_att + F_rep + F_tan` (campo tangencial añadido para evitar mínimos locales).
- Detección de estancamiento por ventana temporal y maniobra de escape hacia pose libre con mayor despeje.
- Manejo del caso conflictivo del enunciado (zona entre nodos 24–32).

### Memoria — `memorias/robotica_movil/lab6_navegacion_completa/`
- [main.tex](memorias/robotica_movil/lab6_navegacion_completa/main.tex) (126 líneas) — texto completo (introducción, implementación, resultados, conclusiones).
- **No hay `main.pdf` compilado todavía**.
- `figures/` solo contiene `.gitkeep` — sin figuras.

### Pendiente / observaciones
- Compilar la memoria (`make lab6` desde `memorias/`).
- Añadir capturas de las trayectorias resultantes (Dijkstra vs A*, y zona 24–32 antes/después de la mejora).
- `PROGRESO.md` ya marca **estado COMPLETADA** (sesión 2026-04-15).

---

## Vídeos y material adicional

No se han localizado archivos `.mp4`, `.avi` ni `.gif` en el árbol del proyecto; las prácticas se documentan exclusivamente con texto, código y capturas estáticas (PNG).

## Compilación de las memorias

Desde la raíz `colcon_ws/src/ampliacion_robotica/memorias/`:

```bash
make all          # las 7 memorias
make lab1-I       # Lab-MR 1-I
make lab1-II      # Lab-MR 1-II
make lab2         # Lab-MR 2
make lab3         # Lab-MR 3
make lab4         # Lab-MR 4
make lab5         # Lab-MR 5
make lab6         # Lab-MR 6
make upload       # sube los PDFs a Google Drive (rclone)
```

## Resumen de estado para la entrega

**Listas para entregar (código + memoria PDF compilada con figuras):** Lab-MR 1-I, Lab-MR 1-II, Lab-MR 2.

**Memoria redactada, falta compilar y añadir figura marcada como `\pendiente{}`:**
- Lab-MR 3, Lab-MR 4, Lab-MR 5, Lab-MR 6.

**Acción restante para Lab-MR 5 (código):** copiar `astar.m` desde `practica_6_navegacion_completa/matlab/` a `practica_5_planificacion_de_caminos_ii_a_estrella/matlab/` para que el código quede junto a su memoria.
