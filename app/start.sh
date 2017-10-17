#!/bin/bash -ex
sudo chown -R ubuntu:ubuntu /home/ubuntu/
nohup /home/ubuntu/gocode/src/app/app > out 2>error &
echo $! > /home/ubuntu/app.pid
