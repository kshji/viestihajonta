#!/usr/bin/bash
# pohjatiedot.csv.sh
# v. 2022-09-25
# tuottaa tarvittavat pohjatiedot kilpailija- ja ratatiedoista, jotta voidaan tehda hajontatarkistus
# Kaytetaan Ocad tiedostoa ja hajonta.csv
#

mkdir -p tmp tulos 2>/dev/null
rm -f tulos/*.tarkistus*.csv tulos/*.tarkistus*.txt tulos/hajonta.csv tmp/*.tmp 2>/dev/null
lahde=lahdedata/hajonta.csv
lahderata=lahdedata/radat.xml

gawk -f  get.sarjat.csv.awk "$lahde" > tulos/tarkistus.sarjat.csv

# joukkueet
# D16|1690|1|1J4
gawk -f get.joukkueet.csv.awk "$lahde" > tulos/tarkistus.joukkueet.csv

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

