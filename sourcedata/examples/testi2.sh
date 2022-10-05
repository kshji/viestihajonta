#!/usr/bin/bash
# testi2.sh
# Testataan ennen kisaa tuottaen data Pirila-ohjelmasta
# radat.cml ratatiedot
# pirilasta.xml kilpailun kaikki tiedot XML muodossa Pirila-ohjelmasta

cp radat.v2.kenraali.xml ../lahdedata/radat.xml
cp pirilasta.kenraali.xml ../lahdedata/pirilasta.xml
cd ..
./pohjatiedot.pirila.sh
./tarkista.sh

ls -l tulos

echo "KEN.tarkitus.txt"
cat tulos/KEN.tarkistus.txt
