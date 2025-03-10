#!/bin/bash

# Obtener la lista de monitores ordenados por ID
MONITORS=($(hyprctl monitors -j | jq -r '.[].name'))

# Obtener el monitor activo
ACTIVE_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# Encontrar el índice del monitor activo
for i in "${!MONITORS[@]}"; do
    if [[ "${MONITORS[$i]}" == "$ACTIVE_MONITOR" ]]; then
        CURRENT_INDEX=$i
        break
    fi
done

# Calcular el índice del siguiente monitor (circular)
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#MONITORS[@]} ))

# Cambiar el foco al siguiente monitor
hyprctl dispatch focusmonitor "${MONITORS[$NEXT_INDEX]}"
