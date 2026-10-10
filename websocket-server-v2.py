#!/usr/bin/env python3

"""
Real-Time Metrics WebSocket Server - Simplified Version
Broadcasts live system metrics to connected clients
"""

import asyncio
import json
import os
from datetime import datetime

try:
    import websockets
    from websockets.asyncio.server import serve
except ImportError:
    print("Installing websockets...")
    import subprocess
    subprocess.run(["pip3", "install", "websockets"], check=True)
    import websockets
    from websockets.asyncio.server import serve

# Configuration
METRICS_FILE = os.path.expanduser('~/.mac_daily_reports/realtime-metrics.json')
WEBSOCKET_PORT = 8765

# Global state
connected_clients = set()
last_metrics = None


def read_metrics_from_file():
    """Read latest metrics from file (blocking call)"""
    global last_metrics
    
    if not os.path.exists(METRICS_FILE):
        return None
    
    try:
        with open(METRICS_FILE, 'r') as f:
            content = f.read().strip()
            
            if not content:
                return None
            
            # The file contains multiple JSON objects
            # Find the last complete JSON object
            # Split by } to find separate objects
            parts = content.split('}\n{')
            
            if not parts:
                return None
            
            # Get the last part
            last_part = parts[-1]
            
            # Make sure it's a valid JSON object
            if not last_part.strip().startswith('{'):
                last_part = '{' + last_part
            if not last_part.strip().endswith('}'):
                last_part = last_part + '}'
            
            try:
                data = json.loads(last_part)
                last_metrics = data
                return data
            except json.JSONDecodeError as e:
                print(f"Parse error on last part: {e}")
                # Try parsing line by line from the end
                lines = content.split('\n')
                for line in reversed(lines):
                    line = line.strip()
                    if line == '}':
                        continue
                    if line.startswith('{'):
                        try:
                            data = json.loads(line)
                            last_metrics = data
                            return data
                        except json.JSONDecodeError:
                            continue
                
                return last_metrics
    
    except Exception as e:
        print(f"Error reading metrics: {e}")
        return last_metrics


async def handle_client(websocket, path=None):
    """Handle client connection"""
    try:
        print(f"[{datetime.now().strftime('%H:%M:%S')}] Client connected from {websocket.remote_address}")
        connected_clients.add(websocket)
        
        # Send initial metrics
        metrics = read_metrics_from_file()
        if metrics:
            msg = json.dumps({
                'type': 'initial',
                'data': metrics,
                'timestamp': datetime.now().isoformat()
            })
            print(f"[{datetime.now().strftime('%H:%M:%S')}] Sending initial message with metrics")
            await websocket.send(msg)
        
        # Handle incoming messages
        try:
            async for message in websocket:
                try:
                    data = json.loads(message)
                    msg_type = data.get('type')
                    
                    if msg_type == 'ping':
                        # Respond to ping
                        response = json.dumps({
                            'type': 'pong',
                            'timestamp': datetime.now().isoformat()
                        })
                        await websocket.send(response)
                    
                    elif msg_type == 'request_metrics':
                        # Send metrics on demand
                        metrics = read_metrics_from_file()
                        if metrics:
                            response = json.dumps({
                                'type': 'metrics',
                                'data': metrics,
                                'timestamp': datetime.now().isoformat()
                            })
                            await websocket.send(response)
                
                except json.JSONDecodeError:
                    print(f"Invalid JSON from client")
                except Exception as e:
                    print(f"Error processing message: {e}")
        
        except asyncio.CancelledError:
            pass
    
    except Exception as e:
        print(f"Client error: {e}")
    
    finally:
        connected_clients.discard(websocket)
        print(f"[{datetime.now().strftime('%H:%M:%S')}] Client disconnected. Clients: {len(connected_clients)}")


async def broadcast_loop():
    """Periodically broadcast metrics to all clients"""
    while True:
        try:
            # Broadcast every 2-3 seconds (matching daemon collection interval)
            await asyncio.sleep(2.5)
            
            metrics = read_metrics_from_file()
            
            if metrics and connected_clients:
                msg = json.dumps({
                    'type': 'update',
                    'data': metrics,
                    'timestamp': datetime.now().isoformat()
                })
                
                # Send to all connected clients
                dead_clients = set()
                for client in connected_clients:
                    try:
                        await client.send(msg)
                        # Debug: log successful broadcast
                        # print(f"[{datetime.now().strftime('%H:%M:%S')}] Broadcast sent - Memory: {metrics.get('memory')}%")
                    except Exception as e:
                        print(f"Failed to send to client: {e}")
                        dead_clients.add(client)
                
                # Remove disconnected clients
                for client in dead_clients:
                    connected_clients.discard(client)
        
        except Exception as e:
            print(f"Broadcast error: {e}")
            await asyncio.sleep(2.5)


async def main():
    """Start WebSocket server"""
    print(f"[{datetime.now().strftime('%H:%M:%S')}] Starting WebSocket server")
    print(f"[{datetime.now().strftime('%H:%M:%S')}] Listening on ws://0.0.0.0:{WEBSOCKET_PORT}")
    print(f"[{datetime.now().strftime('%H:%M:%S')}] Metrics file: {METRICS_FILE}")
    
    # Start broadcast task
    broadcast_task = asyncio.create_task(broadcast_loop())
    
    # Start WebSocket server
    async with serve(handle_client, '0.0.0.0', WEBSOCKET_PORT):
        print(f"[{datetime.now().strftime('%H:%M:%S')}] WebSocket server ready")
        await asyncio.Future()  # Run forever


if __name__ == '__main__':
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\nShutting down...")
        exit(0)
    except Exception as e:
        print(f"Fatal error: {e}")
        import traceback
        traceback.print_exc()
        exit(1)
