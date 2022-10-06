# check.variants.awk
#
# Check legs (code-code pairs) - team run the same overall course - same legs and count of legs is same
# (c) Jukka Inkeri viestihajonnat@awot.fi relayvariant@awot.fi
#
# Ver. 2022-10-05
#
# Execute:
# gawk -f check.variants.awk -v debug=0 -v controlfile=results/check.controls.csv -v classid=H21 results/check.teams.csv > results/H21.check.txt
#
# debug=0 - no debug 
# debug=1 - some debug msg
# debug=3 - debug max msg
#
BEGIN {
	ofs=FS
	FS=OFS="|"

	# read all variants with controls
	while (i = getline < controlfile ) {
                key=$1 
		if (key == "*") continue  # debug line
		if (debug>1) print "*","------------",key,$2
                variant_ids[key]=$2   # variant and count
		legs[key][1]=""
		split($0,fields)
		# clear fld 1 and 2, those are not legs
		if (debug>2) print "*","0data",$0
		lkm=0
		for (fld in fields) {
			if (debug>2) print "*","FLD",key,fld,fields[fld]
			# fld is integer and I mean it = +0 do it, sometimes awk believe that it is string ...
			field=fld+0
			if (field>2 && fields[fld] != "" ) {
				if (debug>2) print "*","set",fld,fields[fld]
				legs[key][fld-2]=fields[fld]
				}
			}
		# debug 
		if (debug>1) printf "*","* %s ",key
		for (leg in legs[key]) {
			if (debug>1 && legs[key][leg] != "" ) printf "(%s) %s = ",leg,legs[key][leg]
			}
		if (debug>1) print ""
                }
        close(controlfile)
	if (debug>2) exit
	}

NF < 4 { next }
$1 != classid { next }

$1 ~ /^*/ { next }  # debug line

{
	# JU|1|1|1CEH2I1
	# classid|teamid|legid|hajonta

	teamid=$2
	legid=$3
	variantid=$4
	if (debug>1) print "*","Team:",teamid,legid,variantid
	#if (legs[variantid] != "" ) {
	if (length(legs[variantid])> 0 ) {
		for (leg in legs[variantid] ) {
			code2code=legs[variantid][leg]
			#printf "(%s) %s = ",vali,code2code
			if (debug>1) printf "%s ",code2code
			teamlegs[teamid][code2code]++
			}
		if (debug>0) print ""
		}

}

END {
	sort="sort -k 1,1 -t '|'"
	sort2=sort
	counter=0
	compareteam=0
	for (teamid in teamlegs) {
		counter++
		#tmpf= "tmp/" teamid ".tmp"
		tmpf= tempdir "/" teamid ".tmp"
		for (leg in teamlegs[teamid]) {
			print leg,teamlegs[teamid][leg] | (sort2 ">" tmpf)
			} 
		close(sort2 ">" tmpf)

		for (leg in teamlegs[teamid]) {
			if (debug>1) print "*","input",$0
			print leg,teamlegs[teamid][leg] |& sort 
			} 
		close(sort,"to")
		#close(sort)
		#close(sort2,"to")
		#close(tmpf,"to")
		str=""
		deli=""
		if (debug>1) print "*","Read sorted - Luetaan lajiteltu",tmpf
		while (sort |& getline) {
			if (debug>1) print "*","input2",$0
			rv=$1
			rvcounter=$2
			if (counter==1) {
				comparelegs[rv]=rvcounter
				}
			str=str deli $0
			deli="|"
			}
		if (debug>1) print "*",teamid,"code2codestr",str
		variantstr[teamid]=str
		close(sort)

		# 1. team has values which are used to compare other teams
		if (debug>1) printf "*%sVERdbg :%s\n",OFS,str
		if (counter==1) {
			compareid=str
			compareteam=teamid
			printf "VER :%s\n",compareid
			}
		if (str != compareid) { # diff !!!!
			if (debug>1) printf "*%sVER debug:%s\n",OFS,compareid
			printf "%4s:%s\n",teamid,str
			for (l in comparelegs) {
				vcounter=comparelegs[l]
				jcounter=teamlegs[teamid][l]
				if (vcounter>jcounter) {
					printf "DIFF-ERO: %s = teamid:%d counter:%d teamid:%d counter:%d \n",l,compareteam,vcounter,teamid,jcounter
					}
				}
			for (l in teamlegs[teamid]) {
				vcounter=comparelegs[l]
				jcounter=teamlegs[teamid][l]
				if (vcounter<jcounter) {
					printf "DIFF-ERO: %s = teamid:%d counter:%d teamid:%d counter:%d \n",l,compareteam,vcounter,teamid,jcounter
					}
				}

			# -- diff ended
			}
		} 
		
	}

