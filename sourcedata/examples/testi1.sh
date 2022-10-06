#!/usr/bin/bash
# testi1.sh
# Testataan ennen kisaa lahdeaineisto ennen kuin edes tulospalveluun on viety
# Radat Ocadista ja hajonta.csv on tehty hajonnat, joka luetaan vaikka Pirila-ohjelmaan

mkdir -p tmp
set +m;shopt -s lastpipe
../../check.variants.sh -c radat.v2.kenraali.xml -t hajonta.kenraali.csv -m csv | \
while read key line
do
	echo "* $key $line" >&2
	dir="$line"
done #</dev/stdin
echo "$dir"
ls -l "$dir"
echo "$dir/KEN.check.txt"
cat "$dir/KEN.check.txt"
