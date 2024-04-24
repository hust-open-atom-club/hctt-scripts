#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Please provide a file with RST type or a path as the 1st parameter!"
	exit 0
fi

if [ ! -f "$1" ] && [ ! -d "$1" ]; then
	echo "Please provide a file with RST type or a path as the 1st parameter!"
	exit 0
fi

collected_date=$(date +%Y%m%d)
status="collected"
success=0
failure=0

generate_frontmatter() {
	echo "---"
	echo "status: $status"
	echo "title: $1"
	echo "author: Linux Kernel Community"
	echo "collector: $2"
	echo "collected_date: $collected_date"
	echo "link: "
	echo "---"
}

add_frontmatter() {
	file=$1
	frontmatter=$2
	echo "$frontmatter\n" > temp.md
	cat "$file" >> temp.md
	mv temp.md "$file"
}

echo "Tell who you are"
read -r collector

if [ -d "$1" ]; then
	for file in $(find "$1" -name "*.rst"); do
		TARGET=${file%.*}.md
		pandoc "$file" -f rst -t markdown -o "${TARGET}" > /dev/null 2>&1

		title="\"$(grep -B 1 '===' "$file" | grep -v '===' | grep -v '^$' | head -n 1)\""
		frontmatter=$(generate_frontmatter "$title" "$collector")
		add_frontmatter "$TARGET" "$frontmatter"

		if [ $? = 0 ];then
			success=$((success+1))
			echo "$TARGET : \033[32mSuccess\033[0m"
		else
			failure=$((failure+1))
			echo "$TARGET : \033[31mFail\033[0m"
		fi
	done
else 
	if [ -f "$1" ]; then
		TARGET=${1%.*}.md
		pandoc "$1" -f rst -t markdown -o "${TARGET}" > /dev/null 2>&1
		
		title="\"$(grep -B 1 '===' "$1" | grep -v '===' | grep -v '^$' | head -n 1)\""
		frontmatter=$(generate_frontmatter "$title" "$collector")
		add_frontmatter "$TARGET" "$frontmatter"

		if [ $? = 0 ];then
			success=$((success+1))
			echo "$TARGET : \033[32mSuccess\033[0m"
		else
			failure=$((failure+1))
			echo "$TARGET : \033[31mFail\033[0m"
		fi
	else
		echo "The file or path does not exist!"
	fi
fi

echo "Convertion done!"
echo "\033[32mSuccess: ${success}\033[0m"
echo "\033[31mFail: ${failure}\033[0m"
echo "\033[33mWarning: The link field in frontmatter remains empty, you need fill it out manually\033[0m"