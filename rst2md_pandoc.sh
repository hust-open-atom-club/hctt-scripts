#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Please provide a file with RST type as the 1st parameter!"
	exit 0
fi

TARGET=target.md

pandoc $1 -f rst -t markdown -o /tmp/${TARGET}

if [ $? == 0 ];then
	echo "The pandoc convertion is successful! Please check $TARGET!"
else
	echo "The pandoc covertion fails!"
fi
