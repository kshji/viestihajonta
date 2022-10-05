# get.courses.ocad.awk
# use getXML.awk parser
# Support only IOF XML 3.0 version
# gawk -f  get.data.awk courses.xml | awk -f get.courses.ocad.awk

BEGIN { FS="|" 
	OFS="|"
	}
$1 == "DAT" && $2 == "CourseFamily" &&  $3 ~ /CourseFamily$/  {  
		courses[$NF]=$NF
		}

END {
	for (c in courses) print c
	}

