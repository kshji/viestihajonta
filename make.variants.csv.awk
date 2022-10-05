# 
# tee.hajonnat.csv.awk
# apuohjelma joka tekee 
# H21|16|1|1A4 formaatista Pirilaa pureksivan version
# No;Rata-1;Rata-2;Rata-3;Rata-4;....
# 1;1AEH2I1;1BFG1J2
#
# gawk -f tee.hajonnat.csv.awk tulos/tarkistus.joukkueet.csv > lahdedata/hajonta.csv
#

function tulosta_joukkue(sar,jou,hajo) {
	printf "%s%s%d",sar,OFS,jou
	for (h in hajo) {
		hajontastr=hajo[h]
		if (hajontastr != "" ) printf "%s%s",OFS,hajontastr
		}
	printf "\n"

}

BEGIN {
	FS="|"
	OFS=";"
	edjoukkue=0
	edsarja=0
	}

NF != 4 { next }

NR == 1 {
	# tuotetaan csv otsikko
	printf "Sarja%sNo",OFS
	for (rata=1;rata<=25;rata++) {
		printf "%sRata-%d",OFS,rata
		}
	printf "\n"
}


{
	sarja=$1
	joukkue=$2
	osuus=$3
	hajonta=$4
	if (joukkue != edjoukkue && edjoukkue != 0) {
		#print "=Tulosta:",sarja,joukkue,osuus,hajonta,edsarja,edjoukkue
		tulosta_joukkue(edsarja,edjoukkue,hajonnat)
		# - nollataan hajonnat
		for (o=1;o<=20;o++) {
			hajonnat[o]=""
			}
		}
	hajonnat[osuus]=hajonta
	edjoukkue=joukkue
	edsarja=sarja
}

END {
	# viim. joukkue
	if (joukkue>0) tulosta_joukkue(sarja,joukkue,hajonnat)
	}


