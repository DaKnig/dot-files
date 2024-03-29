#!/usr/bin/bash
device=$(xinput list | grep "TouchPad.*id=[0-9]*" -o | grep "[0-9]*" -o)
status=$(xinput list-props "$device" | grep "ev.*l.*" | grep "[10]$" -o)

if [ "$status" == '1' ] ; then
	xinput --disable "$device"
else
	xinput --enable "$device"
fi
