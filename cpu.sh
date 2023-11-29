#!/bin/bash

checkCPU (){
    free_cpu=($(top | head  -n 4 | grep "idle"))
    arr_size="${#free_cpu[@]}" # Index of the idle
    free_cpu=$(echo ${free_cpu[$arr_size - 2]} | sed "s/%/ /") # Get the idle percentage and replace "%" with " " sign
    CPU_USAGE=$(echo "scale=2;100-$free_cpu" | bc) 
}

sendMessage(){
    TELEGRAM_API_KEY="6893153187:AAHTOgFzWqW8q8igtYeCGuWvIIbKo3bXo88"
    CHAT_ID="900202092"
    CPU_MESSAGE="CPU usage on server is above $CPU_THRESHOLD%. Now at $CPU_USAGE%"
    # Use curl to send a message to your Telegram bot
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_API_KEY/sendMessage" -d "chat_id=$CHAT_ID" -d "text=$CPU_MESSAGE"
}

CPU_THRESHOLD=10.0

declare -i warning=0


while [ $warning -lt 5 ]; do
    checkCPU

    # Use awk for floating-point comparison
    if [ "$(awk 'BEGIN{print ('$CPU_USAGE' > '$CPU_THRESHOLD')}')" -eq 0 ]; then
        warning=0  # Reset the warning counter if CPU usage is below the threshold
    else
    ((warning++))
    fi
    
    if [ $warning -eq 5 ]; then
        sendMessage
    fi
    echo $warning
    sleep 1
done
