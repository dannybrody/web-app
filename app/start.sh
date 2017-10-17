#!/bin/bash -ex
sudo chown -R ubuntu:ubuntu /home/ubuntu/
export PATH=$PATH:/usr/local/go/bin
export GOPATH=/home/ubuntu/gocode
nohup /home/ubuntu/gocode/src/app/app > /home/ubuntu/out 2> /home/ubuntu/error &
echo $! > /home/ubuntu/app.pid
