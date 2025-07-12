#!/bin/bash

keyboards=$(hyprctl devices -j | jq -r '.keyboards[] | .name')
for kb in $keyboards; do
	echo $kb
	hyprctl switchxkblayout "$kb" next
done
