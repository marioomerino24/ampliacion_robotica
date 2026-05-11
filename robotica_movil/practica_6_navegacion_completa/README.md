# Práctica 6: Navegación completa

**Tecnología:** MATLAB

## Objetivo

Integrar planificación global de caminos (Dijkstra / A*) y navegación local reactiva (campos potenciales) para que el robot recorra trayectorias largas en un mapa real evitando obstáculos. Se incluye una mejora anti-mínimos locales con campo tangencial y maniobra de escape.

## Estructura

```
practica_6_navegacion_completa/
├── matlab/
│   ├── navegacion_autonoma_p7.m   # Script principal (planificación + navegación local)
│   ├── dijkstra.m                 # Planificador global Dijkstra
│   ├── astar.m                    # Planificador global A*
│   └── datos/
│       ├── mapa2.pgm              # Mapa de ocupación del entorno
│       └── mapa2.m                # Grafo topológico (nodos y arcos)
└── enunciado/                     # Enunciado oficial de la práctica
```

## Ejecución

```matlab
cd matlab
run('navegacion_autonoma_p7.m')
```

El script solicita el planificador (`Dijkstra` o `A*`) y los nodos de inicio y destino. Genera automáticamente figuras con los resultados sin y con la mejora anti-mínimos locales.
