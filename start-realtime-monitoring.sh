#!/bin/zsh

# Start Real-Time Monitoring System
# Launches monitoring daemon and WebSocket server

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DAEMON_SCRIPT="$SCRIPT_DIR/monitoring-daemon.zsh"
WEBSOCKET_SCRIPT="$SCRIPT_DIR/websocket-server.py"
LOG_DIR="$HOME/.mac_daily_reports"
DAEMON_LOG="$LOG_DIR/monitoring-daemon.log"
WEBSOCKET_LOG="$LOG_DIR/websocket-server.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Create log directory
mkdir -p "$LOG_DIR"

# Function to check if process is running
is_running() {
    local pid=$1
    kill -0 "$pid" 2>/dev/null
}

# Function to start monitoring daemon
start_daemon() {
    echo -e "${BLUE}Starting monitoring daemon...${NC}"
    
    # Check if already running
    if [[ -f "$LOG_DIR/.daemon.pid" ]]; then
        local old_pid=$(cat "$LOG_DIR/.daemon.pid")
        if is_running "$old_pid"; then
            echo -e "${YELLOW}Daemon already running (PID: $old_pid)${NC}"
            return
        fi
    fi
    
    # Start daemon in background
    nohup zsh "$DAEMON_SCRIPT" >> "$DAEMON_LOG" 2>&1 &
    local daemon_pid=$!
    echo $daemon_pid > "$LOG_DIR/.daemon.pid"
    
    echo -e "${GREEN}✓ Daemon started (PID: $daemon_pid)${NC}"
    sleep 1
}

# Function to start WebSocket server
start_websocket() {
    echo -e "${BLUE}Starting WebSocket server...${NC}"
    
    # Check if already running
    if [[ -f "$LOG_DIR/.websocket.pid" ]]; then
        local old_pid=$(cat "$LOG_DIR/.websocket.pid")
        if is_running "$old_pid"; then
            echo -e "${YELLOW}WebSocket server already running (PID: $old_pid)${NC}"
            return
        fi
    fi
    
    # Check if python3 is available
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}✗ python3 not found${NC}"
        return 1
    fi
    
    # Check if websockets library is installed
    if ! python3 -c "import websockets" 2>/dev/null; then
        echo -e "${YELLOW}Installing websockets library...${NC}"
        pip3 install websockets --quiet
    fi
    
    # Start WebSocket server in background
    nohup python3 "$WEBSOCKET_SCRIPT" >> "$WEBSOCKET_LOG" 2>&1 &
    local websocket_pid=$!
    echo $websocket_pid > "$LOG_DIR/.websocket.pid"
    
    echo -e "${GREEN}✓ WebSocket server started (PID: $websocket_pid)${NC}"
    sleep 2
}

# Function to stop all services
stop_services() {
    echo -e "${BLUE}Stopping services...${NC}"
    
    if [[ -f "$LOG_DIR/.daemon.pid" ]]; then
        local daemon_pid=$(cat "$LOG_DIR/.daemon.pid")
        if is_running "$daemon_pid"; then
            kill "$daemon_pid" 2>/dev/null || true
            echo -e "${GREEN}✓ Daemon stopped${NC}"
        fi
        rm -f "$LOG_DIR/.daemon.pid"
    fi
    
    if [[ -f "$LOG_DIR/.websocket.pid" ]]; then
        local websocket_pid=$(cat "$LOG_DIR/.websocket.pid")
        if is_running "$websocket_pid"; then
            kill "$websocket_pid" 2>/dev/null || true
            echo -e "${GREEN}✓ WebSocket server stopped${NC}"
        fi
        rm -f "$LOG_DIR/.websocket.pid"
    fi
}

# Function to show status
show_status() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}       Real-Time Monitoring System Status${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    
    # Daemon status
    echo -e "${YELLOW}Monitoring Daemon:${NC}"
    if [[ -f "$LOG_DIR/.daemon.pid" ]]; then
        local daemon_pid=$(cat "$LOG_DIR/.daemon.pid")
        if is_running "$daemon_pid"; then
            echo -e "  ${GREEN}✓ Running${NC} (PID: $daemon_pid)"
        else
            echo -e "  ${RED}✗ Stopped${NC}"
        fi
    else
        echo -e "  ${RED}✗ Not started${NC}"
    fi
    
    # WebSocket status
    echo -e "${YELLOW}WebSocket Server:${NC}"
    if [[ -f "$LOG_DIR/.websocket.pid" ]]; then
        local websocket_pid=$(cat "$LOG_DIR/.websocket.pid")
        if is_running "$websocket_pid"; then
            echo -e "  ${GREEN}✓ Running${NC} (PID: $websocket_pid)"
            echo -e "  ${BLUE}URL: ws://localhost:8765${NC}"
        else
            echo -e "  ${RED}✗ Stopped${NC}"
        fi
    else
        echo -e "  ${RED}✗ Not started${NC}"
    fi
    
    # Logs
    echo -e "${YELLOW}Logs:${NC}"
    echo -e "  Daemon: $DAEMON_LOG"
    echo -e "  WebSocket: $WEBSOCKET_LOG"
    
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo ""
}

# Main script
case "${1:-start}" in
    start)
        start_daemon
        start_websocket
        show_status
        echo -e "${GREEN}Real-time monitoring system started!${NC}"
        echo -e "Open dashboard at: ${BLUE}http://localhost:8000/dashboard-realtime.html${NC}"
        ;;
    
    stop)
        stop_services
        echo -e "${GREEN}Services stopped${NC}"
        ;;
    
    restart)
        stop_services
        sleep 1
        start_daemon
        start_websocket
        show_status
        ;;
    
    status)
        show_status
        ;;
    
    logs)
        echo -e "${BLUE}Daemon logs:${NC}"
        tail -20 "$DAEMON_LOG"
        echo ""
        echo -e "${BLUE}WebSocket logs:${NC}"
        tail -20 "$WEBSOCKET_LOG"
        ;;
    
    *)
        echo "Usage: $0 {start|stop|restart|status|logs}"
        exit 1
        ;;
esac
