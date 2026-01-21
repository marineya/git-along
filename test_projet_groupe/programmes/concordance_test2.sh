#!/usr/bin/bash

CHEM_CONTEXTE=$1
CHEM_CONCORDANCE=$2

if [ $# -ne 2 ]
then
	echo "Le script attend exactement 2 arguments"
	exit 1
fi

num=1


for chaque_fichier in "$CHEM_CONTEXTE"/*.txt; do
    fichier_sortie_concordance="$CHEM_CONCORDANCE/langfr-$num.html"

echo -e "
<html>
    <head>
        <meta charset=\"UTF-8\">
    </head>
    <body>
        <table>
            <tr>
            <th>contexte gauche</th>
            <th>Mot</th>
            <th>contexte droite</th>
            </tr>" >> "$fichier_sortie_concordance"

 phrase_image=$(grep -i '\bimage\b' "$chaque_fichier")

while read -r phrase_context; do

    mot=$(echo "$phrase_context" | grep -o -i -E '\bimage\b' | head -n 1)

    contexte_gauche=$(echo "$phrase_context" | sed -E 's/(.*)\bimage\b.*/\1/I')
    contexte_droit=$(echo "$phrase_context" | sed -E 's/.*\bimage\b(.*)/\1/I')

        echo "<tr>
                <td>$contexte_gauche</td>
                <td>$mot</td>
                <td>$contexte_droit</td>
              </tr>" >> "$fichier_sortie_concordance"

done <<< "$phrase_image"


echo -e "
    </table>
</body>
</html>" >> "$fichier_sortie_concordance"

 num=$((num + 1))
done
 # exécuter avec : ./test_concordance.sh ../dumps-text ../concordances
