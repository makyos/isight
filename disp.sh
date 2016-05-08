#!/bin/sh

clamShellClose()
{
    [ $(ioreg -r -k AppleClamshellState -d 4 | grep AppleClamshellState | head -1 | cut -d = -f 2) = Yes ]
}

while true; do
    echo $(ioreg -r -k AppleClamshellState -d 4 | grep AppleClamshellState | head -1 | cut -d = -f 2)
    if $(clamShellClose) ; then
	echo "true"
    else
	echo "false"
    fi
    sleep 1
done

