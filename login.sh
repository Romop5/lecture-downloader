#!/bin/bash
# 2018 Beerware Licence, written by Roman Dobias
# This provides automated authentification to access limited-access records

# Checkout if we are loggin in (and thus keyword Logout is there)
REQUIRED=`curl -L -sS -b login-cookie -k 'https://cas.fit.vutbr.cz/'| grep -ali "Logout"` 

if [ "$REQUIRED" ] ; then
    # okay, the session is still valid
    exit 0
fi

RESPONSE="Required"
# Keeps asking the password until the page doens't contain keyword Required
while [ -n "`echo $RESPONSE | grep 'Required'`" ]
do
    echo "Enter your credentials for CAS FIT VUT:"
    read -p "Login: " LOGIN
    read -s -p "Password: " PASS

    # Get Set-Cookie HTTP header and store it in 'cock'
    curl -o /dev/null -sS -c login-cookie -k 'https://cas.fit.vutbr.cz/' 

    RESPONSE=`curl -b login-cookie -sS -k 'https://cas.fit.vutbr.cz/cosign.cgi' -H 'Host: cas.fit.vutbr.cz' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Referer: https://cas.fit.vutbr.cz/' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data 'login='$LOGIN'&password='$PASS'&useKX509=0&doLogin=Log+In&required=&ref=&service='`

if [ -n "`echo $RESPONSE | grep 'Required'`" ]; then
echo "Try again..."
rm -f login-cookie
fi
done


echo "Logged successfully"
exit 0
