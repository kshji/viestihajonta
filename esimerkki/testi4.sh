#!/usr/bin/bash
# testi4.sh
# Testataan ennen kisaa tuottaen data Pirila-ohjelmasta
# - radat.xml ratatiedot
# - pirilasta.xml kilpailun kaikki tiedot XML muodossa Pirila-ohjelmasta
# Ohessa esimerkki, kun on virhe. V33 hajonnassa on vaara 1. rasti, pitaa olla 33 eika 32.

cp radat.v2.kenraali.virhe.xml ../lahdedata/radat.xml
cp pirilasta.kenraali.xml ../lahdedata/pirilasta.xml
cd ..
./pohjatiedot.pirila.sh
./tarkista.sh

ls -l tulos

echo "KEN.tarkitus.txt"
cat tulos/KEN.tarkistus.txt
