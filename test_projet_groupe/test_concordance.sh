#!/usr/bin/bash
#fonctionne
CHEM_DUMPS=$1
CHEM_CONCORDANCE=$2

if [ $# -ne 2 ]
then
	echo "Le script attend exactement 2 arguments"
	exit 1
fi

num=1

for chaque_fichier in "$CHEM_DUMPS"/*.txt; do
    fichier_sortie_concordance="$CHEM_CONCORDANCE/langfr-$num.html"

echo -e "
<html>
    <head>
        <meta charset=\"UTF-8\">
        <meta name=viewport content=width=device-width, initial-scale=1>
		<link rel=stylesheet href=https://cdn.jsdelivr.net/npm/bulma@1.0.4/css/bulma.min.css>
    </head>
    <body>
        <table class=table is-bordered is-striped is-narrow is-hoverable is-fullwidth>
            <tr>
            <th>contexte gauche</th>
            <th>Mot</th>
            <th>contexte droite</th>
            </tr>" >> "$fichier_sortie_concordance"

phrase_image=$(egrep -i -o '([^.]*\bimage\b[^.]*)' "$chaque_fichier")


while read -r phrase_context; do
    if echo "$phrase_context" | grep -iq '\bimage\b'; then

        mot="image"

        contexte_gauche=$(echo "$phrase_context" | sed -E 's/(.*)\bimage\b.*/\1/I')
        contexte_droit=$(echo "$phrase_context" | sed -E 's/.*\bimage\b(.*)/\1/I')
        #command grep -E : use extended regular expressions in the script (for portability use POSIX -E).
        #regex : tout ce qui est avant le mot image et tout ce qui est après (qui est segementé), et on affiche ce qui vient avant et après le mot.
        echo "<tr>
                <td>$contexte_gauche</td>
                <td>$mot</td>
                <td>$contexte_droit</td>
            </tr>" >> "$fichier_sortie_concordance"
    fi

done < "$chaque_fichier"

echo -e "
    </table>
</body>
</html>" >> "$fichier_sortie_concordance"

 num=$((num + 1))

done
 # exécuter avec : ./test_concordance.sh ../dumps-text ../concordances
