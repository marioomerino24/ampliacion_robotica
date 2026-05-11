# Práctica 3: Evitar obstáculos mediante campos potenciales

**Tecnología:** MATLAB

## Objetivo

Implementar navegación local reactiva mediante campos potenciales artificiales. Se combina un campo atractivo hacia el destino y un campo repulsivo generado por los obstáculos detectados con un sensor láser simulado, obteniendo una velocidad de navegación resultante en cada instante.

## Estructura

```
practica_3_evitar_obstaculos_mediante_campos_potenciales/
├── matlab/
│   ├── plantilla_campos_potenciales.m   # Implementación principal
│   └── mapa1_150.png                    # Mapa de ocupación del entorno
└── enunciado/                           # Enunciado oficial de la práctica
```

## Ejecución

```matlab
% Desde el directorio matlab/
run('plantilla_campos_potenciales.m')
```

Al ejecutar, el script muestra el mapa y solicita al usuario que seleccione con el ratón el punto de inicio y el punto destino. La simulación arranca automáticamente.
