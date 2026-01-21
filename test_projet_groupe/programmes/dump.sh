#!/usr/bin/bash

FICHIER_URLS="../urls/langfr.txt"
DUMP="../dumps"

num=1

while read -r line
do

fichier_dump="$DUMP/$num.txt"
	lynx -dump -nolist "$fichier_dump" > "$fichier_dump"


((num++))
done < "$FICHIER_URLS"
