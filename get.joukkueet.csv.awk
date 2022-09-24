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
	debug=0
	}

NR==1 { # csv otsikko
	for (fld=1;fld<=NF;fld++) {
		kentta[$fld]=fld
		#print kentta[fld]
		}
	if (debug<1) next
	print kentta["Sarja"]
	print kentta["No"]
	print kentta["Rata-1"]
	print kentta["Rata-2"]
	print kentta["Rata-3"]
	print kentta["Rata-4"]
	print kentta["Rata-5"]
	print kentta["Rata-6"]
	print kentta["Rata-7"]
	next
	}
NF < 2 { next }
{

	sarja=$kentta["Sarja"]
	joukkue=$kentta["No"]
	if (debug>0) print sarja,joukkue	
	for (osuus=1;osuus<=maxosuus;osuus++) {
		kenttanimi="Rata-" osuus
		kenttanr=kentta[kenttanimi]
		if (kenttanr == "" ) continue	
		
		hajonta=$kenttanr
		gsub(/ /,"",hajonta)
		if (debug>0) print "K:",kenttanimi,kenttanr,hajonta
		if (hajonta != "") {
			print sarja,joukkue,osuus,hajonta
			}
		}
}
	
