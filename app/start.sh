#!/bin/bash -ex
sudo chown -R ubuntu:ubuntu /home/ubuntu/
export GOPATH=/home/ubuntu/gocode/
go get github.com/astaxie/beego
nohup /home/ubuntu/gocode/src/app/app > /home/ubuntu/out 2> /home/ubuntu/error &
echo $! > /home/ubuntu/app.pid
