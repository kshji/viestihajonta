# get.sarjat.csv.awk
# poimitaan sarjat Pirilan hyvaksymasta csv:sta
# Tarvitsee kentat
# Sarja
#
# gawk -f get.sarjat.csv.awk lahdedata/hajonta.csv > tulos/tarkistus.sarjat.csv
#

BEGIN {
	FS=";"
	OFS="|"
	}

NR==1 { # csv otsikko
	for (fld=1;fld<=NF;fld++) {
		kentta[$fld]=fld
		}
	next
	}
NF < 2 { next }
{

	sarja=$kentta["Sarja"]
	sarjat[sarja]++
}
	
END {
	for (s in sarjat) print s
	}
	
