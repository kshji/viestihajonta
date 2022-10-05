# get.controls.iof3.awk
# use getXML.awk parser
# parse IOF XML 3.0 
# gawk -f  get.data.awk courses.xml | awk -f get.course.iof3.awk

function print_course(Coursename,Controls,Codes) {
	printf "%s%s%d%s0-%s%s",Coursename,OFS,Controls,OFS,Codes[1],OFS
	Prevcode=Codes[1]
	for (c=2;c<=Controls;c++) {
		printf "%s-%s%s",Prevcode,Codes[c],OFS
		Prevcode=Codes[c]
		}
	printf "%s-M",Prevcode
	print ""
}

BEGIN { FS="|" 
	OFS="|"
	maxcontrols=99
	controlcnt=0
	}

$1 == "DAT" && $2 == "Name" &&  $3 ~ /CourseData\/RaceCourseData\/Course\/Name$/  {  
		if (controlcnt>0) { # print out prev course
			print_course(coursename,controlcnt,codes)
			}
		if (debug>1) print "*","1",$2,$NF 
		courseid=0  
		controlnum=0
		coursename=$NF
		# jos on Ocad viestiversio, niin alussa on sarjannimi ja _
		#gsub(/^.*_/,"",coursename)
		for (r=1;r<=maxcontrols;r++) {
			codes[r]=""
			}
		controlcnt=0
		next
		}
$1 == "DAT" && $2 == "Control" && $3 ~ /CourseControl\/Control$/ { 
		controlcnt++
		controlnum=controlcnt
		if (debug>1) print "*","2",controlnum,$2,$NF
		codes[controlnum]=$NF
		next
		}
END {
		# last course print
		if (controlcnt>0) { # 
			print_course(coursename,controlcnt,codes)
			}
	}

