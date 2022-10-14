# get.team.os.csv.fi.awk
# parse teams from OS2020 finnish csv file
# Need cols
# Sarja;Lnro;Ratanro;Osuus
#
# gawk -f get.teams.os.csv.fi.awk tmp/N/results/os.csv > results/check.teams.csv
#

BEGIN {
	FS="|"
	OFS="|"
	maxlegs=25
	debug=0
	}

NR==1 { # csv header
	for (fld=1;fld<=NF;fld++) {
		flds[$fld]=fld
		#print flds[fld]
		}
	if (debug<3) next
	print flds["Sarja"]
	print flds["Lnro"]
	print flds["Osuus"]
	print flds["Ratanro"]
	print flds["Hajontavaihtoehto"]
	next
	}
NF < 2 { next }
$1 ~ /^*/ { # some debug line
		next
	}
{
	classid=$flds["Sarja"]
	teamid=$flds["Lnro"]
	legid=$flds["Osuus"]
	variantid=$flds["Ratanro"] $flds["Hajontavaihtoehto"]
	if (debug>1) print "*",classid,teamid,legid,variantid
	print classid,teamid,legid,variantid
}
	
