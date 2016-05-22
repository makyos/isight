#!/bin/bash

INTERVAL=480 # (sec)
AT=$(dirname $0)
IMG=$AT/img
LIB=$AT/lib

function resize() {
    if [ -e $1 ]; then
	    mv $1 $1.tmp
	    convert $1.tmp -resize 1280x $1
	    rm $1.tmp
    fi
}

clamShellClose() {
    [ $(ioreg -r -k AppleClamshellState -d 4 | grep AppleClamshellState | head -1 | cut -d = -f 2) = Yes ]
}

echo 'Start'

while true; do
    
    sleep ${INTERVAL}
    
    if $(clamShellClose); then continue; fi
    
    timming=$(date +'%Y-%m-%d_%H-%M-%S')
    
    ## imagesnap from brew install imagesnap
    ## -w : wait focus (sec)
    imagesnap -w 3 ${IMG}/isight_${timming}.png > /dev/null
    resize ${IMG}/isight_${timming}.png
    
    ## screencapture from OS X
    ## -x : without the sound playing
    screencapture -x ${IMG}/screen_${timming}.png
    resize ${IMG}/screen_${timming}.png
    
    if [ -e ${IMG}/screen_${timming}.png ] && [ -e ${IMG}/isight_${timming}.png ] ; then
	    convert -append \
		    ${IMG}/screen_${timming}.png \
		    ${IMG}/isight_${timming}.png \
		    ${IMG}/${timming}.png
    fi

    if [ -e ${IMG}/${timming}.png ]; then
        ## pngquant from brew install pngquant
        ## --ext .png --force : over write
        pngquant --ext .png --force ${IMG}/${timming}.png > /dev/null
        ${LIB}/img2photos.js ${IMG}/${timming}.png > /dev/null
        ls -lh ${IMG}/${timming}.png
    fi
    
    rm -f \
       ${IMG}/screen_${timming}.png \
       ${IMG}/isight_${timming}.png
        
done

