#!/usr/bin/bash
# testi6.sh
# Testataan ennen kisaa lahdeaineisto ennen kuin edes tulospalveluun on viety
# Radat Ocadista ja joukkuehajonnat

mkdir -p tmp
set +m;shopt -s lastpipe
../../check.variants.sh -c radat.ocad.v3.xml -t joukkuehajonnat.txt -m ocad | \
while read key line
do
        echo "* $key $line" >&2
        dir="$line"
done #</dev/stdin
echo "$dir"
ls -l "$dir"
echo "$dir/H.check.txt"
cat "$dir/H.check.txt"
echo "$dir/D.check.txt"
cat "$dir/D.check.txt"
