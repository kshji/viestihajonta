#!/usr/bin/bash
# process.sh

courcefile=""
teamvariantfile=""
classfile=""
method=""
sourcedir=""
debug=0
pin=""
extended=""
while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		-d) debug="$2" ; shift ;;
		-i) pin="$2" ; shift ;;
		-e) extended="$2" ; shift ;;
		-p) sourcedir="$2" ; shift ;;
		-c) courcefile="$2" ; shift ;;
		-t) teamvariantfile="$2" ; shift ;;
		--class) classfile="$2" ; shift ;;
		-*) echo "option $arg ?" ;;
		*) break ;
	esac
	shift
done
(( debug > 8 )) && echo "Params $*"
(( debug > 8 )) && echo "Nice!"
(( debug > 8 )) && date
pin=${pin//[/}
pin=${pin//]/}
#echo "pin:<$pin>"


for inf in $*
do
	case "$inf" in
		*os.joukkue*) teamvariantfile="$inf" ; method=os.fi ;;
		*os.team*) teamvariantfile="$inf" ; courcefile="-"; method=os.en ;;
		*Radat*.xml|*radat*.xml|*courses*.xml|*Courses*.xml) courcefile="$inf" ;;
		*varian*.txt|*Variations*.txt|*variations*.txt|*joukkuehajonna*.txt|*teamvarian*.txt)  teamvariantfile="$inf" ; method=ocad ;;
		*hajonta*.csv|*hajonta*.lst|*variant*.lst|*varian*.csv)  teamvariantfile="$inf" ; method=csv;;
		*pirila*.xml)  teamvariantfile="$inf" ; method=pirila ;;
	esac
done

((debug>8)) && echo "sourcedir  :$sourcedir"
((debug>8)) && echo "course     :$courcefile"
((debug>8)) && echo "teamvariant:$teamvariantfile"
((debug>8)) && echo "method     :$method"

linestr="____________________________________________________________________"
echo "
Check Variants Results - Hajonnat tarkistus tulos:
$linestr
"
set +m;shopt -s lastpipe
../check.variants.sh -c "$sourcedir/$courcefile" -t "$sourcedir/$teamvariantfile" -m "$method" 2>/dev/null | \
while read key line
do
        ((debug>8)) && echo "* $key $line" >&2
        dir="$line"
done #</dev/stdin
#echo "$dir"

oifs="$IFS"
IFS="/" dirpath=($dir)
dirid=${dirpath[1]}
IFS="$oifs"

echo "ID    :$dirid"
echo "Method:$method"
echo ""

tmpf="$sourcedir/$$.tmp"
for inf in "$dir"/check*csv
do
	[ "$inf" = "$dir/check*csv" ] && continue
	onlyfilename="${inf##*/}"
        #echo " $dir - $onlyfilename - $inf"
        echo "- $onlyfilename"
done


echo "" > "$tmpf"

if [ "$method" = "ocad" ] ; then # - print out hajonta.lst (Pirila variant format)
	varf="$dir/hajonta.lst"
	echo ""
	echo "hajonta.lst:"
	echo "$linestr"
	[ -f "$varf" ] && cat "$varf"
fi

echo "$linestr"
for inf in "$dir"/*.check.txt
do
	[ "$inf" = "$dir/*.check.txt" ] && continue
	
	onlyfilename="${inf##*/}"
	classid=${onlyfilename/.check.txt/}
	#echo "*${classid} ${onlyfilename}*" >> "$tmpf"
	echo "*${classid}*" >> "$tmpf"

	lines=$(cat "$inf" | wc -l)
        ((lines>1)) && echo "Variant error class $classid :" >> "$tmpf"
        ((lines<2)) && echo "Variant OK class $classid :" >> "$tmpf"
	cat "$inf" >> "$tmpf"
done

echo "ext:$extended" >> "$tmpf"
if [ "$extended" != "" ] ; then
	echo "Tiedostot - Files" >> "$tmpf"
	echo "___________________________________________________________" >> "$tmpf"
	echo "" >> "$tmpf"
	echo "check.class.csv" >> "$tmpf"
	cat "$dir/check.class.csv" >> "$tmpf"
	echo "___________________________________________________________" >> "$tmpf"
	echo "" >> "$tmpf"
	echo "check.controls.csv" >> "$tmpf"
	cat "$dir/check.controls.csv" >> "$tmpf"
	echo "___________________________________________________________" >> "$tmpf"
	echo "" >> "$tmpf"
	echo "check.teams.csv" >> "$tmpf"
	cat "$dir/check.teams.csv" >> "$tmpf"
fi

cat "$tmpf"

sleep 1
rm -f "$tmpf" 2>/dev/null
echo "$linestr"
	
	

