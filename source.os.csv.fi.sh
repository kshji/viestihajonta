#!/usr/bin/bash
# source.os.csv.fi.sh
# v. 2022-10-13
# Reformat source data to the generic format of this system 
# - competitor with variant - forking
#
# tuottaa tarvittavat pohjatiedot kilpailija- ja ratatiedoista, jotta voidaan tehda hajontatarkistus
# Kaytetaan SportSoftware OS0020 version csv-tiedostoa os.joukkuehajonnat.csv
# Tiedostossa on jokaisela joukkueella ja juoksijalla myos rastit !!! yksi tiedosto
# - hieman perverssi: olisi aika hyva yksi csv, mutta koska muut tehty kahdella tiedostolla
#   niin tastakin tehdaan kaksi tiedostoa ...



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
# - remove UTF-8 magic and DOS cr
rmbom()
{
        [ "$1" = "" ] && echo "usage:rmbom infile" >&2 && exit 1
        inf="$1"
        tf="$tmpdir"/bom.$$.tmp
        sed -e '1s/^\xef\xbb\xbf//' "$inf" | tr -d '\015' > "$tf"
        cat "$tf" > "$inf"
        rm -f "$tf" 2>/dev/null
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
                #-c) coursefile=$2; shift ;;
                -t) teamvariantfile=$2; shift ;;
                -i) myid="$2" ; tmpdir="tmp/$myid"; shift ;;
                -p) tmpdir="$2" ; shift ;;
                -w) html=1; shift ;;
                -*) usage; exit 99 ;;
                *) shift; break ;;
        esac
        shift
done

#[ "$coursefile" = "" ] && echo "need courses" >&2 && exit 20
[ "$teamvariantfile" = "" ] && echo "need team+variant datafile" >&2 && exit 21
#[ ! -f "$coursefile" ] && echo "can't open file $coursefile" >&2 && exit 22
[ ! -f "$teamvariantfile" ] && echo "can't open file $teamvariantfile" >&2 && exit 22

rmbom "$teamvariantfile"

resdir="$tmpdir/results"
mkdir -p "$resdir"

# 1st line include colnames, but contols cols not. Need to add
gawk 'BEGIN {
		FS=";"
		OFS="|"
		}
	NR == 1 { # headerline
		header=$0
		gsub(/;/,OFS,header) # change delim
		gsub(/ /,"",header)  # rm spaces
		controls=""
		deli=""
		for (c=1;c<=50;c++) {
			controls=sprintf("%s%sC%s",controls,deli,c)
			deli=OFS
			}
		print header controls
		next
		}
	NF > 1	{ 
		line=$0
		gsub(/";"/,OFS,line)
		gsub(/;"/,OFS,line)
		gsub(/";/,OFS,line)
		gsub(/;/,OFS,line)
		print line
		}
	' "$teamvariantfile" > "$resdir/os.csv"

# use new teamvarianfile
teamvariantfile="$resdir/os.csv"

# classes
gawk -f  "$BINDIR/get.class.os.csv.fi.awk" "$teamvariantfile" > "$resdir/check.class.csv"

# teams
# D16|1690|1|1J4
gawk -f "$BINDIR/get.teams.os.csv.fi.awk" "$teamvariantfile" > "$resdir/check.teams.csv"

# variants - forking
#gawk -f  "$BINDIR/get.data.awk" -i "$BINDIR/getXML.awk" "$coursefile" | gawk -f get.variants.ocad.awk > "$resdir/check.variants.csv"

gawk -v debug=$debug -f "$BINDIR/get.controls.os.csv.fi.awk" "$teamvariantfile" > "$resdir/check.controls.csv"


