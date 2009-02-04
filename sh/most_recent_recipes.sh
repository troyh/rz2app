#!/bin/bash

. `dirname $0`/../conf/app.conf

OUTDIR="$XML_DIR/meta/site";
OUTXML="most_recent_recipes.xml";

if [ ! -d $OUTDIR ];then
	mkdir -p $OUTDIR;
fi

echo "<recipes>" > $OUTDIR/$OUTXML

~/ouzo/memget idx/recipe/submitted/2007-01-02 |
sed -e 's/^.*://' -e 's/, *$//' -e 's/,/\n/g' |
while read DOCID; do
	xmlstarlet ed -O -d "/recipe/ingredients" -d "/recipe/steps" $XML_DIR/docs/recipes/$DOCID.xml >> $OUTDIR/$OUTXML
done

echo "</recipes>" >> $OUTDIR/$OUTXML
