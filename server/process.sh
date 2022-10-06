#!/usr/bin/bash
# process.sh

courcefile=""
teamvariantfile=""
classfile=""
method=""
sourcedir=""
debug=0
while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		-d) debug="$2" ; shift ;;
		-p) sourcedir="$2" ; shift ;;
		-c) courcefile="$2" ; shift ;;
		-t) teamvariantfile="$2" ; shift ;;
		--class) classfile="$2" ; shift ;;
		-*) echo "option $arg ?" ;;
		*) break ;
	esac
	shift
done
(( debug > 0 )) && echo "Params $*"
(( debug > 0 )) && echo "Nice!"
(( debug > 0 )) && date


for inf in $*
do
	case "$inf" in
		*radat*.xml|*courses*.xml|*Courses*.xml) courcefile="$inf" ;;
		*varian*.txt|*Variations*.txt|*joukkuehajonna*.txt|*teamvarian*.txt)  teamvariantfile="$inf" ; method=ocad ;;
		*hajonta*.csv|*hajonta*.lst|*variant*.lst|*varian*.csv)  teamvariantfile="$inf" ; method=csv;;
		*pirila*.xml)  teamvariantfile="$inf" ; method=pirila ;;
	esac
done
((debug>0)) && echo "sourcedir  :$sourcedir"
((debug>0)) && echo "course     :$courcefile"
((debug>0)) && echo "teamvariant:$teamvariantfile"
((debug>0)) && echo "method     :$method"

linestr="____________________________________________________________________"
echo "
Check Variants Results - Hajonnat tarkistus tulos:
$linestr
"
set +m;shopt -s lastpipe
../check.variants.sh -c "$sourcedir/$courcefile" -t "$sourcedir/$teamvariantfile" -m "$method" 2>/dev/null | \
while read key line
do
        ((debug>0)) && echo "* $key $line" >&2
        dir="$line"
done #</dev/stdin
#echo "$dir"

tmpf="$sourcedir/$$.tmp"
for inf in "$dir"/check*csv
do
	[ "$inf" = "$dir/check*csv" ] && continue
	onlyfilename="${inf##*/}"
        echo " - $onlyfilename"
done


echo "" > "$tmpf"

if [ "$method" = "ocad" ] ; then # - print out hajonta.lst (Pirila variant format)
	varf="$dir/hajonta.lst"
	echo "hajonta.lst:"
	echo "$linestr"
	[ -f "$varf" ] && cat "$varf"
fi

echo "$linestr"
for inf in "$dir"/*.check.txt
do
	[ "$inf" = "$dir/*.check.txt" ] && continue
	onlyfilename="${inf##*/}"
	echo "*${onlyfilename}*" >> "$tmpf"
	cat "$inf" >> "$tmpf"
done
cat "$tmpf"
sleep 1
rm -f "$tmpf" 2>/dev/null
echo "$linestr"
	
	

