#!/bin/bash -ex
sudo chown -R ubuntu:ubuntu /home/ubuntu/
cd /home/ubuntu/gocode/src/app/
rm -r vendor
go get github.com/astaxie/beego
go get
go build
nohup /home/ubuntu/gocode/src/app/app > /home/ubuntu/out 2> /home/ubuntu/error &
echo $! > /home/ubuntu/app.pid
