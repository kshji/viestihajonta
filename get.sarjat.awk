# get.sarjat.awk
# use getXML.awk parser
# gawk -f  get.data.awk pirilasta_xml.xml | awk -f get.sarjat.awk

function tulosta(Sarjaid,Sarjanimi) {
	#printf "%s%s%s\n",Sarjaid,OFS,Sarjanimi
	printf "%s\n",Sarjaid
}

BEGIN { FS="|" 
	OFS="|"
	muistissa=0
	}
# on DAT, elementin nimi haluttu ja elementin polku haluttu - testataan loppu
# tuo polkutesti paljastaa onko elelemtti rivi vai sulkeva rivi, jolloin polussa ei ole elementin rivia
$1 == "DAT" && $2 == "ClassId" &&  $3 ~ /Event\/Classes\/Class\/ClassId$/  {  
		if (muistissa>0) { # edellinen sarja
			tulosta(sarjaid,sarjanimi)
			}
		#print $2,$NF 
		muistissa=1
		sarjaid=$NF
		sarjanimi=""
		next
		}
$1 == "DAT" && $2 == "Name" && $3 ~ /Event\/Classes\/Class\/Name$/ { 
		#print $2,$NF
		sarjanimi=$NF
		muistissa=1
		next
		}
END {
		# viimeinen data ulos
		if (muistissa>0) { # data on
			tulosta(sarjaid,sarjanimi)
			}
	}

