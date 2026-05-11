# Práctica 4: Planificación de caminos I — Dijkstra

**Tecnología:** MATLAB

## Objetivo

Implementar el algoritmo de Dijkstra para calcular la ruta de coste mínimo en un grafo topológico dirigido y ponderado. La función admite cualquier grafo representado como matriz de costes NxN.

## Estructura

```
practica_4_planificacion_de_caminos_i_dijkstra/
├── matlab/
│   ├── dijkstra.m     # Implementación del algoritmo de Dijkstra
│   └── grafos.mat     # Grafos de ejemplo para validación
└── enunciado/         # Enunciado oficial de la práctica
```

## Ejecución

```matlab
% Cargar los grafos de ejemplo
datos = load('grafos.mat');

% Calcular ruta óptima (origen → destino)
[coste, ruta] = dijkstra(datos, origen, destino)
```

`dijkstra.m` acepta directamente el `struct` devuelto por `load(...)`. El archivo `grafos.mat` contiene varias matrices de ejemplo (`G`, `H`, `J`, ...) con el convenio `0 = sin arco`.
