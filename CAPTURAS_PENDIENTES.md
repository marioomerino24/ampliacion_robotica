# Capturas pendientes — Robótica Móvil

Lista de capturas que faltan para cerrar las memorias.

**Solo capturas de ejecución del programa** (CoppeliaSim o MATLAB). Los esquemas vectoriales no entran aquí — los hago yo aparte.

**Total: 6 capturas.**

Para cada una indico:
- **Archivo:** nombre exacto del PNG y carpeta donde dejarlo.
- **Qué debe verse:** elementos imprescindibles en la imagen.
- **Cómo obtenerla:** pasos mínimos.

Recordatorios generales:
- Al guardar desde MATLAB usa preferiblemente `exportgraphics(gcf, 'nombre.png', 'Resolution', 200)`.
- En CoppeliaSim, vista cenital + captura del visor con `Ctrl+P` o tirando de captura del sistema operativo.
- Resolución mínima recomendada: **1200 px** de ancho. PNG, no JPG.

---

## 1. MR1.1 — Recorrido P2P rectangular

**Archivo:** `p2p_recorrido.png`
**Carpeta:** `memorias/robotica_movil/lab1_1_caminos_explicitos/figures/`

### Qué debe verse
- Vista **cenital** de la escena P2P en CoppeliaSim.
- El robot **Pioneer P3DX** visible.
- La **traza** completa del recorrido rectangular cubriendo el perímetro:
  `(0,0) → (10,0) → (10,10) → (-10,10) → (-10,-10) → (10,-10) → (0,0)`.
- Mejor con `loop_waypoints=true` para que se vea el cierre de la trayectoria.

### Cómo obtenerla
1. Abrir CoppeliaSim con la escena `p2p_scene.ttt`.
2. En otra terminal: `ros2 launch seg_tray nav_p2p_launch.py`.
3. Dejar correr al menos una vuelta completa.
4. Pasar a vista cenital (cámara desde arriba) y capturar.

---

## 2. MR3 — Trayectoria por campos potenciales

**Archivo:** `trayectoria_p3.png`
**Carpeta:** `memorias/robotica_movil/lab3_campos_potenciales/figures/`

### Qué debe verse
- Mapa `mapa1_150.png` de fondo (lo dibuja `show(mapa)` automáticamente).
- **Círculo verde** en el origen.
- **Círculo rojo** en el destino.
- **Traza roja** del recorrido del robot.

Idealmente generar **dos imágenes**: una llegando al destino, otra atascada en mínimo local (1000 iteraciones). Si solo hay tiempo para una, mejor la del **destino alcanzado**.

### Cómo obtenerla
1. MATLAB → `cd robotica_movil/practica_3_evitar_obstaculos_mediante_campos_potenciales/matlab/`.
2. Ejecutar `plantilla_campos_potenciales.m`.
3. Hacer clic en el mapa: primero origen, luego destino.
4. Cuando termine el bucle:
   ```matlab
   exportgraphics(gcf, 'trayectoria_p3.png', 'Resolution', 200)
   ```

---

## 3. MR4 — Ruta óptima de Dijkstra

**Archivo:** `dijkstra_ruta.png`
**Carpeta:** `memorias/robotica_movil/lab4_dijkstra/figures/`

### Qué debe verse
- El **grafo** dibujado con todos los nodos numerados.
- Las aristas con su **peso** anotado.
- La **ruta óptima** resaltada en rojo (nodos y aristas) — por ejemplo nodo 1 → nodo 7.
- Título con el coste total: `Ruta óptima 1 → 7 (coste = X.XX)`.

### Cómo obtenerla
En MATLAB, desde la carpeta `practica_4_planificacion_de_caminos_i_dijkstra/matlab/`:
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

---

## 4. MR5 — Comparativa A* vs Dijkstra

**Archivo:** `astar_vs_dijkstra.png`
**Carpeta:** `memorias/robotica_movil/lab5_a_estrella/figures/`

### Qué debe verse
Una sola figura con **dos paneles** (mismo grafo, mismo origen→destino):

- **Panel izquierdo (Dijkstra):** todos los nodos cerrados marcados (azul/gris) y la ruta final en rojo.
- **Panel derecho (A*):** notablemente menos nodos cerrados, misma ruta final en rojo.

Bajo cada panel, el contador: `Nodos expandidos = X`. Idealmente, el coste total impreso debe ser idéntico en ambos.

### Cómo obtenerla
Hace falta que `dijkstra.m` y `astar.m` devuelvan también el vector de nodos cerrados (modificación pequeña). Después:

```matlab
data = load('grafos.mat');
J = data.J;  nodos = data.nodos;     % ajusta el nombre del campo si difiere
n = size(J,1);

% Matriz de costes euclídea (consistencia con la heurística de A*)
C = zeros(n);
for i=1:n
  for j=1:n
    if J(i,j) > 0
      C(i,j) = norm(nodos(i,1:2)-nodos(j,1:2));
    end
  end
end

[~, ruta_d, cerrados_d] = dijkstra_ext(C, 1, 7);
[~, ruta_a, cerrados_a] = astar_ext(C, nodos, 1, 7);

G = digraph(C);
tiledlayout(1,2);
nexttile;
  p1 = plot(G, 'Layout','force');
  highlight(p1, cerrados_d, 'NodeColor', 'b');
  highlight(p1, ruta_d, 'EdgeColor','r', 'LineWidth', 2.5, 'NodeColor','r');
  title(sprintf('Dijkstra — %d nodos cerrados', numel(cerrados_d)));
nexttile;
  p2 = plot(G, 'Layout','force');
  highlight(p2, cerrados_a, 'NodeColor', 'b');
  highlight(p2, ruta_a, 'EdgeColor','r', 'LineWidth', 2.5, 'NodeColor','r');
  title(sprintf('A* — %d nodos cerrados', numel(cerrados_a)));

exportgraphics(gcf, 'astar_vs_dijkstra.png', 'Resolution', 200);
```

> **Nota:** `dijkstra_ext` y `astar_ext` son las versiones modificadas para devolver también la lista de cerrados. Si os es más rápido, basta con plotear en figuras separadas y unirlas a mano.

---

## 5. MR6 — Caso base de navegación autónoma

**Archivo:** `nav_caso_base.png`
**Carpeta:** `memorias/robotica_movil/lab6_navegacion_autonoma/figures/`

### Qué debe verse
- Mapa `mapa2.pgm` de fondo.
- **Nodos del grafo** dibujados sobre el mapa, con su ID numérico.
- **Ruta global** de Dijkstra (o A*) resaltada en azul, conectando los nodos seleccionados.
- **Trayectoria local roja** real del robot recorriendo el camino.
- Caso típico que **alcanza el destino**, por ejemplo nodo 1 → nodo de la zona superior derecha.

### Cómo obtenerla
1. MATLAB → `cd robotica_movil/practica_6_navegacion_autonoma/matlab/`.
2. Ejecutar `navegacion_autonoma_p7.m`.
3. Cuando pregunte: planificador `Dijkstra` (o `A*`), origen `1`, destino el del enunciado.
4. Al terminar:
   ```matlab
   exportgraphics(gcf, 'nav_caso_base.png', 'Resolution', 200)
   ```

---

## 6. MR6 — Zona conflictiva 24–32

**Archivo:** `nav_zona_24_32.png`
**Carpeta:** `memorias/robotica_movil/lab6_navegacion_autonoma/figures/`

### Qué debe verse
**Dos paneles** del mismo origen→destino que atraviese la zona 24–32:

- **Izquierda (sin mejora):** campos potenciales puros. Trayectoria oscilando o atascada en mínimo local.
- **Derecha (con mejora):** campo tangencial + maniobra de escape. Trayectoria que supera la zona y llega.

Anotar en cada panel:
- Número de iteraciones.
- Estado final: `Destino alcanzado` o `No se ha podido llegar`.

### Cómo obtenerla
1. Ejecutar `navegacion_autonoma_p7.m` **dos veces** con la misma pareja origen/destino que pase por la zona 24–32:
   - Primera vez: con la mejora desactivada (flag `usar_mejora = false` o equivalente).
   - Segunda vez: con la mejora activada.
2. Cada vez guardar la figura por separado:
   ```matlab
   exportgraphics(gcf, 'zona_sin_mejora.png', 'Resolution', 200)
   exportgraphics(gcf, 'zona_con_mejora.png', 'Resolution', 200)
   ```
3. Combinar los dos PNG lado a lado (en cualquier editor: GIMP, Preview, PowerPoint, o `montage` de ImageMagick):
   ```bash
   montage zona_sin_mejora.png zona_con_mejora.png -tile 2x1 -geometry +10+0 nav_zona_24_32.png
   ```

> Si no hay flag para activar/desactivar la mejora, basta con hacer una versión rápida del script comentando las líneas del campo tangencial y la maniobra de escape antes de la primera ejecución.

---

## Checklist final

- [ ] `p2p_recorrido.png` (MR1.1)
- [ ] `trayectoria_p3.png` (MR3)
- [ ] `dijkstra_ruta.png` (MR4)
- [ ] `astar_vs_dijkstra.png` (MR5)
- [ ] `nav_caso_base.png` (MR6)
- [ ] `nav_zona_24_32.png` (MR6)

Cuando estén las 6, recompilar las memorias:
```bash
cd memorias && make all
```
