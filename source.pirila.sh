#!/usr/bin/bash
# source.pirila.sh
# v. 2022-10-05
#
# tuottaa tarvittavat pohjatiedot kilpailija- ja ratatiedoista, jotta voidaan tehda hajontatarkistus
# Kaytetaan Pirila-ohjelmasta tehtyja radat.xml ja pirilasta.xml
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
gawk -f "$BINDIR/get.data.awk"  -i "$BINDIR/getXML.awk" "$teamvariantfile" | gawk -v debug=$debug -f "$BINDIR/get.class.pirila.awk"  > "$resdir/check.class.csv"


# teams
# D16|1690|1|1J4
gawk -f "$BINDIR/get.data.awk"  -i "$BINDIR/getXML.awk" "$teamvariantfile" | gawk -v debug=$debug -f "$BINDIR/get.teams.pirila.awk" >  "$resdir/check.teams.csv"

# variants
# iof xml 2.0.3 and iof 3.0
#gawk -f  "$BINDIR/get.data.awk"  -i "$BINDIR/getXML.awk" "$coursefile" | gawk -f get.variants.ocad.awk > "$resdir/check.variants.csv"

# code2code - legs - rastivalit
# diff ver iof 2.0.3 and 3.0
ver=2  # default
verstr=$(grep 'iofVersion="3.0"' "$coursefile" 2>/dev/null)
[ "$verstr" != "" ] && ver=3
case "$ver" in
        2)
          gawk -f "$BINDIR/get.data.awk"  -i "$BINDIR/getXML.awk" "$coursefile" | gawk -v debug=$debug -f "$BINDIR/get.controls.iof2.awk" > "$resdir/check.controls.csv"
          ;;
        3)
          gawk -f "$BINDIR/get.data.awk"  -i "$BINDIR/getXML.awk" "$coursefile" | gawk -v debug=$debug -f "$BINDIR/get.controls.iof3.awk" > "$resdir/check.controls.csv"
          ;;
esac

echo "Done $resdir/check.controls.csv"
