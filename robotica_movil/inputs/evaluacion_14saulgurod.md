# Evaluación — 14saulgurod (Saul Gurod)
# Ampliación de Robótica — Prácticas 6 y 7
# Fecha de análisis: 2026-04-21

---

## PRÁCTICA 6 — Planificación de Caminos II (A*)

### REQ 1 — Implementar `aestrella(G,H,origen,destino)` → coste=7, ruta=[1 2 4 6 7]

| Criterio | Estado | Observación |
|---|---|---|
| Firma de la función | ⚠️ | Enunciado pide `aestrella` (minúsculas). Implementado como `Aestrella` (mayúscula). En Linux MATLAB es case-sensitive: la llamada fallaría. |
| Matrices G y H | ✅ | Correctamente transcritas del enunciado |
| Resultado coste=7, ruta=[1 2 4 6 7] | ✅ | Verificado por trazado manual del algoritmo |
| Estructura de la función (entradas/salidas) | ✅ | Recibe G, H, origen, destino; devuelve coste y ruta |

### REQ 2 — Llamar `aestrella(G,H,7,4)` y observar que el resultado no es óptimo

| Criterio | Estado | Observación |
|---|---|---|
| Llamada realizada | ✅ | |
| Explicación del fallo | ✅ | Comentario correcto: "no garantiza optimalidad cuando la heurística no es admisible" |
| Identificación del nodo concreto que sobreestima | ❌ | No se identifica qué valor de H sobreestima. El enunciado resalta H(4,·) en el diagrama. |

### REQ 3 — Proponer heurística admisible para que (7→4) dé el camino óptimo

| Criterio | Estado | Observación |
|---|---|---|
| H1 = zeros | ✅ | Correcta. h=0 nunca sobreestima. Admisible trivialmente. |
| H2 (valores reducidos) | ❌ | H2(5,4)=2 pero h*(5→4)=1 (arista directa G(5,4)=1). Viola h(n)≤h*(n). Solo funciona para el caso de prueba por casualidad. |
| Verificación de admisibilidad | ❌ | No se comprueba que h(n)≤h*(n) para todos los pares de nodos. |

### Lo que sobra en P6
- Resumen explicativo extenso en `Aestrella.mlx` (no pedido, no negativo)
- Se proponen dos heurísticas cuando el enunciado pide una; H2 es incorrecta y añade confusión
- Título `%% PRACTICA 5` en lugar de `%% PRACTICA 6` — error de descuido

### Nota P6: 6.5 / 10

| Concepto | Puntos |
|---|---|
| Implementación A* correcta y funcional | +3.5 |
| REQ 1: resultado correcto | +1.5 |
| REQ 2: llamada y explicación | +1.0 |
| REQ 3: H1 admisible correcta | +1.0 |
| REQ 3: H2 incorrecta, sin verificación formal | -0.5 |
| Firma con mayúscula (incumplimiento técnico) | -0.5 |

---

## PRÁCTICA 7 — Navegación Autónoma

### REQ 1 — Dijkstra + campos potenciales, input nodos, visualización, mensaje de llegada

| Criterio | Estado | Observación |
|---|---|---|
| Usar Dijkstra | ✅ | |
| Usar campos potenciales | ⚠️ | Implementado pero con bug de signo (ver abajo) |
| Preguntar nodos inicio y destino | ✅ | `input()` en ambas partes |
| Representar gráficamente el mapa | ✅ | `imshow` + `flipud` correcto |
| Representar trayectoria del robot | ✅ | Camino global azul, trayectoria local roja |
| **Indicar con mensaje si llegó al destino** | ❌ | **Requisito explícito del enunciado no cumplido.** Solo hay aviso de atasco parcial por segmento. Falta mensaje final de éxito/fallo global. |

#### Bug crítico — Fuerza repulsiva (`fuerza_repulsiva.mlx`)
El vector `[i j]` apunta del robot hacia el obstáculo. La fórmula implementada:
```
F = F + K_rep * (1/d - 1/d0) * (1/d^2) * ([i j]/d)
```
debería ser `−[i j]/d` para repeler. La fuerza está **invertida**: atrae hacia obstáculos
en lugar de repelerlos. Funciona parcialmente porque `3*F_attr` domina en espacios abiertos
y el mecanismo anti-retroceso anula la fuerza incorrecta, pero en pasillos estrechos fallaría.

### REQ 2 — Análisis trayectorias, problema nodos 24-32, propuesta de mejora

| Criterio | Estado | Observación |
|---|---|---|
| Ejecutar trayectoria nodo 1 → destino derecha superior | ❌ | No entregado |
| Intentar cruzar zona nodos 24-32 | ❌ | No entregado |
| ¿Es posible alcanzar el objetivo? | ❌ | No entregado |
| ¿A qué se debe el problema? | ❌ | No entregado |
| Proponer mejora | ❌ | No entregado |

**Apartado 2 completamente ausente.** No hay fichero, texto, ni capturas.

### REQ 3 — A* con heurística euclídea y nueva matriz de costes euclídea

| Criterio | Estado | Observación |
|---|---|---|
| Heurística euclídea consistente | ✅ | Calculada correctamente con coordenadas de `nodos` |
| Reemplazar Dijkstra por A* | ✅ | |
| Nueva matriz de costes euclídea | ✅ | |
| Respetar adyacencia del grafo original | ✅ | `if costes(i,j) > 0` — exactamente lo que indica la nota del enunciado |
| Mantener visualización y campos potenciales | ✅ | Mismo bug de signo heredado de REQ 1 |
| Mensaje de llegada al destino | ❌ | Mismo problema no corregido |

### Lo que sobra en P7
- `% Si no se limpia a veces se solapa o no lo hace bien` — comentario informal de proceso
- Bloque `else costes_euclidea(i,j) = 0` en `Practica7_c.mlx`: redundante, la matriz ya se inicializa con `zeros(n)`
- Mecanismo anti-retroceso (`if dot(F_total,...) < 0`): no pedido; razonable en concepto pero enmascara el bug de signo de la fuerza repulsiva
- Normalización de fuerza total: no pedida; innecesaria si la física estuviese correcta

### Nota P7: 4.5 / 10

| Concepto | Puntos |
|---|---|
| REQ 1: estructura Dijkstra + campos potenciales | +2.0 |
| REQ 1: input, visualización mapa y trayectoria | +1.0 |
| REQ 3: A* con heurística y costes euclídeos correcto | +2.0 |
| REQ 1 y 3: falta mensaje de llegada al destino | -0.5 |
| Bug física fuerza repulsiva (signo incorrecto) | -0.5 |
| REQ 2 completamente no entregado | -2.5 |
| Dijkstra correcto (incluido en REQ 1) | (ya contabilizado) |

---

## TABLA RESUMEN GLOBAL

| Requisito | P6 | P7 |
|---|---|---|
| Firma exacta de la función | ⚠️ Mayúscula | — |
| Resultado numérico correcto | ✅ | — |
| Ejecutar caso y explicar | ✅ | — |
| Identificar nodo que sobreestima | ❌ | — |
| Heurística admisible válida | ⚠️ H1 sí, H2 no | — |
| Verificación formal de admisibilidad | ❌ | — |
| Dijkstra + campos potenciales | — | ✅ |
| Input de nodos | — | ✅ |
| Visualización mapa + trayectoria | — | ✅ |
| Mensaje si llega al destino | — | ❌ |
| Fuerza repulsiva físicamente correcta | — | ❌ |
| Apartado 2 analítico completo | — | ❌ |
| A* con heurística euclídea | — | ✅ |
| Costes euclídeos con adyacencia | — | ✅ |

| Práctica | Nota |
|---|---|
| Práctica 6 | **6.5 / 10** |
| Práctica 7 | **4.5 / 10** |

---

## OPINIÓN GENERAL

El estudiante demuestra comprensión conceptual de los algoritmos (A*, Dijkstra, campos
potenciales) y el código es limpio y legible. Los fallos no son de falta de comprensión
sino de ejecución incompleta:

- P6: la implementación del núcleo es correcta, pero falla en la verificación rigurosa
  de la admisibilidad de la heurística y en detalles formales (firma, título).
- P7: la integración Dijkstra+campos potenciales y la sustitución por A* están bien
  planteadas, pero la física de la fuerza repulsiva tiene un error de signo, falta
  el requisito explícito del mensaje de llegada, y el apartado 2 (el más analítico
  y conceptual) no fue entregado en absoluto.

No hay evidencia de copia. Los comentarios explicativos son propios y van más allá
de lo mínimo requerido.
