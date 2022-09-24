# get.joukkueet.awk
# use getXML.awk parser
# gawk -f  get.data.awk pirilasta_xml.xml | awk -f get.joukkueet.awk

function tulosta(Sarjaid,Joukkueid,Osuus,Hajonta) {
	print Sarjaid,Joukkueid,Osuus,Hajonta
}

BEGIN { FS="|" 
	OFS="|"
	muistissa=0
	}
# on DAT, elementin nimi haluttu ja elementin polku haluttu - testataan loppu
# tuo polkutesti paljastaa onko elelemtti rivi vai sulkeva rivi, jolloin polussa ei ole elementin rivia
$1 == "DAT" && $2 == "ClassId" &&  $3 ~ /Participants\/Participant\/ClassId$/  {  
		#print $2,$NF 
		sarjaid=$NF
		next
		}
#DAT|Id|/Event/Participants/Participant/Id||1
$1 == "DAT" && $2 == "Id" && $3 ~ /Participants\/Participant\/Id$/ { 
		#print $2,$NF
		joukkueid=$NF
		muistissa=1
		osuus=""
		hajonta=""
		next
		}

# ATTR|Leg|/Event/Participants/Participant/Legs/Leg|LegNo|1
$1 == "ATTR" && $2 == "Leg" && $3 ~ /Participants\/Participant\/Legs\/Leg/ && $4=="LegNo"  { 
		muistissa=1
		osuus=$5
		next
		}

# DAT|Course|/Event/Participants/Participant/Legs/Leg/Course||1CEH2I1
$1 == "DAT" && $2 == "Course" && $3 ~ /Participants\/Participant\/Legs\/Leg\/Course$/ && $NF != "Auto" { 
		#print $2,$NF
		hajonta=$NF
		muistissa=1
                tulosta(sarjaid,joukkueid,osuus,hajonta)
		next
		}

END {
	}

