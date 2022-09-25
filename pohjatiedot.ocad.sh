#!/usr/bin/bash
# pohjatiedot.ocad.sh
# v. 2022-09-25
# tuottaa tarvittavat pohjatiedot kilpailija- ja ratatiedoista, jotta voidaan tehda hajontatarkistus
# Kaytetaan Ocad ratatiedostoa ja joukkuehajonnat Ocad:stä
#

########################################################################
# - poistaa tekstitiedostosta UTF-8 magic merkinnan ja DOS rivinvaihdon
rmbom()
{
        [ "$1" = "" ] && echo "usage:$0 infile" >&2 && exit 1
        inf="$1"
	mkdir -p tmp
        tf=tmp/bom.$$.tmp
        sed -e '1s/^\xef\xbb\xbf//' "$inf" | tr -d '\015' > "$tf"
        cat "$tf" > "$inf"
        rm -f "$tf" 2>/dev/null
}

########################################################################
mkdir -p tmp tulos 2>/dev/null
rm -f tulos/*.tarkistus*.csv tulos/*.tarkistus*.txt tulos/hajonta.csv tmp/*.tmp 2>/dev/null
lahde=lahdedata/joukkuehajonnat.txt
lahderata=lahdedata/radat.xml

versiostr=$(grep 'iofVersion="3.0"' "$lahderata" 2>/dev/null)
[ "$versiostr" = "" ] && echo "oltava IOF 3.0 versio" && exit 1

rmbom "$lahde"

# toimii vain IOF 3.0 - ei toimi, XML ei sisalla sarjan nimia ...
#gawk -f get.data.awk "$lahderata" | gawk -f get.radat.ocad.awk > tulos/tarkistus.radat.csv
gawk -f get.sarjat.ocad.awk "$lahde" > tulos/tarkistus.sarjat.csv

# joukkueet
# - tehdaan pirilaformaatti !!! - voi hyodyntaa Pirilassa
gawk -f get.joukkueet.ocad.awk "$lahde" > tulos/hajonta.csv
# ja siita tutusti jatketaan
gawk -f get.joukkueet.csv.awk "tulos/hajonta.csv" > tulos/tarkistus.joukkueet.csv

# hajonnat
# toimii iof 2.0.3 ja iof 3.0
#gawk -f get.data.awk "$lahderata" | gawk -f get.hajonnat.awk > tulos/tarkistus.hajonnat.csv

# rastivalit
# eri versio iof 2.0.3 ja 3.0
versio=2  # oletus
versiostr=$(grep 'iofVersion="3.0"' "$lahderata" 2>/dev/null)
[ "$versiostr" != "" ] && versio=3
case "$versio" in
	2)
	  gawk -f get.data.awk "$lahderata" | awk -f get.rastit.iof2.awk > tulos/tarkistus.rastit.csv
	  ;;
	3)
	  gawk -f get.data.awk "$lahderata" | awk -f get.rastit.iof3.awk > tulos/tarkistus.rastit.csv
	  ;;
esac

echo "Tehty tulos/hajonta.csv valituloksena - Pirila-formaatti"
