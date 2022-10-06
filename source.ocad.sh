#!/usr/bin/bash
# source.ocad.sh
# v. 2022-10-05
#
# tuottaa tarvittavat pohjatiedot kilpailija- ja ratatiedoista, jotta voidaan tehda hajontatarkistus
# Kaytetaan Ocad ratatiedostoa ja joukkuehajonnat Ocad:stä
#

PRG="$0"
BINDIR="${PRG%/*}"
[ "$PRG" = "$BINDIR" ] && BINDIR="." # - same dir as program
PRG="${PRG##*/}"

LC_ALL=fi_FI.utf8
export LC_ALL

########################################################################
usage()
{
	echo "usage:$PRG -c coursesfile -t teamsvariantsfile [ -i sessioid -p tempdir -d 0/1 ] # d=debug " >&2
}

########################################################################
# MAIN
########################################################################

debug=0
html=0
# file include courses, controls and variant information
coursefile=""
# file include information combination team, leg, variant
teamvariantfile=""
myid=$$.$(date '+%s')
# uniq temporary dir for this process
tmpdir="tmp/$myid"

while [ $# -gt 0 ]
do
        arg="$1"
        case "$arg" in
                -d) debug=$2; shift ;;
                -c) coursefile=$2; shift ;;
                -t) teamvariantfile=$2; shift ;;
		-i) myid="$2" ; tmpdir="tmp/$myid"; shift ;;
		-p) tmpdir="$2" ; shift ;;
                -w) html=1; shift ;;
                -*) usage; exit 99 ;;
                *) shift; break ;;
        esac
        shift
done

[ "$coursefile" = "" ] && echo "need courses" >&2 && exit 20
[ "$teamvariantfile" = "" ] && echo "need team+variant datafile" >&2 && exit 21
[ ! -f "$coursefile" ] && echo "can't open file $coursefile" >&2 && exit 22
[ ! -f "$teamvariantfile" ] && echo "can't open file $teamvariantfile" >&2 && exit 22

resdir="$tmpdir/results"

gawk -v debug=$debug -f "$BINDIR/get.class.ocad.awk" "$teamvariantfile" > "$resdir/check.class.csv"

# teams
# - make pirila format !!! - you can use this also in the Pirila-programms.ocad.awk-
gawk -v debug=$debug -f "$BINDIR/get.teams.ocad.awk" "$teamvariantfile" > "$resdir/variants.csv" 
cp -f "$resdir/variants.csv" "$resdir/hajonta.csv" 2>/dev/null
cp -f "$resdir/variants.csv" "$resdir/hajonta.lst" 2>/dev/null

# ja and then make generic ....
gawk -v debug=$debug -f "$BINDIR/get.teams.csv.awk" "$resdir/variants.csv" > "$resdir/check.teams.csv"

# variants - forking
# Accept iof 2.0.3 and iof 3.0
gawk  -f "$BINDIR/get.data.awk" -i "$BINDIR/getXML.awk" "$coursefile" | gawk -v debug=$debug -f "$BINDIR/get.variants.ocad.awk" > "$resdir/check.variants.csv"

# legs - rastivalit
# diff ver iof 2.0.3 and 3.0
verid=2  # default
verstr=$(grep 'iofVersion="3.0"' "$coursefile" 2>/dev/null)
[ "$verstr" != "" ] && verid=3
case "$verid" in
	2)
	  ((debug>0)) && echo "2.0 - gawk -f $BINDIR/get.data.awk  -i "$BINDIR/getXML.awk" $coursefile | gawk -v debug=$debug -f $BINDIR/get.controls.iof2.awk > $resdir/check.controls.csv"
	  gawk -f "$BINDIR/get.data.awk"  -i "$BINDIR/getXML.awk" "$coursefile" | gawk -v debug=$debug -f "$BINDIR/get.controls.iof2.awk" > "$resdir/check.controls.csv"
	  ;;
	3)
	  ((debug>0)) && echo "3.0 - gawk -f $BINDIR/get.data.awk  -i "$BINDIR/getXML.awk" $coursefile | gawk -v debug=$debug -f $BINDIR/get.controls.iof3.awk > $resdir/check.controls.csv"
	  gawk -f "$BINDIR/get.data.awk"  -i "$BINDIR/getXML.awk" "$coursefile" | gawk -v debug=$debug -f "$BINDIR/get.controls.iof3.awk" > "$resdir/check.controls.csv"
	  ;;
esac

echo "Done $resdir/check.controls.csv"

