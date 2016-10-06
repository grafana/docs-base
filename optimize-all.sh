#!/usr/bin/env sh

FILES=`find . -iname *.png`
for FILE in $FILES; do
  tmpfile=$(mktemp)
  zopflipng -m -y --keepchunks=iCCP --iterations=500 --lossy_transparent $FILE $tmpfile
  mv $tmpfile $FILE
done;


