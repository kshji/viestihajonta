#!/usr/bin/bash
# testi6.sh
# Testataan ennen kisaa lahdeaineisto ennen kuin edes tulospalveluun on viety
# Radat Ocadista ja joukkuehajonnat

cp radat.ocad.v3.xml ../lahdedata/radat.xml
cp joukkuehajonnat.txt ../lahdedata/joukkuehajonnat.txt
cd ..
./pohjatiedot.ocad.sh
./tarkista.sh

ls -l tulos

echo "H.tarkitus.txt"
cat tulos/H.tarkistus.txt
echo "D.tarkitus.txt"
cat tulos/D.tarkistus.txt
