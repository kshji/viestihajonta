# get.class.csv.awk
# parse classes from Pirila csv format
# Need col from csv = Sarja
#
# gawk -f get.class.csv.awk sourcedata/variant.csv > result/check.class.csv
#

BEGIN {
	FS=";"
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
	
