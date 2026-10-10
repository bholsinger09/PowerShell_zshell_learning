#!/usr/bin/env python3 -u

"""
Real-Time Metrics WebSocket Server
Broadcasts live system metrics to connected clients
"""

import asyncio
import json
import os
from pathlib import Path
from datetime import datetime
import websockets
from websockets.asyncio.server import serve

# Configuration
METRICS_FILE = os.path.expanduser('~/.mac_daily_reports/realtime-metrics.json')
WEBSOCKET_PORT = 8765
CHECK_INTERVAL = 1.0  # Check for updates every 1 second
DEBUG = os.getenv('DEBUG', '0') == '1'

# Global state
connected_clients = set()
last_metrics = None
last_timestamp = None


async def log(message):
    """Log with timestamp"""
    timestamp = datetime.now().strftime('%H:%M:%S')
    print(f"[{timestamp}] {message}")
    if DEBUG:
        print(f"[DEBUG] {message}")


async def read_latest_metrics():
    """Read the latest metrics from the file"""
    global last_metrics, last_timestamp
    
    if not os.path.exists(METRICS_FILE):
        return None
    
    try:
        # Get file modification time
        mtime = os.path.getmtime(METRICS_FILE)
        
        # Only read if file has been updated
        if last_timestamp is None or mtime > last_timestamp:
            with open(METRICS_FILE, 'r') as f:
                content = f.read()
                
                # Find all JSON objects in the file
                # Since metrics are pretty-printed one per file, read the entire content
                if content.strip():
                    try:
                        # Try parsing the entire file as one JSON object
                        metrics = json.loads(content)
                        last_metrics = metrics
                        last_timestamp = mtime
                        return metrics
                    except json.JSONDecodeError:
                        # If that fails, try line by line
                        lines = content.splitlines()
                        for line in reversed(lines):
                            stripped = line.strip()
                            if stripped and stripped.startswith('{'):
                                try:
                                    metrics = json.loads(stripped)
                                    last_metrics = metrics
                                    last_timestamp = mtime
                                    return metrics
                                except json.JSONDecodeError:
                                    continue
        
        return last_metrics
    except Exception as e:
        await log(f"Error reading metrics: {e}")
        return None


async def broadcast_metrics():
    """Periodically broadcast metrics to all connected clients"""
    while True:
        try:
            metrics = await read_latest_metrics()
            
            if metrics and connected_clients:
                # Create broadcast message
                message = json.dumps({
                    'type': 'metrics',
                    'data': metrics,
                    'timestamp': datetime.now().isoformat()
                })
                
                # Send to all connected clients
                if connected_clients:
                    await asyncio.gather(
                        *[client.send(message) for client in connected_clients],
                        return_exceptions=True
                    )
            
            await asyncio.sleep(CHECK_INTERVAL)
        
        except Exception as e:
            await log(f"Error in broadcast: {e}")
            await asyncio.sleep(CHECK_INTERVAL)


async def handle_client(websocket):
    """Handle incoming WebSocket connection"""
    client_addr = websocket.remote_address
    await log(f"Client connected: {client_addr}")
    
    connected_clients.add(websocket)
    
    try:
        # Send initial state
        metrics = await read_latest_metrics()
        if metrics:
            initial_message = json.dumps({
                'type': 'initial',
                'data': metrics,
                'timestamp': datetime.now().isoformat()
            })
            await websocket.send(initial_message)
        
        # Keep connection open and handle messages
        async for message in websocket:
            try:
                data = json.loads(message)
                
                if data.get('type') == 'ping':
                    # Respond to ping
                    pong = json.dumps({
                        'type': 'pong',
                        'timestamp': datetime.now().isoformat()
                    })
                    await websocket.send(pong)
                
                elif data.get('type') == 'request_metrics':
                    # Send current metrics on demand
                    metrics = await read_latest_metrics()
                    if metrics:
                        response = json.dumps({
                            'type': 'metrics',
                            'data': metrics,
                            'timestamp': datetime.now().isoformat()
                        })
                        await websocket.send(response)
                
                else:
                    await log(f"Unknown message type: {data.get('type')}")
            
            except json.JSONDecodeError:
                await log(f"Invalid JSON from {client_addr}")
            except Exception as e:
                await log(f"Error handling message: {e}")
    
    except websockets.exceptions.ConnectionClosed:
        pass
    
    finally:
        connected_clients.discard(websocket)
        await log(f"Client disconnected: {client_addr}")
        await log(f"Connected clients: {len(connected_clients)}")


async def main():
    """Start the WebSocket server"""
    await log(f"Starting WebSocket server on ws://localhost:{WEBSOCKET_PORT}")
    await log(f"Metrics file: {METRICS_FILE}")
    
    # Start the broadcast task
    broadcast_task = asyncio.create_task(broadcast_metrics())
    
    # Start the WebSocket server (bind to 0.0.0.0 instead of localhost)
    async with serve(handle_client, '0.0.0.0', WEBSOCKET_PORT):
        await log("WebSocket server ready for connections")
        await asyncio.Future()  # Run forever


if __name__ == '__main__':
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\nShutting down...")
        exit(0)
    except Exception as e:
        print(f"Error: {e}")
        exit(1)
