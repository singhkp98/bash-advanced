#!/bin/bash

# Variables
OPTION=$1
NEWUSERSFILE=/tmp/support/newusers


case $OPTION in
	'')
		;;
	-v)
		VERBOSE=y
		;;
	-h)
        	echo "Usage: $0 [-h|-v]"
         	echo
         	exit
         	;;
    	*)
        	echo "Usage: $0 [-h|-v]"
        	echo
        	exit 1
         	;;
esac


 # Loop
for ENTRY in $(cat $NEWUSERSFILE); do
	# Extract first, last, and tier fields
	FIRSTNAME=$(echo $ENTRY | cut -d: -f1)
	LASTNAME=$(echo $ENTRY | cut -d: -f2)
	TIER=$(echo $ENTRY | cut -d: -f4)
	# Make account name
	FIRSTINITIAL=$(echo $FIRSTNAME | cut -c 1 | tr 'A-Z' 'a-z')
	LOWERLASTNAME=$(echo $LASTNAME | tr 'A-Z' 'a-z')

	ACCTNAME=$FIRSTINITIAL$LOWERLASTNAME

	# Test for dups and conflicts
	ACCTEXIST=''
   	ACCTEXISTNAME=''
	id $ACCTNAME &> /dev/null

   	if [ $? -eq 0 ]; then
        	ACCTEXIST=y
        	ACCTEXISTNAME="$(grep ^$ACCTNAME: /etc/passwd | cut -f5 -d:)"
	fi
        # Test for dups and conflicts
	if [ "$ACCTEXIST" = 'y' ] && [ "$ACCTEXISTNAME" = "$FIRSTNAME $LASTNAME" ]; then
                 echo "Skipping $ACCTNAME. Duplicate found."
	         elif [ "$ACCTEXIST" = 'y' ]; then
                 echo "Skipping $ACCTNAME. Conflict found."
	else
           	useradd $ACCTNAME -c "$FIRSTNAME $LASTNAME"
		if [ "$VERBOSE" =  'y' ]; then
                       echo "Added $ACCTNAME."
		fi
	fi

done

TOTAL=$(wc -l < $NEWUSERSFILE)
TIER1COUNT=$(grep -c :1$ $NEWUSERSFILE)
TIER2COUNT=$(grep -c :2$ $NEWUSERSFILE)
TIER3COUNT=$(grep -c :3$ $NEWUSERSFILE)
TIER1PCT=$(( $TIER1COUNT * 100 / $TOTAL ))
TIER2PCT=$(( $TIER2COUNT * 100 / $TOTAL ))
TIER3PCT=$(( $TIER3COUNT * 100 / $TOTAL ))
# Print report
echo "\"Tier 1\",\"$TIER1COUNT\",\"$TIER1PCT%\""
echo "\"Tier 2\",\"$TIER2COUNT\",\"$TIER2PCT%\""
echo "\"Tier 3\",\"$TIER3COUNT\",\"$TIER3PCT%\""