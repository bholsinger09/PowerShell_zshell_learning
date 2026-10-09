#!/bin/zsh
# Simple HTTP server to view the dashboard
# Serves the dashboard on http://localhost:8000

set -e

DASHBOARD_DIR="$HOME/.mac_daily_reports"

if [[ ! -d "$DASHBOARD_DIR" ]]; then
    echo "Error: $DASHBOARD_DIR does not exist"
    exit 1
fi

if [[ ! -f "$DASHBOARD_DIR/dashboard.html" ]]; then
    echo "Error: dashboard.html not found in $DASHBOARD_DIR"
    exit 1
fi

echo "🚀 Starting Dashboard Server..."
echo ""
echo "📊 Dashboard available at: http://localhost:8000/dashboard.html"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

cd "$DASHBOARD_DIR"
python3 -m http.server 8000 --bind 127.0.0.1
