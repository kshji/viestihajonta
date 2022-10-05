# 
# get.teams.ocad.awk
# Convert teams from Ocad teamvariant.txt to the Pirila variant csv format (variants.csv)
#H;1   SARJA;RATA # SARJA=CLASS RATA=VARIANT
#1.1: 1ABAB
#1.2: 2BCBA
#1.3: 3CA
#2.1: 1BCBA
# Result format:
# No;Rata-1;Rata-2;Rata-3;Rata-4;....
# H;1;1_1AEH2I1;1_1BFG1J2
#
# gawk -f get.teams.ocad.awk sourcedata/teamvariants.txt
#

function print_team(Class,Team,Variants) {
	printf "%s%s%d",Class,OFS,Team
	for (v in Variants) {
		Variantstr=Variants[v]
		if (Variantstr != "" ) printf "%s%s",OFS,Variantstr
		}
	printf "\n"

}

BEGIN {
	FS="[;:.]"  # delimiters
	OFS=";"
	prevteam=0
	prevclass=0
	mem=0
	}

NF < 1 { next }

NR == 1 { # csv header
	printf "Sarja%sNo",OFS
	for (rata=1;rata<=25;rata++) {
		printf "%sRata-%d",OFS,rata
		}
	printf "\n"
}

#{ print NF," rivi ",$0 }

NF == 2 { # class
	classid=$1
	courseid=$2
	if (debug>1) print "*","CLASS1",classid,"COURSE",variantid
	gsub(/ /,"",classid)
	gsub(/ /,"",courseid)
	if (debug>1) print "*","CLASS2",classid,"COURSE",courseid
	if (mem>0) print_team(prevclass,prevteam,variants)
	mem=0
	prevclass=0
	prevteam=0
	next
	}


NF > 2 {
	teamid=$1
	legid=$2
	variantid=$3
	gsub(/ /,"",variantid)
	variantid=courseid "_" variantid
	if (teamid != prevteam && prevteam != 0) {
		if (debug>1) print "*","=Print:",classid,teamid,legid,variantid,prevclass,prevteam
		print_team(prevclass,prevteam,variants)
		# - clear vars
		for (o=1;o<=20;o++) {
			variants[o]=""
			}
		}
	variants[legid]=variantid
	prevteam=teamid
	prevclass=classid
	mem=1
}

END {
	# 
	if (teamid>0 && mem>0) print_team(classid,teamid,variants)
	}


