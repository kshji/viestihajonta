# get.hajonnat.awk
# use getXML.awk parser
# gawk -f  get.data.awk radat.xml | awk -f get.hajonnat.awk

function tulosta(Ratanimi,Rastilkm,Koodit) {
	print Ratanimi
}

BEGIN { FS="|" 
	OFS="|"
	muistissa=0
	}
# on DAT, elementin nimi haluttu ja elementin polku haluttu - testataan loppu
# tuo polkutesti paljastaa onko elelemtti rivi vai sulkeva rivi, jolloin polussa ei ole elementin rivia
$1 == "DAT" && $2 == "CourseName" &&  $3 ~ /CourseName$/  {  
		if (muistissa>0) { # edellinen data ulos
			tulosta(ratanimi)
			}
		#print $2,$NF 
		muistissa=1
		ratanimi=$NF
		next
		}
END {
		# viimeinen data ulos
		if (muistissa>0) { # edellinen rata ulos
			tulosta(ratanimi)
			}
	}

