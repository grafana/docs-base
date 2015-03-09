#!/usr/bin/env bash
set -e

set -o pipefail

usage() {
	exit 1
}

if [[ -e MAINTAINERS ]]; then
	cp  MAINTAINERS /docs/sources/humans.txt
fi

# remove `^---*$` lines from md's
find . -name "*.md" | xargs sed -i~ -n '/^---*$/!p'

VERSION=$(cat VERSION)
MAJOR_MINOR="${VERSION%.*}"

# for i in $(seq $MAJOR_MINOR -0.1 1.0); do
#       echo "<li><a class='version' href='/v$i'>Version v$i</a></li>";
# done > sources/versions.html_fragment

# TODO: need to run these from the src dir - if its there
if [[ -e "/src/.git" ]]; then
	pushd .
	cd /src
	echo "getting branch and hash from $(pwd)"
	GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
	GITCOMMIT=$(git rev-parse --short HEAD 2>/dev/null)
	popd
else
	if [[ -e "/src/GIT_BRANCH" ]]; then
		echo "getting git info from /src/GIT_BRANCH files"
		GIT_BRANCH=$(cat /src/GIT_BRANCH)
		GITCOMMIT=$(cat /src/GITCOMMIT)
	else
		echo "getting branch and hash from /doc"
		GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
		GITCOMMIT=$(git rev-parse --short HEAD 2>/dev/null)
	fi
fi
BUILD_DATE=$(date)
sed -i "s/\$VERSION/$VERSION/g" theme/mkdocs/base.html
sed -i "s/\$MAJOR_MINOR/v$MAJOR_MINOR/g" theme/mkdocs/base.html
sed -i "s/\$GITCOMMIT/$GITCOMMIT/g" theme/mkdocs/base.html
sed -i "s/\$GIT_BRANCH/$GIT_BRANCH/g" theme/mkdocs/base.html
sed -i "s/\$BUILD_DATE/$BUILD_DATE/g" theme/mkdocs/base.html
sed -i "s/\$AWS_S3_BUCKET/$AWS_S3_BUCKET/g" theme/mkdocs/base.html

# fails when there are none!
cd sources
while read line
do
	echo "replacing includes in $line"
	sed -i~ 's/{{ include "\(.*\)" }}/cat include\/\1/ge' "$line"
done < <(rgrep --files-with-matches '{{ include ".*" }}')
cd ..

extrafiles=($(find . -name "mkdocs-*.yml"))
extralines=()

for file in "${extrafiles[@]}"
do
	#echo "LOADING $file"
	while read line
	do
		if [[ "$line" != "" ]]
		then
			extralines+=("$line")

			#echo "LINE (${#extralines[@]}):  $line"
		fi
	done < <(cat "$file")
done

#echo "extra count (${#extralines[@]})"
mv mkdocs.yml mkdocs.yml.bak
echo "# Generated mkdocs.yml from ${extrafiles[@]}"
echo "# Generated mkdocs.yml from ${extrafiles[@]}" > mkdocs.yml

while read line
do
	menu=$(echo $line | sed "s/^- \['\([^']*\)', '\([^']*\)'.*/\2/")
	if [[ "$menu" != "**HIDDEN**" ]]
		# or starts with a '#'?
	then
		if [[ "$lastmenu" != "" && "$lastmenu" != "$menu" ]]
		then
			# insert extra elements here
			for i in "${!extralines[@]}"
			do
				extra=${extralines[$i]}
				#echo "EXTRA $extra"
				extramenu=$(echo $extra | sed "s/^- \['\([^']*\)', '\([^']*\)'.*/\2/")
				if [[ "$extramenu" == "$lastmenu" ]]
				then
					echo "$extra" >> mkdocs.yml
					extralines[$i]=""
				fi
			done
			#echo "# JUST FINISHED $lastmenu"
		fi
		lastmenu="$menu"
	fi
	echo "$line" >> mkdocs.yml

done < <(cat "mkdocs.yml.bak")

for extra in "${extralines[@]}"
do
	if [[ "$extra" != "" ]]
	then
		echo "$extra" >> mkdocs.yml
	fi
done
