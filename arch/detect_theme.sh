#!/bin/bash

current=$(gsettings get org.gnome.desktop.interface color-scheme)
if [[ "$current" == "'prefer-dark'" ]]; then
	echo "{\"alt\":\"dark\"}"
else
	echo "{\"alt\":\"light\"}"
fi
