# get.class.os.csv.fi.awk
# parse variant controls from OS2020 finnish
# Need col from csv = Ratanro,Rastit,R1, ..., R50
#
# gawk -f get.controls.os.csv.fi.awk tmp/X/results/os.csv > results/check.controls.csv
#

function print_course(Variant,Controls,Codes) {
        Prevcode=Codes[1]
        printf "%s%s%d",Variant,OFS,Controls 
        for (r=2;r<=Controls;r++) {
                printf "%s%s-%s",OFS,Prevcode,Codes[r]
                Prevcode=Codes[r]
                }
        print ""
}

BEGIN {
	FS="|"
	OFS="|"
	maxcontrols=50
	}

NR==1 { # csv header
	for (fld=1;fld<=NF;fld++) {
		flds[$fld]=fld
		}
	if (debug<1) next
	print "*",flds["Ratanro"]
	print "* S",flds["Rastit"]
	print "* 1",flds["C1"]
	print "* 3",flds["C3"]
	next
	}
NF < 2 { next }
{

	
	variantid=$flds["Ratanro"] $flds["Hajontavaihtoehto"]
	# need to set variant once
	if (variants[variantid] != "" ) next
	variants[variantid]=variantid
	controls[1]=$flds["Rastit"]
	if (debug>0) print "*",variantid,controls[1]
	cnt=1
        for (r=1;r<=maxcontrols;r++) {
		controlnr="C" r
		controlid=$flds[controlnr]
		#print "C",r,controlid
		controls[r+1]=""
		if (controlid == "" ) continue 
		cnt++
		controls[cnt]=controlid
                }
	print_course(variantid,cnt,controls)
}
	
END {
	x=1
	}
	
