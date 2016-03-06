#!/bin/bash

INTERVAL=300 # (sec)
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

while true;
do
    timming=$(date +'%Y-%m-%d_%H-%M-%S')
    
    ## screencapture from OS X
    ## -x : without the sound playing
    screencapture -x ${IMG}/screen_${timming}.png
    resize ${IMG}/screen_${timming}.png
    
    ## imagesnap from brew install imagesnap
    ## -w : wait focus (sec)
    imagesnap -w 3 ${IMG}/isight_${timming}.png > /dev/null
    resize ${IMG}/isight_${timming}.png
    
    if [ -e ${IMG}/screen_${timming}.png ] && [ -e ${IMG}/isight_${timming}.png ] ; then
	convert -append \
		${IMG}/screen_${timming}.png \
		${IMG}/isight_${timming}.png \
		${IMG}/${timming}.png
    fi

    ## pngquant from brew install pngquant
    ## --ext .png --force : over write
    if [ -e ${IMG}/${timming}.png ]; then
	pngquant --ext .png --force ${IMG}/${timming}.png > /dev/null
    fi
    
    rm -f \
       ${IMG}/screen_${timming}.png \
       ${IMG}/isight_${timming}.png

    ${LIB}/img2photos.js ${IMG}/${timming}.png
        
    sleep ${INTERVAL}
done

