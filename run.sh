#!/bin/sh

echo "Don't work on TMUX"

nohup ./isight.sh > /dev/null 2>&1 &
ps -ef | grep 'bash' | grep 'isight.sh' | grep -v 'grep'
