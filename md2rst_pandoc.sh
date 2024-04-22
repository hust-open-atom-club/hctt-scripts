#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Please provide a file with Markdown type as the 1st parameter!"
	exit 0
fi

TARGET=/tmp/target.rst

pandoc "$1" -f markdown -t rst -o ${TARGET}

if [ $? = 0 ];then
	echo "The pandoc convertion is successful! Please check $TARGET!"
else
	echo "The pandoc covertion fails!"
fi
