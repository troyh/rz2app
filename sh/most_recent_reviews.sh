#!/bin/bash

. `dirname $0`/../conf/app.conf

OUTDIR="$XML_DIR/meta/site";
OUTXML="most_recent_reviews.xml";

if [ ! -d $OUTDIR ];then
	mkdir -p $OUTDIR;
fi

echo "<reviews>" > $OUTDIR/$OUTXML

rm -f $TMP_DIR/$SCRIPT_NAME.1

cat $INDEX_DIR/reviews/day/key_doc_pairs_merged | cut -f 1 | egrep "[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]" | sort | tail -10 |
while read KEY; do
	~/ouzo/memget $KEY | sed -e 's/^.*://' -e 's/, *$//' -e 's/,/\n/g' >> $TMP_DIR/$SCRIPT_NAME.1
done

# TODO: pick 10 at random

tail $TMP_DIR/$SCRIPT_NAME.1 |
while read DOCID; do
	xmlstarlet fo -o $XML_DIR/docs/reviews/$DOCID.xml >> $OUTDIR/$OUTXML
done

echo "</reviews>" >> $OUTDIR/$OUTXML
