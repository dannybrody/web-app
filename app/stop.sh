#!/bin/bash -ex
RES_PID_FILE="/home/ubuntu/app.pid"
if [ -f $RES_PID_FILE ]; then
    PID=`head $RES_PID_FILE`
    kill -s SIGTERM $PID
    rm $RES_PID_FILE
    rm /home/ubuntu/out
fi
