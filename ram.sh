#!/bin/bash

sendMessage(){
    TELEGRAM_API_KEY="6893153187:AAHTOgFzWqW8q8igtYeCGuWvIIbKo3bXo88"
    CHAT_ID="900202092"
    RAM_MESSAGE="RAM usage on server is above $RAM_THRESHOLD%. Now at $RAM_USAGE%"
    # Use curl to send a message to your Telegram bot
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_API_KEY/sendMessage" -d "chat_id=$CHAT_ID" -d "text=$RAM_MESSAGE"
}

checkRAM(){
    TELEGRAM_API_KEY="6893153187:AAHTOgFzWqW8q8igtYeCGuWvIIbKo3bXo88"
    CHAT_ID="900202092"
    RAM_USAGE=$(top -l 1 -s 0 | grep PhysMem | awk 'BEGIN {S["G"]=1024; S["M"]=1} 
        /PhysMem:/ {U=substr($2, 1, length($2)-1) * S[substr($2, length($2))];
                    N=substr($6, 1, length($6)-1) * S[substr($6, length($6))];
                    printf("%.2f", U/(N+U)*100)}')

}

RAM_THRESHOLD=10.0
declare -i warning=0

while [ $warning -lt 5 ]; do
    checkRAM

    if (( $(echo "$RAM_USAGE >= $RAM_THRESHOLD" | bc -l) )); then
        ((warning++))
    else
        warning=0
    fi

    if [ $warning -eq 5 ]; then
        sendMessage
    fi
    echo $warning
    sleep 1
done