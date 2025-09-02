#!/bin/bash
# Define os nomes dos monitores
PRIMARY="HDMI-1"
SECONDARY="LVDS-1"

# Posiciona os monitores
xrandr --output $PRIMARY --primary --auto --output $SECONDARY --right-of $PRIMARY --auto

# resolucao
xrandr --output $PRIMARY --mode 1920x1080

xrandr --output $SECONDARY --mode 1280x720
