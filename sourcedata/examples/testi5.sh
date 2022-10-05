#!/usr/bin/bash
# testi5.sh
# Testataan ennen kisaa lahdeaineisto ennen kuin edes tulospalveluun on viety
# Radat Ocadista ja hajonta.csv on tehty hajonnat, joka luetaan vaikka Pirila-ohjelmaan
# testataan virherata hajonta V33 1. rasti on 32 eika kuten 33 pitaa olla

cp radat.v2.kenraali.virhe.xml ../lahdedata/radat.xml
cat  hajonta.kenraali.csv | tr -d '\015' > ../lahdedata/hajonta.csv
#cat  hajonta.kenraali.laaja.csv | tr -d '\015' > ../lahdedata/hajonta.csv
cd ..
./pohjatiedot.csv.sh
./tarkista.sh

ls -l tulos

echo "KEN.tarkitus.txt"
cat tulos/KEN.tarkistus.txt
