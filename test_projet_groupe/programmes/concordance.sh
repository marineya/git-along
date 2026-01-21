#!/usr/bin/bash

CHEM_CONTEXTE=$1
CHEM_CONCORDANCE=$2
CHEMP_DUMP=$3

lineno=1

#for chaque_fichier in $CHEM_CONTEXTE/langfr-*.txt; do
  #  lineno=$(echo "$chaque_fichier" | sed -E 's/.*langfr-([0-50]+)\.txt/\1/')
#pour chaque fichier dans le dossier contexte, on veut garder que le numéro de chaque fichier contexte

#il faut chercher le mot "image" et afficher les contexte de droite et gauche qui entourent le mot "image".

#si la phrase contient le mot image on réccupère les mots avant et après le mot "image" grep n'est pas suissant pour séparer les mots donc = on utilsie sed
#on doit avoir une ER qui cherche tout ce qu'il y avant et après le mot cible : (.*)(image)(.*)


echo -e "
<html>
<head>
<meta charset='UTF-8'>
</head>
<body>
    <table>
        <tr>
        <th>Contexte gauche</th>
        <th>Mot</th>
        <th>Contexte droit</th>
        </tr>" >> "$CHEM_CONCORDANCE/concordance.html"

    #on créé une varaible qui doit avoir au moins la phrase avec le mot "image" donc :
    for chaque_fichier in "$CHEM_DUMP"; do
    lineno=$(echo "$chaque_fichier" | sed -E 's/.*langfr-([0-9]+)\.txt/\1/')


    autour_du_mot=$(grep -i -o -E '(\S+\s+){0,3}\bimage\b(\s+\S+){0,3}' $chaque_fichier)

        while read -r phrase; do
        contexte_gauche=$(echo "$phrase" | sed -E 's/(.*)\bimage\b.*/\1/')
        # Mot central
        center=$(echo "$phrase" | grep -o -i -E '\bimage\b')
        # 3 mots après
        contexte_droite=$(echo "$phrase" | sed -E 's/.*\bimage\b(.*)/\1/')

        done
    done


   # phrase_avec_mot=$(grep -i "\bimage\b" $CHEM_DUMP)

    # On prend chaque occurrence du mot image avec 3 mots avant/après
#while read -r phrase; do
    # Extraire gauche (3 mots avant)
   # contexte_gauche=$(echo "$phrase" | sed -E 's/(?:\S+\s+){0,3}\b(image)\b.*$/\1/')
    # Extraire le mot central (image)
   # center=$(echo "$phrase" | grep -o -i -E '\bimage\b')
    # Extraire droite (3 mots après)
   # contexte_droite=$(echo "$phrase" | sed -E 's/^.*\b(image)\b((\s+\S+){0,3}).*/\2/')

echo "</table></body></html>" >> "$CHEM_CONCORDANCE/concordance.html"

#echo -e"
#        <tr>
 #   <td>$contexte_gauche</td>
  #  <td>$center</td>
   # <td>$contexte_droite</td>
    #</tr>
    #</table>
    #</body></html>" >> "$CHEM_CONCORDANCE"



#contexte_fichier_sortie=$("$CHEM_CONTEXTE"/lang-fr$lineno.html")

#contexte_droite=$("$CHEM_CONTEXTE")

