# 
# Tarkistaa rastivalit, etta onhan kaikilla joukkueilla suoritettuna samat rastivalit ja yhta monta kertaa 
# (c) Jukka Inkeri viestihajonnat@awot.fi
#
# Ver. 2022-09-20
#
# Suoritusohje:
# gawk -f tarkista.hajonnat.awk -v debug=0 -v rastitiedosto=tulos/tarkistus.rastit.csv -v sarja=H21 tulos/tarkistus.joukkueet.csv > tulos/H21.tarkistus.txt
#
# debug=0 - ei debug viesteja
# debug=1 - jonkin verran debug viesteja
# debug=2 - debug maksimi
#
BEGIN {
	ofs=FS
	FS=OFS="|"

	# luetaan kaikki hajonnat valeineen
	while (i = getline < rastitiedosto ) {
                key=$1
		if (debug>0) print "------------",key
                #print 2,key,""
                hajonta_idt[key]=$2   # hajonta ja lkm
		rastivalit[key][1]=""
		split($0,kentat)
		# nollataan kaksi ensimmaista kenttaa - eivat ole rastivaleja
		if (debug>2) print "0data",$0
		lkm=0
		for (fld in kentat) {
			if (debug>2) print "FLD",key,fld,kentat[fld]
			# muutetaan integer arvoksi, jostakin syysta valilla "arvaa" merkkijonoksi
			kentta=fld+0
			if (kentta>2 && kentat[fld] != "" ) {
				if (debug>2) print "set",fld,kentat[fld]
				rastivalit[key][fld-2]=kentat[fld]
				}
			}
		# debug testaus
		for (vali in rastivalit[key]) {
			if (debug>0 && rastivalit[key][vali] != "" ) printf "(%s) %s = ",vali,rastivalit[key][vali]
			}
		if (debug>0) print ""
                }
        close(rastitiedosto)
	if (debug>2) exit
	}

NF < 4 { next }
$1 != sarja { next }

{
	# JU|1|1|1CEH2I1
	# sarja|joukkue|osuus|hajonta

	joukkue=$2
	osuus=$3
	hajonta=$4
	if (debug>0) print joukkue,osuus,hajonta
	if (length(rastivalit[hajonta])> 0 ) {
	#if (rastivalit[hajonta] != "" ) {
		for (vali in rastivalit[hajonta] ) {
			rastivali=rastivalit[hajonta][vali]
			#printf "(%s) %s = ",vali,rastivali
			if (debug>0) printf "%s ",rastivali
			joukkuevalit[joukkue][rastivali]++
			}
		if (debug>0) print ""
		}

}

END {
	sort="sort -k 1,1 -t '|'"
	sort2=sort
	lkm=0
	vertailujoukkue=0
	for (joukkue in joukkuevalit) {
		lkm++
		tmpf= "tmp/" joukkue ".tmp"
		for (vali in joukkuevalit[joukkue]) {
			print vali,joukkuevalit[joukkue][vali] | (sort2 ">" tmpf)
			} 
		close(sort2 ">" tmpf)

		for (vali in joukkuevalit[joukkue]) {
			if (debug>1) print "str",$0
			print vali,joukkuevalit[joukkue][vali] |& sort 
			} 
		close(sort,"to")
		#close(sort)
		#close(sort2,"to")
		#close(tmpf,"to")
		str=""
		erotin=""
		if (debug>0) print "Luetaan lajiteltu",tmpf
		while (sort |& getline) {
			if (debug>1) print "str",$0
			rv=$1
			rvlkm=$2
			if (lkm==1) {
				vertailuvalit[rv]=rvlkm
				}
			str=str erotin $0
			erotin="|"
			}
		if (debug) print joukkue,"valistr",str
		hajontastr[joukkue]=str
		close(sort)

		# 1. joukkue otetaan vertailuarvoksi, muilla oltava sama
		if (lkm==1) {
			vertailu=str
			vertailujoukkue=joukkue
			printf "VER :%s\n",vertailu
			}
		if (str != vertailu) { # ero
			#printf "VER :%s\n",vertailu
			printf "%4s:%s\n",joukkue,str
			for (v in vertailuvalit) {
				vlkm=vertailuvalit[v]
				jlkm=joukkuevalit[joukkue][v]
				if (vlkm>jlkm) {
					printf "ERO: %s = Joukkue:%d lkm:%d Joukkue:%d lkm:%d \n",v,vertailujoukkue,vlkm,joukkue,jlkm
					}
				}
			for (v in joukkuevalit[joukkue]) {
				vlkm=vertailuvalit[v]
				jlkm=joukkuevalit[joukkue][v]
				if (vlkm<jlkm) {
					printf "ERO: %s = Joukkue:%d lkm:%d Joukkue:%d lkm:%d \n",v,vertailujoukkue,vlkm,joukkue,jlkm
					}
				}

			# -- ero loppui
			}
		} 
		
	}

