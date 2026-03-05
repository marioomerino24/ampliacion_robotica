#!/bin/bash
###############################################################################
# symlink_pkg.sh - Enlaza/desenlaza paquetes ROS2 de una practica al workspace
#
# Uso:
#   ./scripts/symlink_pkg.sh <ruta_practica>           # Crear symlinks
#   ./scripts/symlink_pkg.sh --remove <ruta_practica>   # Eliminar symlinks
#
# Ejemplo:
#   ./scripts/symlink_pkg.sh robotica_movil/labmr_1i_caminos_explicitos
###############################################################################

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
COLCON_SRC="$(cd "$REPO_DIR/.." && pwd)"

REMOVE=false
if [[ "${1:-}" == "--remove" ]]; then
    REMOVE=true
    shift
fi

if [[ -z "${1:-}" ]]; then
    echo "Uso: $0 [--remove] <ruta_practica>"
    echo "  Ejemplo: $0 robotica_movil/labmr_1i_caminos_explicitos"
    exit 1
fi

LAB_PATH="$REPO_DIR/$1"
ROS2_WS="$LAB_PATH/ros2_ws"

if [[ ! -d "$ROS2_WS" ]]; then
    echo "Error: No se encuentra $ROS2_WS"
    exit 1
fi

# Buscar paquetes ROS2 (directorios con package.xml)
found=0
for pkg_dir in "$ROS2_WS"/*/; do
    [[ -d "$pkg_dir" ]] || continue
    pkg_name="$(basename "$pkg_dir")"
    [[ "$pkg_name" == ".gitkeep" ]] && continue

    link_target="$COLCON_SRC/$pkg_name"

    if $REMOVE; then
        if [[ -L "$link_target" ]]; then
            rm "$link_target"
            echo "Eliminado symlink: $pkg_name"
        else
            echo "No existe symlink para: $pkg_name"
        fi
    else
        if [[ -e "$link_target" ]]; then
            echo "Ya existe: $pkg_name (saltando)"
        else
            ln -s "$pkg_dir" "$link_target"
            echo "Enlazado: $pkg_name -> $pkg_dir"
        fi
    fi
    found=1
done

if [[ $found -eq 0 ]]; then
    echo "No se encontraron paquetes en $ROS2_WS"
    echo "Crea tus paquetes ROS2 dentro de: $ROS2_WS/<nombre_paquete>/"
fi
