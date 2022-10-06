#!/usr/bin/bash
# testi7.sh
# Testataan aineisto, joka on valmiiksi taman jarjestelman formaatissa

mkdir -p tmp
set +m;shopt -s lastpipe
../../check.variants.sh -c ../genericformat/check.controls.csv -t ../genericformat/check.teams.csv --classfile ../genericformat/check.class.csv -m raw | \
while read key line
do
        echo "* $key $line" >&2
        dir="$line"
done #</dev/stdin
echo "$dir"
ls -l "$dir"
echo "$dir/KEN.check.txt"
cat "$dir/KEN.check.txt"
