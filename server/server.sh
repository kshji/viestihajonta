#!/usr/local/bin/awsh
# awsh is copy of ksh
# server.sh
# This script start checkvariant server
#
# Ver: 2022-10-06
# Jukka Inkeri
# Lisence https://github.com/kshji/viestihajonta/blob/main/LICENSE.md
#
# awsh = ksh = install ksh and copy ksh to /usr/local/bin/awsh
#
background=1 # default, run background
conf="./server.cfg"
stop=0
while [ $# -gt 0 ]
do
	arg="$1"
	case "$arg" in 
		-s|--stop) # stop server - not start
			stop=1
			;;
		-f|--foreground) 
			background=0 
			;;
		-c|--config) conf="$2" ; shift ;;
	esac
	shift
done

# start server

[ ! -f "$conf" ] && echo "Need server.cfg" >&2 && exit 1

. "$conf"

[ "$uploaddir" = "" ] && echo "setup need uploaddir value" >&2 && exit 2
[ "$rooturlpath" = "" ] && uploadpath="/variantcheck"
[ "$command" = "" ] && command="$PWD/process.sh"
[ "$maxsize" = "" ] && maxsize=$((10 * 1024 * 1024)) # 10 MB

mkdir -p "$uploaddir" tmp loki 2>/dev/null
chmod 1777 $uploaddir tmp loki 2>/dev/null

# Check is server running or PID has saved
[ -f .pid.txt ] && read PROSID < .pid.txt && rm -f .pid.txt 2>/dev/null && echo "stopping server $PROSID"

[ "$PROSID" != "" ] && kill "$PROSID" 2>/dev/null 

# not start new server?
((stop == 1)) && echo "Server stopped" >&2 && exit 0

case "$background" in
	1)
		nohup file-upload/variantserver -d "$uploaddir"  -p $port -u "$rooturlpath" -c "$command" -x "$maxsize" > "$PWD"/loki/server.log 2>&1  &
		PROSID=$!
		echo "Server started PID:$PROSID" >&2
		echo $PROSID > .pid.txt
		;;
	0)
		file-upload/variantserver -d "$uploaddir"  -p $port -u "$rooturlpath"  -c "$command" -x "$maxsize"
		;;
esac

