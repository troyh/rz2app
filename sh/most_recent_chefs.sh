#!/bin/bash

. `dirname $0`/../conf/app.conf

OUTDIR="$XML_DIR/meta/site";
OUTXML="most_recent_chefs.xml";

if [ ! -d $OUTDIR ];then
	mkdir -p $OUTDIR;
fi

echo "<chefs>" > $OUTDIR/$OUTXML

rm -f $TMP_DIR/$SCRIPT_NAME.1

cat $INDEX_DIR/chefs/day/key_doc_pairs_merged | cut -f 1 | sort | tail -10 |
while read KEY; do
	~/ouzo/memget $KEY | sed -e 's/^.*://' -e 's/, *$//' -e 's/,/\n/g' >> $TMP_DIR/$SCRIPT_NAME.1
done

# TODO: pick 10 at random

tail $TMP_DIR/$SCRIPT_NAME.1 |
while read DOCID; do
	xmlstarlet fo -o $XML_DIR/docs/chefs/$DOCID.xml >> $OUTDIR/$OUTXML
done

echo "</chefs>" >> $OUTDIR/$OUTXML
