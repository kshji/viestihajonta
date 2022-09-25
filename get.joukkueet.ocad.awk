# 
# get.joukkueet.ocad.awk
# Tekee Ocad joukkuehajonnat.txt tiedostosta hajonta.csv = Pirila version
#H;1   SARJA;RATA
#1.1: 1ABAB
#1.2: 2BCBA
#1.3: 3CA
#2.1: 1BCBA
# tekee 
# No;Rata-1;Rata-2;Rata-3;Rata-4;....
# H;1;1_1AEH2I1;1_1BFG1J2
#
# gawk -f tee.joukkueet.ocad.awk lahdedata/joukkuehajonnat.txt
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
	FS="[;:.]"  # erotin merkit
	OFS=";"
	edjoukkue=0
	edsarja=0
	muistissa=0
	}

NF < 1 { next }

NR == 1 { # tuotetaan csv otsikko
	printf "Sarja%sNo",OFS
	for (rata=1;rata<=7;rata++) {
		printf "%sRata-%d",OFS,rata
		}
	printf "\n"
}

#{ print NF," rivi ",$0 }

NF == 2 { # sarjarivi
	sarja=$1
	rata=$2
	gsub(/ /,"",sarja)
	gsub(/ /,"",rata)
	#print "SARJA",sarja,"RATA",rata
	if (muistissa>0) tulosta_joukkue(edsarja,edjoukkue,hajonnat)
	muistissa=0
	edsarja=0
	edjoukkue=0
	next
	}


NF > 2 {
	joukkue=$1
	osuus=$2
	hajonta=$3
	gsub(/ /,"",hajonta)
	hajonta=rata "_" hajonta
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
	muistissa=1
}

END {
	# viim. joukkue
	if (joukkue>0 && muistissa>0) tulosta_joukkue(sarja,joukkue,hajonnat)
	}


