# Progreso - Práctica 6: Navegación completa

## Punto de partida

- Material proporcionado: `mapa2.pgm`, `mapa2.m` y enunciado PDF.
- Objetivo principal: integrar Dijkstra/A* con navegacion local por campos potenciales.
- Entregables: script MATLAB funcional, pruebas de trayectorias y analisis de limitaciones.

## Sesiones

### 2026-04-15
- **Hecho:**
  - Creado el directorio completo de la practica y copiado el enunciado.
  - Integrado `mapa2.pgm` y `mapa2.m` en `matlab/datos/`.
  - Implementado `navegacion_autonoma_p7.m` completo:
    - Planificacion global con Dijkstra y A*.
    - Construccion de costes euclideos para heuristica consistente en A*.
    - Navegacion local por campos potenciales con deteccion de colision.
    - Mejora anti-minimos locales (campo tangencial + maniobra de escape).
  - Actualizada documentacion y memoria base de la practica.
- **Estado actual:**
  - Practica funcional a nivel de codigo MATLAB, pendiente de ajuste fino de parametros segun simulacion.
- **Siguiente paso:**
  - Ejecutar en MATLAB y guardar capturas/resultados para la memoria final.

## Estado: COMPLETADA
