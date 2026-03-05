#!/bin/bash
###############################################################################
# nueva_practica.sh - Genera una practica nueva desde plantilla
#
# Uso:
#   ./scripts/nueva_practica.sh <bloque> <nombre_dir> "<titulo_completo>"
#
# Ejemplo:
#   ./scripts/nueva_practica.sh robotica_movil labmr_2i "LabMR 2-I: Planificacion de trayectorias"
#   ./scripts/nueva_practica.sh manipuladores labman_1i "LabMAN 1-I: Cinematica directa"
###############################################################################

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATES_DIR="$REPO_DIR/.templates"

if [[ $# -ne 3 ]]; then
    echo "Uso: $0 <bloque> <nombre_dir> \"<titulo_completo>\""
    echo ""
    echo "Bloques disponibles: robotica_movil, manipuladores"
    echo ""
    echo "Ejemplos:"
    echo "  $0 robotica_movil labmr_2i \"LabMR 2-I: Planificacion de trayectorias\""
    echo "  $0 manipuladores labman_1i \"LabMAN 1-I: Cinematica directa\""
    exit 1
fi

BLOQUE="$1"
DIR_NAME="$2"
TITULO_COMPLETO="$3"

# Extraer el ID del lab (parte antes de los dos puntos)
LAB_ID="$(echo "$TITULO_COMPLETO" | cut -d':' -f1 | xargs)"
# Extraer el titulo (parte despues de los dos puntos)
LAB_TITULO="$(echo "$TITULO_COMPLETO" | cut -d':' -f2- | xargs)"

BLOQUE_DIR="$REPO_DIR/$BLOQUE"
LAB_DIR="$BLOQUE_DIR/$DIR_NAME"

# Validar bloque
if [[ ! -d "$BLOQUE_DIR" ]]; then
    echo "Error: Bloque '$BLOQUE' no existe. Bloques disponibles:"
    ls -d "$REPO_DIR"/*/  2>/dev/null | xargs -I{} basename {} | grep -v scripts | grep -v '.templates'
    exit 1
fi

# Comprobar que no existe ya
if [[ -d "$LAB_DIR" ]]; then
    echo "Error: Ya existe el directorio $LAB_DIR"
    exit 1
fi

echo "Creando practica:"
echo "  Bloque:    $BLOQUE"
echo "  Directorio: $DIR_NAME"
echo "  Lab ID:    $LAB_ID"
echo "  Titulo:    $LAB_TITULO"
echo ""

# Crear estructura
mkdir -p "$LAB_DIR"/{enunciado,scenes,ros2_ws}

# Copiar y rellenar plantillas
for template in README.md PROGRESO.md; do
    sed -e "s|{{LAB_ID}}|$LAB_ID|g" \
        -e "s|{{LAB_TITULO}}|$LAB_TITULO|g" \
        -e "s|{{BLOQUE}}|$BLOQUE|g" \
        -e "s|{{DIR_NAME}}|$DIR_NAME|g" \
        "$TEMPLATES_DIR/$template" > "$LAB_DIR/$template"
done

# Crear .gitkeep en directorios vacios
touch "$LAB_DIR/enunciado/.gitkeep"
touch "$LAB_DIR/scenes/.gitkeep"
touch "$LAB_DIR/ros2_ws/.gitkeep"

echo "Practica creada en: $LAB_DIR"
echo ""
echo "Siguientes pasos:"
echo "  1. Copia el PDF del enunciado a: $LAB_DIR/enunciado/"
echo "  2. Copia las escenas .ttt a:     $LAB_DIR/scenes/"
echo "  3. Crea tus paquetes ROS2 en:    $LAB_DIR/ros2_ws/"
echo "  4. Rellena el PROGRESO.md con el punto de partida"
