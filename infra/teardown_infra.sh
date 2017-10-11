#!/bin/bash
source ./variables.sh

#Delete keypair
aws ec2 delete-key-pair --key-name $STACK
if [ -f ${STACK}.pem ]; then
	rm ${STACK}.pem
fi

aws cloudformation delete-stack --stack-name $STACK 2>>/dev/null

#TODO Delete domain if created by aws
