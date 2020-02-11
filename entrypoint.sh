#!/bin/bash
set -e

NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'

# Add username/repository as $1 and pullrequest number as $2
URL="https://api.github.com/repos/$1/pulls/$2"
STATUSCODE=$(curl -sL -w "%{http_code}" -I "$URL" -o /dev/null)

if [ "$STATUSCODE" != "200" ] 
then
    echo -e "$RED Url returned a statuscode $STATUSCODE, please check if the url is valid: \n$NC $URL"
    exit 1
fi

MERGABLE=$(curl -s -X GET -G "$URL" | jq -r '.mergeable')

if [ "$MERGABLE" == true ]
then
    echo -e "$GREEN This pullrequest is mergable $NC"  
    echo ::set-output name=result::"$MERGABLE"
else
    echo -e "$RED This pullrequest isn't mergable $NC"
    echo ::set-output name=result::"$MERGABLE"
fi