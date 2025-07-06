#!/bin/bash

WALL_DIR="$HOME/.config/hypr/wallpapers"  # change to your actual path
IMG=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)

swww img "$IMG" --transition-type any --transition-duration 1 --transition-fps 60

