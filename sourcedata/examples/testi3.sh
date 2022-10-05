#!/usr/bin/bash
# testi3.sh
# Testataan ennen kisaa tuottaen data Pirila-ohjelmasta
# radat.xml ratatiedot
# pirilasta.xml kilpailun kaikki tiedot XML muodossa Pirila-ohjelmasta
# Ratatiedot IOF 3.0 versio

cp radat.v3.kenraali.xml ../lahdedata/radat.xml
cp pirilasta.kenraali.xml ../lahdedata/pirilasta.xml
cd ..
./pohjatiedot.pirila.sh
./tarkista.sh

ls -l tulos

echo "KEN.tarkitus.txt"
cat tulos/KEN.tarkistus.txt
