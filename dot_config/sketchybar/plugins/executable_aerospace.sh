#!/usr/bin/env bash

#workspaces=$(aerospace list-workspaces --monitor all --empty no)
#for sid in $workspaces; do
#  sketchybar --set space.$sid drawing=on
#done

#EMPTY_WORKSPACES=$(aerospace list-workspaces --monitor focused --empty)

if echo "$EMPTY_WORKSPACES" | grep -q "$1"; then
	LABEL_COLOR="$RED" # marks empty workspaces in red
else
	LABEL_COLOR="0xffffffff"
fi


if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    #sketchybar --set $NAME drawing=on
    sketchybar --set $NAME background.drawing=on #label.color="$LABEL_COLOR"
else
    #sketchybar --set $NAME drawing=off
    sketchybar --set $NAME background.drawing=off #label.color="$LABEL_COLOR"
fi

#workspaces=$(aerospace list-workspaces --monitor all --empty)
#for sid in $workspaces; do
#  sketchybar --set space.$sid drawing=off
#done



