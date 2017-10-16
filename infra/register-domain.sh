#!/bin/bash -e
source ./variables.sh

echo "Checking if domain needs to be created"
EXISTS=$(aws route53domains --region us-east-1 list-domains \
	--query "Domains[?DomainName==\`$DOMAIN\`].DomainName" \
	--output text)

if [ "$EXISTS" != "$DOMAIN" ];then
	AVAILABLE=$(aws route53domains --region us-east-1 check-domain-availability \
		--domain-name $DOMAIN \
		--query 'Availability' \
		--output text)
	if [ "$AVAILABLE" != "AVAILABLE" ];then
		echo "$DOMAIN is already taken, please use a different domain name and try again"
	else
		echo "creating the domain $DOMAIN"
		OPERATION_ID=$(aws route53domains --region us-east-1 register-domain \
			--domain-name $DOMAIN \
			--duration-in-years 1\
			--admin-contact $ADMIN_CONTACT \
			--registrant-contact $ADMIN_CONTACT \
			--tech-contact $ADMIN_CONTACT \
			--query 'OperationId' \
			--output text)
		echo $OPERATION_ID
		echo "Check email $Email to verify domain registration"
	fi
fi
