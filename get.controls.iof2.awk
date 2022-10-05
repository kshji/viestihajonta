# get.controls.iof2.awk
# use getXML.awk parser
# parseroi IOF 2.0.3 mukaisen tiedoston
# gawk -f  get.data.awk radat.xml | awk -f get.controls.iof2.awk

function print_course(Variant,Controls,Codes) {
	printf "%s%s%d%s0-%s%s",Variant,OFS,Controls,OFS,Codes[1],OFS
	Prevcode=Codes[1]
	for (r=2;r<=Controls;r++) {
		printf "%s-%s%s",Prevcode,Codes[r],OFS
		Prevcode=Codes[r]
		}
	printf "%s-M",Prevcode
	print ""
}

BEGIN { FS="|" 
	OFS="|"
	maxcontrols=99
	controlcnt=0
	}
#$1 == "DAT" && $2 == "CourseName" && length($NF) > 0 { 
# on DAT, elementin nimi haluttu ja elementin polku haluttu - testataan loppu
# tuo polkutesti paljastaa onko elelemtti rivi vai sulkeva rivi, jolloin polussa ei ole elementin rivia
$1 == "DAT" && $2 == "CourseName" &&  $3 ~ /CourseName$/  {  
		if (controlcnt>0) { # edellinen rata ulos
			print_course(coursename,controlcnt,codes)
			}
		#print $2,$NF 
		course=0  
		controlnum=0
		coursename=$NF
		for (r=1;r<=maxcontrols;r++) {
			codes[r]=""
			}
		controlcnt=0
		next
		}
$1 == "DAT" && $2 == "Sequence" && $3 ~ /Sequence$/ { 
		#print $2,$NF
		controlnum=$NF
		controlcnt++
		next
		}
$1 == "DAT" && $2 == "ControlCode" && $3 ~ /ControlCode$/ { 
		#print $2,$NF
		codes[controlnum]=$NF
		next
		}
END {
		# 
		if (controlcnt>0) { # last course
			print_course(coursename,controlcnt,codes)
			}
	}

