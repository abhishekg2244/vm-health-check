#!/bin/bash

# Script to monitor CPU, Memory, and Disk Usage
# Usage: ./vm-health-check.sh [--explain]

THRESHOLD=80

function check_cpu() {
    CPU_USAGE=
    top -bn1 | grep "Cpu(s)" | sed "" s/.*, *\([0-9.]*\)%* id.*/\1/ | awk '{print 100 - $1}'
    echo "CPU Usage: $CPU_USAGE%"
    if (( $(echo "$CPU_USAGE > $THRESHOLD" | bc -l) )); then
        echo "Warning: CPU usage is above $THRESHOLD%!"
    fi
}

function check_memory() {
    MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    echo "Memory Usage: $MEM_USAGE%"
    if (( $(echo "$MEM_USAGE > $THRESHOLD" | bc -l) )); then
        echo "Warning: Memory usage is above $THRESHOLD%!"
    fi
}

function check_disk() {
    DISK_USAGE=$(df -h | grep /dev/sda1 | awk '{ print $5 }' | sed 's/%//g')
    echo "Disk Usage: $DISK_USAGE%"
    if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
        echo "Warning: Disk usage is above $THRESHOLD%!"
    fi
}

function explain() {
    echo "This script checks CPU, memory, and disk usage thresholds."
    echo "If the usage exceeds $THRESHOLD%, it provides a warning to take action."
    echo "
Recommendations:"
    echo "1. For high CPU usage, consider optimizing running processes."
    echo "2. For high Memory usage, check for unused applications or processes."
    echo "3. For Disk usage, consider cleaning up files or expanding storage capacity."
}

if [[ "$1" == "--explain" ]]; then
    explain
else
    check_cpu
    check_memory
    check_disk
fi
