#!/bin/bash -e

EXISTS=$(which jq 2>>/dev/null)
if [ $? -ne 0 ]; then
	echo "you must have jq installed on your system"
	exit
fi
EXISTS=$(which aws 2>>/dev/null)
if [ $? -ne 0 ]; then
	echo "you must have aws installed on your system"
	exit
fi

source ./variables.sh

#Make sure domain name exists before launching infra
EXISTS=$(aws route53domains --region us-east-1 list-domains \
	--query "Domains[?DomainName==\`$DOMAIN\`].DomainName" \
	--output text)

if [ "$EXISTS" != "$DOMAIN" ];then
	echo "domain $DOMAIN has not completed registration yet, please verify the email and try again"
	exit
fi

#Sync all templates to s3 for provisioning
echo "syncing templates to s3"
for TEMPLATE in *.yaml; do
    [ -f "$TEMPLATE" ] || break
    aws s3 cp $TEMPLATE s3://${TEMPLATE_S3_DIR}${TEMPLATE}
done

#Create keypair if it doesnt exist
EXISTS=$(aws ec2 describe-key-pairs --key-name $STACK 2>>/dev/null)
if [ $? -ne 0 ]; then
	echo "creating keypair"
	aws ec2 create-key-pair --key-name $STACK --query 'KeyMaterial' --output text > $STACK.pem
fi

#Launch/update Infra templates
echo "updating/creating infra stacks"
EXISTS=$(aws cloudformation describe-stacks --stack-name $STACK 2>>/dev/null)
if [ $? -eq 0 ]; then
	RESULT=$(aws cloudformation update-stack \
		--stack-name $STACK \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-url https://s3.amazonaws.com/${TEMPLATE_S3_DIR}master.yaml \
		--parameters \
			ParameterKey=DomainName,ParameterValue=${DOMAIN})
else
	echo "check your email: $Email and agree to certificate creation while stack is in progress"
	RESULT=$(aws cloudformation create-stack \
		--stack-name $STACK \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-url https://s3.amazonaws.com/${TEMPLATE_S3_DIR}master.yaml \
		--parameters \
			ParameterKey=DomainName,ParameterValue=${DOMAIN})
fi

#Wait for result
while true; do
	STATUS=$(aws cloudformation \
		describe-stacks --stack-name $STACK | jq .Stacks[0].StackStatus | tr -d \")
	if [ "$STATUS" == "CREATE_COMPLETE" ] || [ "$STATUS" == "UPDATE_COMPLETE" ] || [ "$STATUS" == "UPDATE_ROLLBACK_COMPLETE" ];then
		echo $STATUS
		break
	elif [ "$STATUS" == "UPDATE_ROLLBACK_COMPLETE" ];then
		echo "error updating template: $STATUS"
		echo "fix any errors and try again"
		exit
	fi
	sleep 5
done
