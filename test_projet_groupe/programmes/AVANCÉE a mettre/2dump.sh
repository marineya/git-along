#!/usr/bin/bash

if [ $# -ne 5 ]
then
	echo "Le script attend exactement un argument"
	exit 1
fi

FICHIER_URLS=$1
FICHIER_TSV=$2
FICHIER_HTML=$3
ASPIRATION=$4
DUMP=$5

lineno=1

#https://bulma.io/documentation/start/overview/
echo "<!DOCTYPE html>
<html>
	<head>
		<meta charset=\"UTF-8\">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@1.0.4/css/bulma.min.css">
	</head>
	<body>
	  <h1>Tableau des URLS pour la langue française</h1>
		<style>
			 h1{
				color: hsl(217, 71%, 53%);
				font-size: 2.5rem;
				}
		</style>
		<table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
			<tr>
				<th>numero</th>
				<th>URL</th>
				<th>code</th>
				<th>encodage</th>
				<th>nombre de mots</th>
				<th>aspirations</th>
				<th>dumps</th>
			</tr>" >> "$FICHIER_HTML"

while read -r line
do
	data=$(curl -s -i -L -w "%{http_code}\n%{content_type}" -o /dev/null "$line")
	http_code=$(echo "$data" | head -1)
	encoding=$(echo "$data" | tail -1 | grep -Po "charset=\S+" | cut -d"=" -f2)

	fichier_aspiration="$ASPIRATION/$lineno.html"
		curl -sL "$line" -o "$fichier_aspiration"


	fichier_dump="$DUMP/$lineno.txt"
		lynx -dump -nolist "$fichier_aspiration" > "$fichier_dump"


	if [ -z "${encoding}" ]
	then
		encoding="N/A"
    fi
	nbmots=$(curl -s -L "$line" | wc -w)

	echo -e "
            <tr>
				<td>$lineno</td>
				<td>$line</td>
				<td>$http_code</td>
				<td>$encoding</td>
				<td>$nbmots</td>
				<td><a href="$fichier_aspiration">Aspiration</a></td>
				<td><a href="$fichier_dump">Dump</a></td>
			</tr>">> "$FICHIER_HTML"

	lineno=$(expr $lineno + 1)

echo -e "$lineno\t$line\t$http_code\t$encoding\t$nbmots\t$fichier_aspiration\t$fichier_dump" >> "$FICHIER_TSV"

done < "$FICHIER_URLS"

echo -e "</table>
	</body>
</html>" >> "$FICHIER_HTML"

#excécuter avec : ./code2.sh ../urls/langfr.txt ../tableaux/fr.tsv ../tableaux/fr.html ../aspirations/aspiration-fr ../dumps/dump-fr

