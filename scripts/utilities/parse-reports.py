#!/usr/bin/env python3

"""
Parse daily reports and extract metrics for dashboard visualization.
Creates a JSON file with historical data for charting.
"""

import os
import json
import re
from pathlib import Path
from datetime import datetime

def extract_metrics(report_path):
    """Extract metrics from a report file."""
    try:
        with open(report_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except:
        return None
    
    # Remove ANSI color codes
    content_clean = re.sub(r'\x1b\[[0-9;]*m', '', content)
    
    metrics = {}
    
    # Extract timestamp from filename
    filename = os.path.basename(report_path)
    match = re.search(r'report_(\d{4})-(\d{2})-(\d{2})_(\d{2})-(\d{2})-(\d{2})', filename)
    if match:
        y, m, d, h, min, s = match.groups()
        metrics['timestamp'] = f"{y}-{m}-{d}T{h}:{min}:{s}"
        metrics['date'] = f"{y}-{m}-{d}"
        metrics['time'] = f"{h}:{min}"
    else:
        return None
    
    # Extract Memory Usage - new format from top
    # Format: "PhysMem: 50G used (13G wired, 0B compressor), 13G unused."
    # Calculate percentage based on wired memory (what's actually in use)
    memory_match = re.search(r'PhysMem:\s+(\d+)G used \((\d+)G wired', content_clean)
    if memory_match:
        wired_gb = int(memory_match.group(2))
        # Assume 64GB total (can be made dynamic if needed)
        total_gb = 64
        metrics['memory'] = int((wired_gb * 100) / total_gb)
    else:
        # Fallback for old format: "Used: 63GB / 64GB (98%)"
        old_memory_match = re.search(r'Used:.*\((\d+)%\)', content_clean)
        if old_memory_match:
            # For old format, only count about 20% of what was reported
            # since it included cache
            reported = int(old_memory_match.group(1))
            metrics['memory'] = max(int(reported * 0.2), 0)
        else:
            metrics['memory'] = 0
    
    # Extract Disk Usage (from "51% used" line)
    disk_match = re.search(r'Disk Usage[^:]*:\s+(\d+)%', content_clean)
    if disk_match:
        metrics['disk'] = int(disk_match.group(1))
    else:
        metrics['disk'] = 0
    
    # Extract Battery (from "Battery: 100%" line)
    battery_match = re.search(r'Battery:\s+(\d+)%', content_clean)
    if battery_match:
        metrics['battery'] = int(battery_match.group(1))
    else:
        metrics['battery'] = 100
    
    # Extract CPU Load (first number from "load averages: 4.03 3.91 3.59")
    cpu_load_match = re.search(r'load averages:\s+([0-9.]+)', content_clean)
    if cpu_load_match:
        try:
            metrics['cpu_load'] = float(cpu_load_match.group(1))
        except:
            metrics['cpu_load'] = 0
    else:
        metrics['cpu_load'] = 0
    
    # Extract actual CPU usage percentage (from "CPU usage: 13.11% user, 9.32% sys, 77.55% idle")
    cpu_usage_match = re.search(r'CPU usage:\s+([0-9.]+)%\s+user,\s+([0-9.]+)%\s+sys', content_clean)
    if cpu_usage_match:
        try:
            user_cpu = float(cpu_usage_match.group(1))
            sys_cpu = float(cpu_usage_match.group(2))
            metrics['cpu_percent'] = round(user_cpu + sys_cpu, 2)
        except:
            metrics['cpu_percent'] = 0
    else:
        metrics['cpu_percent'] = 0
    
    # Count running apps (lines starting with ✓)
    running_apps = len(re.findall(r'^\s*✓', content_clean, re.MULTILINE))
    metrics['running_apps'] = running_apps
    
    return metrics

def main():
    reports_dir = os.path.expanduser('~/.mac_daily_reports')
    data_file = os.path.join(reports_dir, 'dashboard-data.json')
    
    os.makedirs(reports_dir, exist_ok=True)
    
    print("Parsing reports...")
    
    # Find all report files
    report_files = sorted(Path(reports_dir).glob('report_*.txt'))
    
    reports = []
    for report_path in report_files:
        # Skip if file is too small (incomplete)
        if report_path.stat().st_size < 500:
            continue
        
        metrics = extract_metrics(str(report_path))
        if metrics:
            reports.append(metrics)
    
    # Create JSON output
    output = {
        'reports': reports,
        'generated_at': datetime.now().isoformat(),
        'total_reports': len(reports)
    }
    
    # Write to file
    with open(data_file, 'w') as f:
        json.dump(output, f, indent=2)
    
    print(f"✓ Parsed {len(reports)} reports into {data_file}")
    
    # Validate JSON
    try:
        with open(data_file, 'r') as f:
            json.load(f)
        print("✓ JSON validation passed")
    except json.JSONDecodeError as e:
        print(f"⚠ Warning: JSON validation failed: {e}")
        return 1
    
    return 0

if __name__ == '__main__':
    exit(main())
