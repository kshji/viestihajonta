# get.class.pirila.awk
# use getXML.awk parser
# gawk -f  get.data.awk pirilasta.xml | awk -f get.class.pirila.awk

function printout(classid,classname) {
	#printf "%s%s%s\n",classid,OFS,classname
	printf "%s\n",classid
}

BEGIN { FS="|" 
	OFS="|"
	mem=0
	}
# on DAT, elementin nimi haluttu ja elementin polku haluttu - testataan loppu
# tuo polkutesti paljastaa onko elelemtti rivi vai sulkeva rivi, jolloin polussa ei ole elementin rivia
$1 == "DAT" && $2 == "ClassId" &&  $3 ~ /Event\/Classes\/Class\/ClassId$/  {  
		if (mem>0) { # previous class
			printout(classid,classname)
			}
		#print $2,$NF 
		mem=1
		classid=$NF
		classname=""
		next
		}
$1 == "DAT" && $2 == "Name" && $3 ~ /Event\/Classes\/Class\/Name$/ { 
		#print $2,$NF
		classname=$NF
		mem=1
		next
		}
END {
		# last 
		if (mem>0) { 
			printout(classid,classname)
			}
	}

