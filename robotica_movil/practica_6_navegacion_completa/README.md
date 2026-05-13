# Práctica 6: Navegación completa

**Tecnología:** MATLAB

## Objetivo

Integrar planificación global de caminos (Dijkstra y A*) con navegación local reactiva basada en campos potenciales para que el robot recorra trayectorias largas evitando los obstáculos del entorno. Como mejora frente a mínimos locales se prioriza la fuerza atractiva (factor ×3) y se sustituye la fuerza total por la atractiva pura cuando aquélla apunta en sentido contrario al objetivo.

## Estructura

```
practica_6_navegacion_completa/
├── matlab/
│   ├── navegacion_autonoma_p7_dijkstra.m    # Script principal (Dijkstra)
│   ├── navegacion_autonoma_p7_Aestrella.m   # Script principal (A*)
│   ├── dijkstra.m                           # Algoritmo Dijkstra
│   ├── Aestrella.m                          # Algoritmo A*
│   ├── fuerza_atractiva.m                   # Campo atractivo hacia el subobjetivo
│   ├── fuerza_repulsiva.m                   # Campo repulsivo por escaneo de píxeles
│   ├── mapa2.pgm                            # Imagen del entorno (obstáculos)
│   └── mapa2.m                              # Grafo topológico (nodos y costes)
└── enunciado/                               # Enunciado oficial de la práctica
```

## Ejecución

Cada script pregunta nodo origen y nodo destino, y muestra el mapa con la ruta planificada (azul) y la trayectoria real del robot (rojo).

```matlab
cd matlab

% Dijkstra
navegacion_autonoma_p7_dijkstra

% A*  (heurística y costes basados en distancia euclídea)
navegacion_autonoma_p7_Aestrella
```

## Notas

- Para A* la matriz de costes se reconstruye a partir de la adyacencia original (`mapa2.m`) usando distancia euclídea entre nodos. Así la heurística (también euclídea) es consistente y A* devuelve la ruta óptima.
- La fuerza repulsiva utiliza `img(y, x)` directamente sobre la imagen original, en coincidencia con la convención del enunciado.
