#!/usr/bin/env bash
# Weekly Planner desklet install script
#   ./install.sh                   install / update
#   ./install.sh --uninstall       remove (does not touch data files)
#   ./install.sh --reset-settings  install + clear stale settings files
set -euo pipefail

UUID="weekly-planner@egemngyk"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$UUID"
DEST="${XDG_DATA_HOME:-$HOME/.local/share}/cinnamon/desklets/$UUID"

if [[ "${1:-}" == "--uninstall" ]]; then
    rm -rf "$DEST"
    echo "Removed: $DEST"
    echo "Remove any instances on your desktop from the 'Desklets' settings screen."
    echo "Your data is still here (delete it manually if you want): ${XDG_DATA_HOME:-$HOME/.local/share}/weekly-planner-desklet/"
    exit 0
fi

if [[ "${1:-}" == "--reset-settings" ]]; then
    # Clears settings files left over from old/broken attempts (entry data is untouched).
    rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/cinnamon/spices/$UUID"
    echo "Stale settings cleared. Remove the old desklet instance from your desktop and add it again."
fi

command -v cinnamon >/dev/null 2>&1 && echo "Cinnamon version: $(cinnamon --version 2>/dev/null || echo unknown)"
[[ -f "$SRC/metadata.json" ]] || { echo "Error: $SRC/metadata.json not found" >&2; exit 1; }

mkdir -p "$(dirname "$DEST")"
rm -rf "$DEST"
cp -r "$SRC" "$DEST"
echo "Installed: $DEST"

# Ensure data directory and default entries.json exist
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/weekly-planner-desklet"
mkdir -p "$DATA_DIR"
if [[ ! -s "$DATA_DIR/entries.json" ]]; then
    cat > "$DATA_DIR/entries.json" << 'EOF'
{
  "options": {
    "colors": [
      "blue",
      "red",
      "yellow",
      "purple",
      "teal",
      "gray",
      "pink",
      "green",
      "orange",
      "navy"
    ],
    "help": "Weekly entries repeat on that weekday every week. Dates entries (YYYY-MM-DD) appear only on that specific date. Use color name or #hex."
  },
  "_example": {
    "title": "Example task (this sample is never displayed on the desklet)",
    "notes": "Optional notes or details",
    "color": "blue",
    "important": true,
    "todo": true,
    "done": false
  },
  "weekly": {
    "monday": [],
    "tuesday": [],
    "wednesday": [],
    "thursday": [],
    "friday": [],
    "saturday": [],
    "sunday": []
  },
  "dates": {}
}
EOF
    echo "Created template: $DATA_DIR/entries.json"
fi

# Reload desklet in Cinnamon if Cinnamon is running
if command -v gdbus >/dev/null 2>&1; then
    gdbus call --session --dest org.Cinnamon --object-path /org/Cinnamon --method org.Cinnamon.ReloadXlet "$UUID" "DESKLET" >/dev/null 2>&1 || true
    echo "Reloaded desklet in Cinnamon."
fi
echo