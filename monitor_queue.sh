#!/bin/bash

# 🚀 Enable TEST_MODE=true to force Sidekiq restart for testing
TEST_MODE=false

# Set the queue threshold
THRESHOLD=300

# Function to get the total Sidekiq queue size
get_queue_size() {
    local total=0
    for queue in $(redis-cli -n 0 smembers queues); do
        total=$((total + $(redis-cli -n 0 llen queue:$queue)))
    done
    echo $total
}

# Function to check if Sidekiq workers are busy
get_busy_workers() {
    local busy=0
    for process in $(redis-cli -n 0 keys israfel:*); do
        busy=$((busy + $(redis-cli -n 0 hget $process busy)))
    done
    echo $busy
}

# Function to restart Sidekiq
restart_sidekiq() {
    echo "$(date): Restarting Revospring..." | systemd-cat -t sidekiq-monitor
    
    systemctl restart retrospring

    echo "$(date): Revospring restarted." | systemd-cat -t sidekiq-monitor
}

# 🚀 If TEST_MODE is enabled, restart Sidekiq immediately
if [[ "$TEST_MODE" == "true" ]]; then
    echo "$(date): TEST_MODE is enabled. Restarting Sidekiq..." | systemd-cat -t sidekiq-monitor
    restart_sidekiq
    exit 0
fi

# Monitor the queue size and busy workers
while true; do
    QUEUE_SIZE=$(get_queue_size)
    BUSY_WORKERS=$(get_busy_workers)

    # Log the current status to systemd journal
    echo "$(date) | Queue Size: $QUEUE_SIZE | Busy Workers: $BUSY_WORKERS" | systemd-cat -t sidekiq-monitor

    if [[ "$QUEUE_SIZE" -gt "$THRESHOLD" && "$BUSY_WORKERS" -eq 0 ]]; then
        restart_sidekiq
    fi

    sleep 300  # Check every 300 seconds
done
