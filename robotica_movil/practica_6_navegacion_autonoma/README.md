# Práctica 6: Navegación autónoma

## Objetivo

Integrar navegacion global (planificacion de caminos en grafo) y navegacion local reactiva (campos potenciales) para que el robot recorra trayectorias largas evitando obstaculos.

## Archivos de la practica

| Archivo | Descripcion |
|---------|-------------|
| `enunciado/Practica7_2024-2025.pdf` | Enunciado oficial de la practica 7 |
| `matlab/navegacion_autonoma_p7.m` | Script principal completo (Dijkstra/A* + campos potenciales + mejora anti-minimos locales) |
| `matlab/dijkstra.m` | Planificacion global por Dijkstra |
| `matlab/astar.m` | Alternativa A* con heuristica consistente |
| `matlab/datos/` | Carpeta con `mapa2.pgm` y `mapa2.m`, ya incorporados desde `robotica_movil/inputs/` |

## Ejecucion (MATLAB)

```matlab
cd('matlab')
run('navegacion_autonoma_p7.m')
```

## Notas

1. El script pregunta planificador (`Dijkstra` o `A*`) y nodos de inicio/destino.
2. Para `A*`, se usa una matriz de costes euclidea consistente construida a partir de la adyacencia original.
3. La navegacion local incorpora dos mejoras para el caso conflictivo (24-32): campo tangencial y maniobra de escape por estancamiento.
