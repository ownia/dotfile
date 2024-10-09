#!/bin/bash

if [ "$#" == 1 ]; then
	minicom --color=on --capturefile=minicom-"$1".log "$1"
else
	minicom --color=on --capturefile=minicom.log minirc.default
fi
