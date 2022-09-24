# get.joukkueet.csv.awk
# poimitaan hajonnat Pirilan hyvaksymasta csv:sta
# Tarvitsee kentat
# Sarja;No;Rata-1;Rata-2;Rata-3;Rata-4;Rata-5;Rata-6;Rata-7
#
# gawk -f get.joukkueet.csv.awk lahdedata/hajonta.csv > tulos/tarkistus.joukkueet.csv
#

BEGIN {
	FS=";"
	OFS="|"
	maxosuus=7
	}

NR==1 { # csv otsikko
	for (fld=1;fld<=NF;fld++) {
		kentta[$fld]=fld
		#print kentta[fld]
		}
	#print kentta["Sarja"]
	#print kentta["No"]
	next
	}
NF < 2 { next }
{

	sarja=$kentta["Sarja"]
	joukkue=$kentta["No"]
	#print sarja,joukkue	
	for (osuus=1;osuus<=maxosuus;osuus++) {
		kenttanimi="Rata-" osuus
		hajonta=$kentta[kenttanimi]
		if (hajonta != "") {
			print sarja,joukkue,osuus,hajonta
			}
		}
}
	
