#!/usr/bin/bash
# tarkista.sh
# (c) Jukka Inkeri viestihajonta@awot.fi
# Versio: 2022-09-24
# 
# Tarkistetaan hajonnat rastivaleittain
#
# pohjatiedot tehtava ensin komennolla, jos Pirilan ohjlemasta tiedot haettu
#   ./pohjatiedot.pirila.sh
# pohjatiedot hajonta.csv ja radat Ocad:sta
#   ./pohjatiedot.csv.sh
#

# voi suorittaa yhdelle sarjalle tai kisan kaikille sarjoille
#
# Yksi sarja
# ./tarkista.sh H21
# Kaikki sarjat
# ./tarkista 

##########################################################################
tarkistus()
{
	xsarja="$1"
	xtied="$2"
	echo "Tarkistetaan $xsarja" >&2
	gawk -f tarkista.hajonnat.awk -v debug=0 -v rastitiedosto="$rastitiedosto" -v sarja="$xsarja" "$xtied"

}

##########################################################################
# PAAOHJELMA
##########################################################################

sarja="$1"
sarjat="tulos/tarkistus.sarjat.csv"
input="tulos/tarkistus.joukkueet.csv"
rastitiedosto="tulos/tarkistus.rastit.csv"


ok=1
for tied in "$sarjat"  "$input" "$rastitiedosto"
do
	[ -f "$tied" ] && continue

	echo "puuttuu $tied" 
	ok=0
done
((ok<1)) && echo "Lopetetaan, puutteita lahdeaineistossa" && exit 1

if [ "$sarja" != "" ] ; then # vain sarja koska ei ole tiedosto
	echo "vain sarja $sarja tarkistetaan"
	tarkistus "$sarja" "$input" > tulos/$sarja.tarkistus.txt
	echo "lopputulos kansiossa tulos" >&2
	exit 0
fi

# kaikki sarjat
echo "kaikki sarjat tarkistetaan"

while read sarja xstr
do
	tarkistus "$sarja" "$input" > tulos/$sarja.tarkistus.txt
done < "$sarjat"

echo "lopputulos kansiossa tulos" >&2

