MINLENGTH=$1
MAXLENGTH=$2
SPECIAL=1
TMP=""
PATH="/home/laurens/passwordlist"

for i in $(eval echo "{$MINLENGTH..$MAXLENGTH}");
do
	for j in $(eval echo "{0..1000000}");
	do
		if [ $SPECIAL -eq 1 ]
		then
			PW=$(/usr/bin/pwgen -cn --num-password=1 $i)
			TMP=$(printf "%q" "$PW")
			SPECIAL=2
		elif [ $SPECIAL -eq 0 ]
		then
			PW=$(/usr/bin/pwgen -cn --num-password=1 $i)
			SPECIAL=1
		elif [ $SPECIAL -eq 2 ]
		then
			PW=$(/usr/bin/pwgen -c --num-passwords=1 $i)
			SPECIAL=3
		else
			PW=$(/usr/bin/pwgen -A0 $i)
			SPECIAL=0
		fi
		HASH=$(echo $PW | /usr/bin/md5sum)
		VALUE="$PW:$HASH"
		EXISTS=$(/usr/bin/cat $PATH/examples/passwords$i.txt | /usr/bin/grep -c $VALUE)
		if [ $EXISTS -eq 0 ]
		then
			echo "Found new Password: $PW"
			echo "New Password: $PW" >> $PATH/error.log
			echo "$PW:$HASH" >> $PATH/examples/passwords$i.txt
		fi
	done
done
