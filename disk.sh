#!/bin/bash

DISK_THRESHOLD=0.0

DISK_USAGE=$(df -h / | awk 'NR==2 {sub(/%$/,"",$5); print $5}')

TELEGRAM_API_KEY="6893153187:AAHTOgFzWqW8q8igtYeCGuWvIIbKo3bXo88"
CHAT_ID="900202092"
# Check if disk usage exceeds the threshold
if (( $(echo "$DISK_USAGE >= $DISK_THRESHOLD" | bc -l) )); then
    DISK_MESSAGE="Disk space usage on server is above $DISK_THRESHOLD%."
    echo $DISK_MESSAGE
    # Use curl to send a message to your Telegram bot
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_API_KEY/sendMessage" -d "chat_id=$CHAT_ID" -d "text=$DISK_MESSAGE"
fi