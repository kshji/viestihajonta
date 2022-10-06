#!/usr/bin/bash
# testi2.sh
# Testataan ennen kisaa tuottaen data Pirila-ohjelmasta
# radat.xml ratatiedot
# pirilasta.xml kilpailun kaikki tiedot XML muodossa Pirila-ohjelmasta

mkdir -p tmp
set +m;shopt -s lastpipe
../../check.variants.sh -c radat.v2.kenraali.xml -t pirilasta.kenraali.xml -m pirila | \
while read key line
do
        echo "* $key $line" >&2
        dir="$line"
done #</dev/stdin
echo "$dir"
ls -l "$dir"
echo "$dir/KEN.check.txt"
cat "$dir/KEN.check.txt"


