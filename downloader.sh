#!/bin/bash
# 2018 Beerware Licence, written by Roman Dobias

# Arguments:
#   1: == mp3 -> download lectures as mp3



if [ "$1" = "mp3" ]; then
# TODO
false;
fi

if [ ! -e downloadQueue ]; then

    echo "There is no downloadQueue -> nothing to do here."
    exit 1
fi

while [ "`wc downloadQueue --lines`" != "0" ]; do

    echo "`wc downloadQueue --lines`"
    #1. get top file
    TOPFILE=`head -n1< downloadQueue`
    #2. download

    echo "Downloading another file with ID: $TOPFILE"
    
    TMPHEADER=`mktemp`
    while true; do
        
        ./login.sh


        #Get URL with server 
        URL=`curl -b login-cookie -L -k https://video1.fit.vutbr.cz/av/records.php?id=$TOPFILE | grep -a -Po 'href="\K[^"]*' | grep "video" | grep "/av/record" | grep -v "mp3"`

        echo "URL $URL"
        if [ "$URL" = "" ]; then
            break;
        fi

        #Get it
        # Note:
        #   -O saves the output into file, given by URL
        #   -J makes sure the output name is extracted from Content-Disposition
        #   -D dumps HTTP header -> the only way to find out if we were successful
        curl -O -J -b login-cookie -L -k $URL -D "$TMPHEADER"

        # Check if video was received
        if [ "`grep "video" < "$TMPHEADER"`" != "" ]; then
            break;
        else
            # sleep for 10 minutes and then try it again 
            sleep 600;
        fi
    done


    #3 erase the first line (thus erase the first downloaded lecture)
    NEWFILE=`tail -n +2 < downloadQueue`
    if [ "$NEWFILE" = "" ]; then
        rm -f downloadQueue
        exit 0
    fi
    echo "$NEWFILE" > downloadQueue

done

exit 0
