# Práctica 4: Planificación de Caminos I (Dijkstra)

## Objetivo

[Descripcion breve del objetivo de la practica]

## Archivos de la práctica

| Archivo | Descripcion |
|---------|-------------|
| `enunciado/Practica5_2024-25.pdf` | Enunciado oficial de la práctica 5 |
| `matlab/dijkstra.m` | Implementación del algoritmo de Dijkstra |
| `matlab/grafos.mat` | Datos de ejemplo para probar el algoritmo |

## Ejecución (MATLAB)

```matlab
datos = load('grafos.mat');
[coste, ruta] = dijkstra(datos, 1, 7)
```

## Notas

- `dijkstra.m` acepta directamente el `struct` devuelto por `load(...)`.
- La carpeta `scenes/` y `ros2_ws/` queda disponible por si se añaden materiales complementarios.
