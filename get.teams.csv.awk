# get.team.csv.awk
# parse teams from Pirila csv file
# Need cols
# Sarja;No;Rata-1;Rata-2;Rata-3;Rata-4;Rata-5;Rata-6;Rata-7
#
# gawk -f get.team.csv.awk sourcedata/variant.csv > result/check.teams.csv
#

BEGIN {
	FS=";"
	OFS="|"
	maxlegs=15
	debug=0
	}

NR==1 { # csv header
	for (fld=1;fld<=NF;fld++) {
		flds[$fld]=fld
		#print flds[fld]
		}
	if (debug<3) next
	print flds["Sarja"]
	print flds["No"]
	print flds["Rata-1"]
	print flds["Rata-2"]
	print flds["Rata-3"]
	print flds["Rata-4"]
	print flds["Rata-5"]
	print flds["Rata-6"]
	print flds["Rata-7"]
	next
	}
NF < 2 { next }
$1 ~ /^*/ { # some debug line
		next
	}
{

	classid=$flds["Sarja"]
	teamid=$flds["No"]
	if (debug>1) print "*",classid,teamid	
	for (leg=1;leg<=maxlegs;leg++) {
		legname="Rata-" leg
		fldsnr=flds[legname]
		if (fldsnr == "" ) continue	
		
		variant=$fldsnr
		gsub(/ /,"",variant)
		if (debug>1) print "*","K:",legname,fldsnr,variant
		if (variant != "") {
			print classid,teamid,leg,variant
			}
		}
}
	
