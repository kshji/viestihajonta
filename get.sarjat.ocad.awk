# 
# get.sarjat.ocad.awk
# Tekee Ocad joukkuehajonta txt tiedostosta hajonta.csv = Pirila version
#H;1   SARJA;RATA
#1.1: 1ABAB
#1.2: 2BCBA
#1.3: 3CA
#2.1: 1BCBA
# H21|16|1|1A4 formaatista Pirilaa pureksivan version
# No;Rata-1;Rata-2;Rata-3;Rata-4;....
# 1;1AEH2I1;1BFG1J2
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

NF == 2 { # sarjarivi
	sarja=$1
	rata=$2
	gsub(/ /,"",sarja)
	gsub(/ /,"",rata)
	sarjat[sarja]=sarja
	}


END {
	for (s in sarjat) print s
	}


