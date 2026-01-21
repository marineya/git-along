#!/usr/bin/bash

FICHIER_URLS="../urls/langfr.txt"
ASPIRATION="../aspirations"
DUMP="../dumps"

num=1

while read -r line; do
fichier_aspiration="$ASPIRATION/$num.html"

curl -sL "$line" -o "$fichier_aspiration"
	#usage de curl : https://blog.stephane-robert.info/docs/admin-serveurs/linux/curl/
	#curl : récupère une page web pour chaque ligne

fichier_dump="$DUMP/$num.txt"
	lynx -dump -nolist "$fichier_aspiration" > "$fichier_dump"

((num++))
done < "$FICHIER_URLS"

