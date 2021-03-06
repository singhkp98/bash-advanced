#!/bin/bash

# Variables
NEWUSERSFILE=$1
cat $NEWUSERSFILE > /dev/null 2>&1
RESULT=$?

if [ $RESULT -ne 0 ]; then
	echo "file not found"
	exit 2
fi

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
	# Create account
	useradd $ACCTNAME -c "$FIRSTNAME $LASTNAME"
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