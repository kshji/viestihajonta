# get.variants.awk
# use getXML.awk parser
# gawk -f  get.data.awk courses.xml | awk -f get.variants.awk

function print_out(Coursename) {
	print Coursename
}

BEGIN { FS="|" 
	OFS="|"
	mem=0
	}
$1 == "DAT" && $2 == "CourseName" &&  $3 ~ /CourseName$/  {  
		if (mem>0) { # prev course aout
			print_out(coursename)
			}
		#print $2,$NF 
		mem=1
		coursename=$NF
		# jos on Ocad viestiversio, niin alussa on sarjannimi ja _
		# if it is Ocad relay format then line start with classname and _
		# individual not include class
                gsub(/^.*_/,"",coursename)
		next
		}
END {
		if (mem>0) {  # last
			print_out(coursename)
			}
	}

