#!/bin/bash

function zerochan-dl-zero () {
link=$1
#Take all images
getalllinks "$link"
#date of each image
imagedate=""
Field_Separator=$IFS
IFS='|'
read -ra ARR <<< "$alllinks"
for line in "${ARR[@]}"
do
web_line=""
imagedate=""
stop=0
while [[ -z "$imagedate" ]] || [[ "$imagedate" == *"invalid"* ]] && [[ "$stop" -ne 1 ]]
do
sleep 0.01
  cont=$((cont + 1))
  if [ "$cont" -gt 300 ]
  then
  echo "########TIMEOUT########"
  cont=0
  stop=1
  fi
  web_line=$(curl -s "$line")
  if [[ "$web_line" == *"try 'curl --help' for more information"* ]] || [[ -z "$web_line" ]]
  then
  echo "NO IMAGES IN THIS TAG"
  stop=1
  fi
  if [[ "$web_line" != *"503 Service Temporarily Unavailable"* ]]
  then
  getdate "$web_line"
  fi

done

  if [[ "$(date -d "$lastweek" +%s)" -le "$(date -d "$imagedate" +%s)" ]] && [[ "$imagedate" != "" ]] && [[ "$stop" -ne 1 ]]
  then 
    getfullsize "$web_line"
    wget -nv "$fullsize" -O "/tmp/zerochandownloadertempimages/$(basename $fullsize)"
    sum=$(md5sum "/tmp/zerochandownloadertempimages/$(basename $fullsize)")
    newname=$(echo "${sum%% *}.${entry##*.}")
    name=$(basename $fullsize)
    extension="${name##*.}"
    mkdir "/$HOME/zerochandownloaderimages"
    mv "/tmp/zerochandownloadertempimages/$name" "/$HOME/zerochandownloaderimages/$newname$extension"
    echo ""
    echo "-----------"
    echo "Downloaded image: /$HOME/zerochandownloaderimages/$newname$extension"
    echo "-----------"
    echo ""
  fi
  stop=0
done
IFS=$Field_Separator


   
  

}

function getdate () {
web1=$1
datenoformat=""
imagedate=""

datenoformat="$(echo "$web1" | grep "datePublished" | cut -d'"' -f4-4)"

if [[ -z "$datenoformat" ]]
then 
echo "NO IMAGES IN THIS TAG?"
else
imagedate="$(date -d "$datenoformat" +%Y-%m-%d)"
fi

}


function getfullsize () {
web2=$1
fullsize=""
sleep 0.01
fullsize="$(echo "$web2" | grep "fullsizeUrl" | cut -d'=' -f2-2 | cut -d';' -f1-1 | cut -c3- | rev | cut -c2- | rev)"

  

}


function getalllinks () {
taglink=$1
echo ""
echo "###################################"
echo "Searching in $taglink"
echo ""
links=""
alllinks=""
cont=0
stop=0
while [ -z "$links" ] && [[ "$stop" -ne 1 ]]
do
sleep 0.01
  cont=$((cont + 1))
  if [ "$cont" -gt 300 ]
  then
  echo "########TIMEOUT########"
  cont=0
  stop=1
  fi
  links="$(curl -s "$taglink" | grep "a href=\"/" | grep "tabindex=\"1\"" | cut -d'"' -f2-2)"

done
    

while IFS= read -r line; do
if  [[ "$stop" -ne 1 ]]
then
    alllinks+="https://www.zerochan.net$line|"
fi
done <<< "$links"
stop=0
}


function getallfullsize () {
getalllinks $1
allfullsize=""
Field_Separator=$IFS
IFS='|'
read -ra ARR <<< "$alllinks"
for line in "${ARR[@]}"
do
    getfullsize "$line"
    allfullsize+="$fullsize|"
done
IFS=$Field_Separator
}

################# Start
ping="$(ping www.zerochan.net -w 5 | tail -2 | head -1 | cut -d',' -f3-3 | cut -d'%' -f1-1 | cut -d' ' -f2-2)"
if [ "$ping" -gt 90 ]
then
echo "Zerochan is down..."
exit
fi
mkdir "/tmp/zerochandownloadertempimages"

lastweek=$("./lastdate.sh")
echo "Using $lastweek as last date"
#today="$(date +%Y-%m-%d -d "today")"
echo "" | tr -d "\n" > "./Tabszerochan.txt"

while read -d ' ' -r line
do
if [ "$line" != "" ]
then
  \cp "./urlzerochan.txt" "/tmp/urlzerochan.txt"
     
  sed -i "s/1girl/$line/g" "/tmp/urlzerochan.txt"
    cat "/tmp/urlzerochan.txt" >> "./Tabszerochan.txt"

fi
done < "./tagszerochan.txt"

tagstotal=$(cat "./tagszerochan.txt" | wc -w) 
 

while read line
do  
if [ "$line" != "" ]
then
 zerochan-dl-zero "$line"
 conttotal=$((conttotal+1))
 echo "Tags procesados: $conttotal/$tagstotal"
fi
done < "./Tabszerochan.txt"
 
  echo "Ended the next tags:"
  cat "./Tabszerochan.txt"
  
echo "" | tr -d "\n" > "./Tabszerochan.txt"

today="$(date +%Y-%m-%d -d "today")"
echo "$today" > "./lastdate.txt"
echo "UPDATED LAST USED DATE TO: $(cat "./lastdate.txt")"

echo "All images downloaded in /$HOME/zerochandownloaderimages"

rm -r "/tmp/zerochandownloadertempimages"



