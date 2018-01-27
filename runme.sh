#!/bin/bash
# 2018 Beerware Licence, written by Roman Dobias

# The main script

# If this is the first time the script is run
if [ -e "login-cookie" ]; then
    false;
else
    #Then show welcome message
    whiptail --title "Welcome" --textbox "WELCOME" 20 78 --scrolltext --defaultno
fi

# Make sure user is logged in
./login.sh

# Show him menu
while true; do
    QUEUE_LENGTH=0
    if [ -e downloadQueue ]; then
        QUEUE_LENGTH=`wc downloadQueue --lines`
    fi
    
    RECORD=$(whiptail --title "Lecture Downloader @ FIT VUTBR" --menu "What do you want ? There $QUEUE_LENGTH items in queue currently." 15 48 5 \
    "1" "Select lectures to download" \
    "2" "Start downloading (VIDEO)." \
    "2" "Start downloading (MP3)." \
    "3" "Exit." \
    3>&1 1>&2 2>&3) 


    case $RECORD in
        "1" )
            ./parseInfo.sh
            ;;
        "2" )
            ;;
        "3" )
            echo "Bye bye"
            exit 0
            ;;
    esac
done
