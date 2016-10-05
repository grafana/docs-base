#!/usr/bin/env sh

FILES=`find . -iname *.png`
for FILE in $FILES; do
  tmpfile=$(mktemp)
  zopflipng -m -y $FILE $tmpfile
  mv $tmpfile $1
done;


