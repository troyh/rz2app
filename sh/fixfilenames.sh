#!/bin/bash

DIR="$1"
XPATH="$2"

if [ ! -d $DIR/renamed ]; then
	mkdir $DIR/renamed;
fi

find $DIR -maxdepth 1 -type f  | while read F; do
	NEWNAME=`xmlstarlet sel -t -v "$XPATH" $F`;
	echo "$F -> $DIR/renamed/$NEWNAME.xml";
	mv $F $DIR/renamed/$NEWNAME.xml;
done

