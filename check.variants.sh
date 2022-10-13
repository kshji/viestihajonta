#!/usr/bin/bash
# check.variants.sh
# (c) Jukka Inkeri viestihajonta@awot.fi relayvariant@awot.fi
# Ver: 2022-10-06
#
# Main program to check orienteering forkings in the relays and 
# also in the individual courses with forking
#
#  License: full version https://github.com/kshji/viestihajonta/blob/main/LICENSE.md
#  Very sort version: This is free and unencumbered software released into the public domain.
#  (c) Jukka Inkeri 2022-
#
# Ocad
# ./check.variants.sh -c sourcedata/examples/relay1.course.Courses.v3.xml  -t sourcedata/examples/relay1.course.Variations.txt -m 1 -d 0
# Pirila
# ./check.variants.sh -c sourcedata/examples/radat.v3.kenraali.xml -t sourcedata/examples/pirilasta.kenraali.xml -m 3 -d 0
# ./check.variants.sh -c sourcedata/examples/radat.v2.kenraali.xml -t sourcedata/examples/pirilasta.kenraali.xml -m 3 -d 0
# Ocad + teams variants in csv
# ./check.variants.sh -c sourcedata/examples/radat.v2.kenraali.xml -t sourcedata/examples/hajonta.kenraali.csv -m 2 -d 0
# ./check.variants.sh -c sourcedata/examples/radat.v2.kenraali.virhe.xml -t sourcedata/examples/hajonta.kenraali.csv -m 2 -d 0
# 

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



#####################################################################
clean()
{
	# remove tmp files or not - current setup is - no
	#[ -d "$tmpdir" -a $debug -gt 0 ] && rm -rf  "$tmpdir" 2>/dev/null
	:
}

########################################################################
usage()
{
        echo "usage:$PRG -c coursesfile -t teamsvariantsfile -m method [ -i sessioid -p tempdir -d 0/1 ] # d=debug " >&2
	echo "  methdod
   ocad   1  - source files - course IOF XML 3.0 and teamvariants.txt from Ocad
   csv    2  - coursefile from Ocad and team with variants from csv-file - Pirila-format
   pirila 3  - coursefile XML from Pirila-software and teams with variants XML from Pirila-software
   raw    4  - source files are already in csv format which is used in this software
   os.fi  5  - SportSoftware OS2020 finnish, joukkuehajonnat.csv - yksi tiedosto
 	" >&2 
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


#####################################################################
# MAIN
#####################################################################
trap 'clean' SIGINT EXIT 
timestamp=$(date '+%Y-%m-%d_%H:%M:%S')
myid=$$.$(date '+%s')
debug=0
zipfile=""
method=0
html=0
# file include courses, controls and variant information
coursefile=""
# file include information combination team, leg, variant
teamvariantfile="" 
# uniq temporary dir for this process
tmpdir="tmp/$myid.$(date '+%Y-%m-%d_%H%M%S')"
# already in generic csv format
classfile=""

while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in
		-d) debug=$2; shift ;;
		-c) coursefile=$2; shift ;;
		--classfile) classfile="$2"; shift ;;
		-t) teamvariantfile=$2; shift ;;
		-m) method=$2; shift ;;
		-w) html=1; shift ;;
		-*) usage ; exit 1 ;;
		*) shift; break ;;
	esac
	shift
done

needcoursefile=1
case "$method" in
	os.*) needcoursefile=0 ;;
esac

[ "$coursefile" = "" -a "$html" = 0 -a "$needcoursefile" = 1 ] && echo "need courses" >&2 && exit 20
[ "$coursefile" = ""  -a "$needcoursefile" = 1 ] && echo "<p>need coursesfile</p>"  && exit 21
[ "$teamvariantfile" = "" -a "$html" = 0 ] && echo "need team+variant datafile" >&2 && exit 22
[ "$teamvariantfile" = ""  ] && echo "<p>need team+variant datafile</p>"  && exit 23

mkdir -p "$tmpdir" 2>/dev/null
[ -f "$coursefile" ] && rmbom "$coursefile"
rmbom "$teamvariantfile"

resdir="$tmpdir/results"
mkdir -p "$tmpdir/tmp" 2>/dev/null
mkdir -p "$resdir" 2>/dev/null
rm -f "$resdir"/*.check*.csv "$resdir"/*.check*.txt "$resdir"/variants.csv "$tmpdir"/tmp/*.tmp "$resdir"/tmp/* 2>/dev/null

case "$method" in 
	1|ocad) # Ocad course xml 3.0 and Ocad teams
		((debug>0)) && echo "$BINDIR/source.ocad.sh -c $coursefile -t $teamvariantfile -i $myid -d $debug -p $tmpdir"
		$BINDIR/source.ocad.sh -c "$coursefile" -t "$teamvariantfile" -i "$myid" -d "$debug" -p "$tmpdir"
		;;
	2|csv) # Ocad course xml 2.0.3/3.0  and teams with forks csv
		$BINDIR/source.csv.sh -c "$coursefile" -t "$teamvariantfile" -i "$myid" -d "$debug" -p "$tmpdir"
		;;
	3|pirila) # Course xml 2.0.3 from Pirila resultsystem and teams with forks (xml) from Pirila resultsystem
		$BINDIR/source.pirila.sh -c "$coursefile" -t "$teamvariantfile" -i "$myid" -d "$debug" -p "$tmpdir"
		;;
	4|raw) # All files is already in needed generic csv format - only copy ...
		[ "$classfile" = "" ] && echo "need classfile" >&2 && exit 41
		[ ! -f "$classfile" ] && echo "classfile $classfile ???" >&2 && exit 42
		rmbom "$classfile"
		cp "$coursefile" "$resdir/check.controls.csv"
		cp "$teamvariantfile" "$resdir/check.teams.csv"
		cp "$classfile" "$resdir/check.class.csv"
		;;
	5|os.fi) # SportSoftware OS2020 soft
		# source.os.csv.fi.sh
		$BINDIR/source.os.csv.fi.sh  -t "$teamvariantfile" -i "$myid" -d "$debug" -p "$tmpdir"
		;;
	*) # not supported
		echo "Not supported method:$method" >&2 && exit 10
		;;
esac


# Check forking variants using this env generic csv files format

$BINDIR/check.do.sh  -c "$resdir/check.class.csv" -t "$resdir/check.teams.csv" -v "$resdir/check.controls.csv" -d "$debug" -p "$resdir"
echo "DIR $resdir"
