# get.rastit.iof3.awk
# use getXML.awk parser
# parseroi IOF 3.0 mukaisen tiedoston
# gawk -f  get.data.awk radat.xml | awk -f get.rastit.iof3.awk

function rata_tulosta(Ratanimi,Rastilkm,Koodit) {
	printf "%s%s%d%s0-%s%s",Ratanimi,OFS,Rastilkm,OFS,Koodit[1],OFS
	Edellinenkoodi=Koodit[1]
	for (r=2;r<=Rastilkm;r++) {
		printf "%s-%s%s",Edellinenkoodi,Koodit[r],OFS
		Edellinenkoodi=Koodit[r]
		}
	printf "%s-M",Edellinenkoodi
	print ""
}

BEGIN { FS="|" 
	OFS="|"
	maxrastilkm=99
	rastilkm=0
	}
# on DAT, elementin nimi haluttu ja elementin polku haluttu - testataan loppu
# tuo polkutesti paljastaa onko elelemtti rivi vai sulkeva rivi, jolloin polussa ei ole elementin rivia
$1 == "DAT" && $2 == "Name" &&  $3 ~ /CourseData\/RaceCourseData\/Course\/Name$/  {  
		if (rastilkm>0) { # edellinen rata ulos
			rata_tulosta(ratanimi,rastilkm,koodit)
			}
		#print $2,$NF 
		rata=0  
		rastinro=0
		ratanimi=$NF
		# jos on Ocad viestiversio, niin alussa on sarjannimi ja _
		#gsub(/^.*_/,"",ratanimi)
		for (r=1;r<=maxrastilkm;r++) {
			koodit[r]=""
			}
		edellinenrastikoodi=""
		rastikoodi=""
		rastilkm=0
		next
		}
$1 == "DAT" && $2 == "Control" && $3 ~ /CourseControl\/Control$/ { 
		#print $2,$NF
		rastilkm++
		rastinro=rastilkm
		koodit[rastinro]=$NF
		next
		}
END {
		# viimeinen rata ulos
		if (rastilkm>0) { # edellinen rata ulos
			rata_tulosta(ratanimi,rastilkm,koodit)
			}
	}

