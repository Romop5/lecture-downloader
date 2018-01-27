#!/bin/bash
# 2018 Beerware Licence, written by Roman Dobias
# This provides automated authentification to access limited-access records

# Arguments:
#   toggle parts


# Use login at first
#./login.sh

#------------------------------------------------------------------------------
#   Download the list of school years/terms and let user choose one
#------------------------------------------------------------------------------

YEARS=`curl -sS -i -L -k -b login-cookie https://video1.fit.vutbr.cz/av/records-categ.php?id=1 | iconv -f ISO-8859-2 -t UTF-8 | grep "<li "  | sed 's/.*id=\([0-9]*\) class.*>\(.*\)<\/a>.*/"\1" "\2"/' | tr '\n' ' '`

OPTION=$(echo "$YEARS" | xargs whiptail --title "Choose the year: " --notags --menu "Choose streaming year" 25 78 16 3>&1 1>&2 2>&3) 

#echo $OPTION


#------------------------------------------------------------------------------
#   Download the list of subjects in given term and let him choose one
#------------------------------------------------------------------------------

# Get list of years
SUBJECTS=`curl -sS -i -L -k -b login-cookie https://video1.fit.vutbr.cz/av/records-categ.php?id=$OPTION | iconv -f ISO-8859-2 -t UTF-8 | grep "<li "  | sed 's/.*id=\([0-9]*\) class.*>\(.*\)<\/a>.*/"\1" "\2"/' | tr '\n' ' '`

SUBJECT=$(echo "$SUBJECTS" | xargs whiptail --title "Choose the subject: " --notags --menu "Choose streaming year" 25 78 16 3>&1 1>&2 2>&3) 

# Toggle default ON/OFF
TOGGLE="ON"

# Get list of records 
RECORDS=`curl -sS -i -L -k -b login-cookie https://video1.fit.vutbr.cz/av/records-categ.php?id=$SUBJECT| iconv -f ISO-8859-2 -t UTF-8 | grep "<li "  | sed "s/<\/b><\/a><div style=\"margin-left: 20px\">/ /" | sed "s/.*id=\(.*\)&.*<b>\(.*\)<\/div>.*/'\1' '\2' '$TOGGLE'/"`

#TODO - disable / remove already queued / downloaded lectures


RECORD=$(echo "$RECORDS" | xargs whiptail --title "Choose which records you wanna download: " --separate-output --notags --checklist "Choose streaming year" 25 78 16 3>&1 1>&2 2>&3) 


#------------------------------------------------------------------------------
#   Append lectures to queue
#------------------------------------------------------------------------------
LIST=`echo "$RECORD" | tr ' ' '\n'`
echo "$LIST" >> downloadQueue 
# Take care of duplicates
TMP=`cat downloadQueue | sort |uniq`
echo "$TMP" > downloadQueue 

