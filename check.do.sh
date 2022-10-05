#!/usr/bin/bash
# check.do.sh
# (c) Jukka Inkeri viestihajonta@awot.fi relayvariant@awot.fi
# Ver: 2022-10-05
# 
# Check forking variants leg by leg
#
# 1st process source material 
# pohjatiedot tehtava ensin komennolla, jos Pirilan ohjlemasta tiedot haettu
#   ./source.pirila.sh
# pohjatiedot hajonta.csv ja radat Ocad:sta
#   ./source.csv.sh
#

# voi suorittaa yhdelle sarjalle tai kisan kaikille sarjoille
#
# One class
# ./check.do.sh -v tmp/3533.1664974130.2022-10-05_154850/results/check.controls.csv -t tmp/3533.1664974130.2022-10-05_154850/results/check.teams.csv -p tmp/3533.1664974130.2022-10-05_154850/results H21
# All classes
# ./check.do.sh

PRG="$0"
BINDIR="${PRG%/*}"
[ "$PRG" = "$BINDIR" ] && BINDIR="." # - same dir as program
PRG="${PRG##*/}"

LC_ALL=fi_FI.utf8
export LC_ALL

DIR=$PWD
tmpdir="$DIR/tmp"
mkdir -p "$tmpdir" 2>/dev/null
chmod 1777 "$tmpdir"/tmp 2>/dev/null


##########################################################################
check_variant()
{
	xclass="$1"
	xfile="$2"
	echo "Checking $xclass - Tarkistetaan $xclass" >&2
	mkdir -p "$resdir/tmp" 2>/dev/null
	((debug>0)) && echo "gawk -f $BINDIR/check.variants.awk -v debug=$debug -v controlfile=$controlfile -v classid=$xclass -v tempdir=$resdir/tmp $xfile" >&2
	gawk -f "$BINDIR/check.variants.awk" -v debug=$debug -v controlfile="$controlfile" -v classid="$xclass" -v tempdir="$resdir/tmp" "$xfile"

}

########################################################################
usage()
{
        echo "usage:$PRG -v controlfile -t teamfile -c classfile OR class [ -p resultdir -d 0/1 ] # d=debug " >&2}
}

##########################################################################
# MAIN
##########################################################################

#classes="results/check.class.csv"
#input="results/check.teams.csv"
#controlfile="results/check.controls.csv"
classes=""
controlfile=""
teamsfile=""
debug=0

resdir="tmp/results"
mkdir -p "$resdir"

while [ $# -gt 0 ]
do
        arg="$1"
        case "$arg" in
                -d) debug=$2; shift ;;
                -v) controlfile=$2; shift ;;
                -t) input=$2; shift ;;
                -c) classes=$2; shift ;;
		-p) resdir="$2" ; shift ;;
                -*) usage ; exit 1 ;;
                *)  break ;;
        esac
        shift
done

classid="$1"

[ "$controlfile" = "" ] && echo "need controlfile" >&2 && exit 51
[ "$input" = "" ] && echo "need teamsfile" >&2 && exit 51
[ "$classes" = "" -a "$classid" = "" ] && echo "need class or classesfile" >&2 && exit 51

ok=1
for inf in "$classes"  "$input" "$controlfile"
do
	[ "$inf" = "" -a "$classid" != "" ] && continue # only one class
	[ -f "$inf" ] && continue

	echo "$inf ???" 
	ok=0
done

((ok<1)) && echo "Exit - problem in sourcedata - Lopetetaan, puutteita lahdeaineistossa" && exit 1

if [ "$classid" != "" ] ; then # only class, not file
	echo "only $classid checking - vain classid $classid tarkistetaan"
	check_variant "$classid" "$input" > "$resdir/$classid.check.txt"
	echo "Result, look dir $resdir - lopputulos kansiossa $resdir" >&2
	echo ""
	lines=$(cat "$resdir/$classid.check.txt" | wc -l)
	((lines>1)) && echo " - Variant error class $classid"
	exit 0
fi

# all classes
echo "all classes checking - kaikki classes tarkistetaan"

while read classid xstr
do
	((debug>0)) && echo "Checking class $classid, $input" >&2
	check_variant "$classid" "$input" > "$resdir/$classid.check.txt"
	lines=$(cat "$resdir/$classid.check.txt" | wc -l)
	((lines>1)) && echo " - Variant error class $classid"
done < "$classes"

echo ""
echo "result dir $resdir - lopputulos kansiossa $resdir" >&2

((debug>0)) && ls -l "$resdir" >&2

