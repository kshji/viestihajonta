# get.class.os.csv.fi.awk
# parse classes from OS2020 finnish
# Need col from csv = Sarja
#
# gawk -f get.class.os.csv.fi.awk tmp/X/results/os.csv > results/check.class.csv
#

BEGIN {
	FS="|"
	OFS="|"
	}

NR==1 { # csv header
	for (fld=1;fld<=NF;fld++) {
		flds[$fld]=fld
		}
	next
	}
NF < 2 { next }
{

	class=$flds["Sarja"]
	classes[class]++
}
	
END {
	for (s in classes) print s
	}
	
