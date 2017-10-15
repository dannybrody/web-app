#!/bin/bash

which jq >/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
	echo "you must have jq installed on your system"
	exit
fi
which aws >/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
	echo "you must have aws installed on your system"
	exit
fi

source ./variables.sh
# aws deploy list-deployments --application-name web-app --deployment-group-name web-app-App-AKAU849VK4QV-DeploymentGroup-165LJI000IZOB
# exit

#Make sure domain name exists before launching infra
EXISTS=$(aws route53domains --region us-east-1 list-domains \
	--query "Domains[?DomainName==\`$DOMAIN\`].DomainName" \
	--output text)

if [ "$EXISTS" != "$DOMAIN" ];then
	echo "domain $DOMAIN has not completed registration yet, please verify the email and try again"
	exit
fi


#Create SSL Certificate for site if it does not exist
EXISTS=$(aws acm list-certificates \
	--query "CertificateSummaryList[?DomainName==\`"*."$DOMAIN\`].DomainName" \
	--output text)

if [ "$EXISTS" != "*.${DOMAIN}" ];then
	echo "creating certificate for $DOMAIN"
	RESULT=$(aws acm request-certificate --domain-name "*.${DOMAIN}" --output text)
	echo "check your email: $Email and agree to certificate creation"
fi

CERTIFICATE_ARN=$(aws acm list-certificates \
	--query "CertificateSummaryList[?DomainName==\`"*."$DOMAIN\`].CertificateArn" \
	--output text)

#Sync all templates to s3 for provisioning
echo "syncing templates to s3"
for TEMPLATE in *.yaml; do
    [ -f "$TEMPLATE" ] || break
    aws s3 cp $TEMPLATE s3://${S3_BUCKET}/${S3_PREFIX}/${TEMPLATE}
done
# exit
#Create keypair if it doesnt exist
EXISTS=$(aws ec2 describe-key-pairs --key-name $STACK)
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
		--template-url https://s3.amazonaws.com/${S3_BUCKET}/${S3_PREFIX}/master.yaml \
		--parameters \
			ParameterKey=DomainName,ParameterValue=${DOMAIN} \
			ParameterKey=KeyName,ParameterValue=${STACK} \
			ParameterKey=Certificate,ParameterValue=${CERTIFICATE_ARN} \
			ParameterKey=S3Bucket,ParameterValue=${S3_BUCKET} \
			ParameterKey=S3Prefix,ParameterValue=${S3_PREFIX})
else
	RESULT=$(aws cloudformation create-stack \
		--stack-name $STACK \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-url https://s3.amazonaws.com/${S3_BUCKET}/${S3_PREFIX}/master.yaml \
		--parameters \
			ParameterKey=DomainName,ParameterValue=${DOMAIN} \
			ParameterKey=KeyName,ParameterValue=${STACK} \
			ParameterKey=Certificate,ParameterValue=${CERTIFICATE_ARN} \
			ParameterKey=S3Bucket,ParameterValue=${S3_BUCKET} \
			ParameterKey=S3Prefix,ParameterValue=${S3_PREFIX})
fi

#Wait for result
while true; do
	STATUS=$(aws cloudformation \
		describe-stacks --stack-name $STACK | jq .Stacks[0].StackStatus | tr -d \")
	if [ "$STATUS" == "CREATE_COMPLETE" ] || [ "$STATUS" == "UPDATE_COMPLETE" ];then
		echo $STATUS
		break
	elif [ "$STATUS" == "UPDATE_ROLLBACK_COMPLETE" ];then
		echo "error updating template: $STATUS"
		echo "fix any errors and try again"
		exit
	fi
	sleep 5
done


#Get jenkins initial password if it exists
aws s3 cp s3://${S3_BUCKET}/${S3_PREFIX}/initialAdminPassword . >/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
	exit
else
	JENKINS_PW=$(cat initialAdminPassword)
	rm initialAdminPassword
	aws s3 rm s3://${S3_BUCKET}/${S3_PREFIX}/initialAdminPassword >/dev/null 2>/dev/null
	echo "visit https://jenkins.${DOMAIN} and enter $JENKINS_PW to configure and setup your jenkins machine"
fi

