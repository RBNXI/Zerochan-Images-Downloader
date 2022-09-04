#!/bin/bash



if [[ -f "./lastdate.txt" ]]
then
lastuse=$(cat "./lastdate.txt")
else
lastuse="$(date +%Y-%m-%d -d "last week")"
fi

echo "$lastuse"

