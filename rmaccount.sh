#!/bin/bash

# Variables
USERSFILE=/tmp/support/newusers
 # Loop
for ENTRY in $(cat $USERSFILE); do
	# Extract first, last, and tier fields
	FIRSTNAME=$(echo $ENTRY | cut -d: -f1)
	LASTNAME=$(echo $ENTRY | cut -d: -f2)
	# Make account name
	FIRSTINITIAL=$(echo $FIRSTNAME | cut -c 1 | tr 'A-Z' 'a-z')
	LOWERLASTNAME=$(echo $LASTNAME | tr 'A-Z' 'a-z')

	ACCTNAME=$FIRSTINITIAL$LOWERLASTNAME
	# Delete account
	userdel -r $ACCTNAME
done