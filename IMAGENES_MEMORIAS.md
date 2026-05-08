# Inventario de imágenes — Memorias de Robótica Móvil

Auditoría del estado de las figuras en cada memoria, con **verificación visual** de los archivos PNG existentes para distinguir capturas reales del programa frente a esquemas didácticos.

**Convenciones:**
- 📷 Captura real del programa (CoppeliaSim / MATLAB).
- 🖼️ Esquema o dibujo (no captura).
- ⚠️ Hueco marcado con `\pendiente{...}` — falta la imagen real.
- ❌ Sin figura ni marcador (no tras esta revisión: ya añadidos).

---

## Resumen rápido

| Lab | Capturas reales | Esquemas | Pendientes (`\pendiente{}`) |
|---|---|---|---|
| MR1.1 | 0 | 0 | 1 (`fig:p2p_recorrido`) ⚠️ |
| MR1.2 | 1 (`curvas.png`) 📷 | 1 (`dibujo_rayos.png`) 🖼️ | 0 ✅ |
| MR2 | 1 (`coppelia_resultado.png`) 📷 | 1 (TikZ embebido) 🖼️ | 0 ✅ |
| MR3 | 0 | 0 | 1 (`fig:trayectoria_p3`) ⚠️ |
| MR4 | 0 | 0 | 1 (`fig:dijkstra_ruta`) ⚠️ |
| MR5 | 0 | 0 | 1 (`fig:astar_vs_dijkstra`) ⚠️ |
| MR6 | 0 | 0 | 2 (`fig:nav_caso_base`, `fig:nav_zona_24_32`) ⚠️ |

**Capturas reales del programa confirmadas: 2** (MR1.2 y MR2).
**Imágenes pendientes de generar: 6** (MR1.1, MR3, MR4, MR5, MR6×2).

---

## Lab-MR 1-I · Caminos explícitos (P2P)

**Carpeta:** [memorias/robotica_movil/lab1-I_caminos_explicitos/figures/](memorias/robotica_movil/lab1-I_caminos_explicitos/figures/) · **vacía**.

### Estado actual
- ⚠️ Hueco `\pendiente{}` añadido en sección **Resultados experimentales · Análisis cualitativo** de [main.tex](memorias/robotica_movil/lab1-I_caminos_explicitos/main.tex), etiqueta `fig:p2p_recorrido`.

### Lo que falta — `fig:p2p_recorrido`
**Qué debe verse:**
- Captura cenital de la escena `p2p_scene.ttt` en CoppeliaSim.
- El robot Pioneer P3DX visible en su posición.
- La traza acumulada del recorrido cubriendo el perímetro rectangular completo: `(0,0) → (10,0) → (10,10) → (-10,10) → (-10,-10) → (10,-10) → (0,0)`.
- Idealmente con `loop_waypoints=true` para que la trayectoria se cierre y se vea la repetibilidad.

**Cómo obtenerla:** lanzar `ros2 launch seg_tray nav_p2p_launch.py` con CoppeliaSim abierto en la escena P2P, dejar correr una vuelta completa y capturar la vista cenital.

---

## Lab-MR 1-II · Caminos implícitos (corridor following)

**Carpeta:** [memorias/robotica_movil/lab1-II_caminos_implicitos/figures/](memorias/robotica_movil/lab1-II_caminos_implicitos/figures/).

### Estado actual ✅
- 🖼️ [`dibujo_rayos.png`](memorias/robotica_movil/lab1-II_caminos_implicitos/figures/dibujo_rayos.png) (37 KB) — **esquema didáctico**: diagrama vectorial con el robot, paredes, distancias `d_left/d_right/d_front/d_right_ahead` y leyenda de los haces (frontal 0°, laterales ±90°, anticipación −45°). Referenciado como `fig:angulo`.
- 📷 [`curvas.png`](memorias/robotica_movil/lab1-II_caminos_implicitos/figures/curvas.png) (260 KB) — **captura real de CoppeliaSim**: vista del Pioneer (rojo) sobre suelo cuadriculado, paredes de ladrillo y traza roja del recorrido en tramo recto + curva. Referenciada como `fig:trayectoria`.

Memoria completa, sin huecos.

---

## Lab-MR 2 · Percepción del entorno

**Carpeta:** [memorias/robotica_movil/lab2_percepcion/figures/](memorias/robotica_movil/lab2_percepcion/figures/).

### Estado actual ✅
- 🖼️ Esquema TikZ embebido en `main.tex` (líneas 99–160), etiqueta `fig:regresion_pp`. Puntos láser, rectas ajustadas por mínimos cuadrados y punto objetivo de Pure Pursuit.
- 📷 [`coppelia_resultado.png`](memorias/robotica_movil/lab2_percepcion/figures/coppelia_resultado.png) (546 KB) — **captura real de CoppeliaSim**: vista cenital del pasillo de ladrillo con el Pioneer rojo y la traza roja completa del recorrido. Referenciada como `fig:coppelia`.

Memoria completa, sin huecos.

---

## Lab-MR 3 · Campos potenciales

**Carpeta:** [memorias/robotica_movil/lab3_campos_potenciales/figures/](memorias/robotica_movil/lab3_campos_potenciales/figures/) · **vacía**.

### Estado actual
- ⚠️ Hueco `\pendiente{}` en línea 160 de [main.tex](memorias/robotica_movil/lab3_campos_potenciales/main.tex), sección **Resultados experimentales · Escenario de prueba** (etiqueta `fig:trayectoria_p3`).

### Lo que falta — `fig:trayectoria_p3`
**Qué debe verse:**
- Mapa de ocupación `mapa1_150.png` cargado de fondo (`show(mapa)`).
- **Marcador verde** en el punto inicial (`origen`).
- **Marcador rojo** en el punto final (`destino`).
- **Traza roja** completa de la trayectoria recorrida.
- Idealmente, capturar **dos casos**: uno con destino alcanzado y otro con mínimo local detectado (1000 iteraciones).

**Cómo obtenerla:**
1. MATLAB en `practica_3_evitar_obstaculos_mediante_campos_potenciales/matlab/`.
2. Ejecutar `plantilla_campos_potenciales.m`.
3. Clic en el mapa para origen y destino.
4. Al final del bucle: `exportgraphics(gcf, 'trayectoria_p3.png', 'Resolution', 200)`.
5. Mover a `memorias/robotica_movil/lab3_campos_potenciales/figures/`.

---

## Lab-MR 4 · Dijkstra

**Carpeta:** [memorias/robotica_movil/lab4_dijkstra/figures/](memorias/robotica_movil/lab4_dijkstra/figures/) · **vacía**.

### Estado actual
- ⚠️ Hueco `\pendiente{}` en línea 124 de [main.tex](memorias/robotica_movil/lab4_dijkstra/main.tex), sección **Resultados experimentales · Ejemplo de ejecución** (etiqueta `fig:dijkstra_ruta`).

### Lo que falta — `fig:dijkstra_ruta`
**Qué debe verse:**
- Representación del **grafo `J`** de `grafos.mat`: nodos numerados y aristas con su peso.
- **Ruta óptima resaltada** (por ejemplo nodo 1 → nodo 7) en color contrastado y grosor mayor.
- Coste total acumulado en el título.

**Cómo obtenerla (MATLAB):**
```matlab
data = load('grafos.mat');  J = data.J;
[coste, ruta] = dijkstra(data, 1, 7);
G = digraph(J);
figure;
p = plot(G, 'Layout','force', 'EdgeLabel', G.Edges.Weight);
highlight(p, ruta, 'EdgeColor','r', 'LineWidth', 2.5, 'NodeColor','r');
title(sprintf('Ruta óptima 1 → 7 (coste = %.2f)', coste));
exportgraphics(gcf, 'dijkstra_ruta.png', 'Resolution', 200);
```
Guardar en `memorias/robotica_movil/lab4_dijkstra/figures/dijkstra_ruta.png`.

---

## Lab-MR 5 · A*

**Carpeta:** [memorias/robotica_movil/lab5_a_estrella/figures/](memorias/robotica_movil/lab5_a_estrella/figures/) · **vacía**.

### Estado actual
- ⚠️ Hueco `\pendiente{}` en línea 133 de [main.tex](memorias/robotica_movil/lab5_a_estrella/main.tex), sección **Resultados experimentales · Comparativa A* vs. Dijkstra** (etiqueta `fig:astar_vs_dijkstra`).

### Lo que falta — `fig:astar_vs_dijkstra`
**Qué debe verse:**
- **Dos paneles** (`subplot(1,2,...)`) sobre el mismo grafo y mismo par origen→destino:
  - **Izquierda (Dijkstra):** nodos coloreados según hayan sido cerrados (gris=no explorado, azul=explorado, rojo=ruta).
  - **Derecha (A*):** mismo grafo, pero claramente menos nodos cerrados.
- Pie de figura con número de nodos expandidos por cada algoritmo y coste total (debe coincidir).

**Cómo obtenerla:** modificar `dijkstra.m` y `astar.m` para devolver el conjunto de nodos cerrados; usar `digraph` + `highlight`. Construir la matriz euclídea:
```matlab
data = load('grafos.mat');  J = data.J;  nodos = data.nodos;
n = size(J,1);
C = zeros(n);
for i=1:n, for j=1:n
  if J(i,j) > 0, C(i,j) = norm(nodos(i,1:2)-nodos(j,1:2)); end
end, end
```
Guardar como `memorias/robotica_movil/lab5_a_estrella/figures/astar_vs_dijkstra.png`.

---

## Lab-MR 6 · Navegación completa

**Carpeta:** [memorias/robotica_movil/lab6_navegacion_completa/figures/](memorias/robotica_movil/lab6_navegacion_completa/figures/) · **vacía**.

### Estado actual
- ⚠️ Dos huecos `\pendiente{}` añadidos en [main.tex](memorias/robotica_movil/lab6_navegacion_completa/main.tex):
  - `fig:nav_caso_base` — sección **Resultados · Caso base del enunciado**.
  - `fig:nav_zona_24_32` — sección **Resultados · Mejora propuesta e implementada**.

### Lo que falta — `fig:nav_caso_base`
**Qué debe verse:**
- Mapa `mapa2.pgm` de fondo.
- Nodos del grafo dibujados con sus IDs sobre el mapa.
- Ruta global de Dijkstra (o A*) resaltada en azul.
- Trayectoria local roja del robot superpuesta.
- Caso típico (ej. nodo 1 → nodo superior derecho) que **alcanza el destino**.

### Lo que falta — `fig:nav_zona_24_32`
**Qué debe verse:**
- Dos subpaneles del mismo origen→destino que atraviese la zona 24–32:
  - **Sin mejora (campos potenciales puros):** trayectoria atascada u oscilante.
  - **Con mejora (campo tangencial + escape):** trayectoria que supera la zona y llega.
- Anotación con número de iteraciones y mensaje éxito/fallo.

**Cómo obtenerlas:** ejecutar `navegacion_autonoma_p7.m` con cada combinación (Dijkstra/A* y mejora on/off), guardar con `exportgraphics`.

---

## Acciones priorizadas

1. ⚠️ **Generar 6 imágenes pendientes:** MR1.1 (1), MR3 (1), MR4 (1), MR5 (1), MR6 (2).
2. Tras añadir las imágenes, recompilar con `cd memorias && make all` y verificar que las referencias `\ref{fig:...}` resuelvan correctamente.
3. (Opcional) Añadir un esquema vectorial del control proporcional en MR1.1 y un diagrama de bloques de la integración global+local en MR6, en línea con los esquemas didácticos de MR1.2 y MR2.

## Resumen de capturas vs. esquemas

| Tipo | Cuántas | Dónde |
|---|---|---|
| 📷 Capturas reales de programa | 2 | MR1.2 (`curvas.png`), MR2 (`coppelia_resultado.png`) |
| 🖼️ Esquemas didácticos | 2 | MR1.2 (`dibujo_rayos.png`), MR2 (TikZ embebido) |
| ⚠️ Pendientes | 6 | MR1.1, MR3, MR4, MR5, MR6 (×2) |
