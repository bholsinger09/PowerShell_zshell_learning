#!/bin/zsh
# Simple HTTP server to view the dashboard
# Serves the dashboard on http://localhost:8000

DASHBOARD_DIR="$HOME/.mac_daily_reports"

if [[ ! -d "$DASHBOARD_DIR" ]]; then
    echo "Error: $DASHBOARD_DIR does not exist" >> "$DASHBOARD_DIR/server-error.log"
    exit 1
fi

if [[ ! -f "$DASHBOARD_DIR/dashboard.html" ]]; then
    echo "Error: dashboard.html not found" >> "$DASHBOARD_DIR/server-error.log"
    exit 1
fi

cd "$DASHBOARD_DIR"
python3 -m http.server 8000 --bind 127.0.0.1
