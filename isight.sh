#!/bin/bash

INTERVAL=1200 # (sec)
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
    
    if $(clamShellClose); then continue; fi
    
    timming=$(date +'%Y-%m-%d_%H-%M-%S')
    
    ## imagesnap from brew install imagesnap
    ## -w : wait focus (sec)
    imagesnap -w 3 ${IMG}/isight_${timming}.jpg > /dev/null
    resize ${IMG}/isight_${timming}.jpg
    
    ## screencapture from OS X
    ## -x : without the sound playing
    screencapture -x -t jpg ${IMG}/screen_${timming}.jpg
    resize ${IMG}/screen_${timming}.jpg
    
    ## Mearge
    if [ -e ${IMG}/screen_${timming}.jpg ] && [ -e ${IMG}/isight_${timming}.jpg ] ; then
	    convert -append \
		    ${IMG}/screen_${timming}.jpg \
		    ${IMG}/isight_${timming}.jpg \
		    ${IMG}/${timming}.jpg
    fi

    if [ -e ${IMG}/${timming}.jpg ]; then
        ## pngquant from brew install pngquant
        ## --ext .png --force : over write
        # pngquant --ext .png --force ${IMG}/${timming}.png > /dev/null

    	exiftool \
	        -Model="isight.sh" \
	        -overwrite_original \
	        ${IMG}/${timming}.jpg > /dev/null

        ## import Photos APP
        # ${LIB}/img2photos.js ${IMG}/${timming}.jpg > /dev/null
        ls -lh ${IMG}/${timming}.jpg
    fi
    
    rm -f \
       ${IMG}/screen_${timming}.jpg \
       ${IMG}/isight_${timming}.jpg

    sleep ${INTERVAL}

done

