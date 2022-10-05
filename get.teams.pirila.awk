# get.team.pirila.awk
# use getXML.awk parser
# gawk -f  get.data.awk pirila.xml | awk -f get.team.pirila.awk

function print_out(ClassId,TeamId,Leg,Variant) {
	print ClassId,TeamId,Leg,Variant
}

BEGIN { FS="|" 
	OFS="|"
	mem=0
	}
$1 == "DAT" && $2 == "ClassId" &&  $3 ~ /Participants\/Participant\/ClassId$/  {  
		#print $2,$NF 
		classid=$NF
		next
		}
#DAT|Id|/Event/Participants/Participant/Id||1
$1 == "DAT" && $2 == "Id" && $3 ~ /Participants\/Participant\/Id$/ { 
		#print $2,$NF
		teamid=$NF
		mem=1
		legid=""
		variantid=""
		next
		}

# ATTR|Leg|/Event/Participants/Participant/Legs/Leg|LegNo|1
$1 == "ATTR" && $2 == "Leg" && $3 ~ /Participants\/Participant\/Legs\/Leg/ && $4=="LegNo"  { 
		mem=1
		legid=$5
		next
		}

# DAT|Course|/Event/Participants/Participant/Legs/Leg/Course||1CEH2I1
$1 == "DAT" && $2 == "Course" && $3 ~ /Participants\/Participant\/Legs\/Leg\/Course$/ && $NF != "Auto" { 
		#print $2,$NF
		variantid=$NF
		mem=1
                print_out(classid,teamid,legid,variantid)
		next
		}

END {
	}

