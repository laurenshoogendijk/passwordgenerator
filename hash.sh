PW=$1
LENGTH=$(echo ${#PW})

HASH=$(grep $PW: passwords$LENGTH.txt)
COUNT=$( grep -c $PW: passwords$LENGTH.txt)

if [ $COUNT -eq 0 ]
then
	echo "Hash not found, great job!"
	read -p "Do you want to add it? [y/n]: " yn

	case $yn in
	[Yy]* )	echo "$PW:"$(echo $PW | md5sum) >> passwords$LENGTH.txt; echo "Added $PW to the database.";; 
	[Nn]* ) echo "Okay, not adding $PW to the database.";; 
	* ) echo "Do you want to add it? y/n";;
esac
else
	echo "Hash was found. Pick a new password!"
	echo $HASH
fi
