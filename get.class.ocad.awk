# 
# get.class.ocad.awk
# Convert from Ocad teamvariants teamvariants.txt to variant.csv = Pirila csv format
#H;1   SARJA;RATA   SARJA=CLASS  RATA=VARIANT
#1.1: 1ABAB
#1.2: 2BCBA
#1.3: 3CA
#2.1: 1BCBA
# to format H21|16|1|1A4 
#
# gawk -f tee.teams.ocad.awk sourcedata/teamvariants.txt
#

BEGIN {
	FS="[;:.]"  # delimiters
	OFS=";"
	prevteam=0
	prevclass=0
	mem=0
	}

NF < 1 { next }

NF == 2 { # classrivi
	class=$1
	course=$2
	gsub(/ /,"",class)
	gsub(/ /,"",course)
	classes[class]=class
	}


END {
	for (s in classes) print s
	}


