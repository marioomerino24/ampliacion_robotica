# Práctica 5: Planificación de caminos II — A*

**Tecnología:** MATLAB

## Objetivo

Implementar el algoritmo A* sobre un grafo topológico con heurística externa, consiguiendo rutas óptimas con menor coste computacional que Dijkstra gracias a la guía de la heurística admisible.

## Estructura

```
practica_5_planificacion_de_caminos_ii_a_estrella/
├── matlab/
│   └── aestrella.m    # Implementación del algoritmo A*
└── enunciado/         # Enunciado oficial de la práctica
```

## Ejecución

```matlab
% G: matriz NxN de costes del grafo
% H: matriz NxN de heurísticas (estimación de coste restante)
[coste, ruta] = aestrella(G, H, origen, destino)
```

La heurística `H` debe ser admisible (no sobreestimar el coste real) para garantizar optimalidad. La función devuelve `coste = Inf` y `ruta = []` si no existe camino entre los nodos indicados.
