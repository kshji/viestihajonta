#!/usr/bin/bash
# pohjatiedot.pirila.sh
# tuottaa tarvittavat pohjatiedot kilpailija- ja ratatiedoista, jotta voidaan tehda hajontatarkistus
# Kaytetaan Pirila-ohjelmasta tehtyja radat.xml ja pirilasta.xml
#
lahde=lahdedata/pirilasta.xml
lahderata=lahdedata/radat.xml

mkdir -p tmp tulos 2>/dev/null
rm -f tulos/*.tarkistus*.csv tulos/*.tarkistus*.txt tmp/*.tmp 2>/dev/null

#gawk -f get.data.awk "$lahde" > tulos/pirilasta_xmlpath.txt

gawk -f  get.data.awk "$lahde" | gawk -f get.sarjat.awk > tulos/tarkistus.sarjat.csv

# joukkueet
# D16|1690|1|1J4
gawk -f get.data.awk "$lahde" | gawk -f get.joukkueet.awk > tulos/tarkistus.joukkueet.csv

# hajonnat
# toimii iof 2.0.3 ja iof 3.0
gawk -f  get.data.awk "$lahderata" | gawk -f get.hajonnat.awk > tulos/tarkistus.hajonnat.csv

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

