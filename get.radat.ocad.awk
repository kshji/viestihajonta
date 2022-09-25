# get.radat.ocad.awk
# use getXML.awk parser
# Vain IOF 3.0 versio
# gawk -f  get.data.awk radat.xml | awk -f get.radat.ocad.awk

BEGIN { FS="|" 
	OFS="|"
	}
# on DAT, elementin nimi haluttu ja elementin polku haluttu - testataan loppu
# tuo polkutesti paljastaa onko elelemtti rivi vai sulkeva rivi, jolloin polussa ei ole elementin rivia
$1 == "DAT" && $2 == "CourseFamily" &&  $3 ~ /CourseFamily$/  {  
		radat[$NF]=$NF
		}

END {
	for (r in radat) print r
	}

