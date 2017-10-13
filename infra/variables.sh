#!/bin/bash
#Required for aws calls
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=

#Required for cloudformation
export STACK="<cloudformation stack name>"
export TEMPLATE_S3_DIR="<s3bucket/prefix/>"
export DOMAIN="<domain name>"

#Required if you would like amazon to create a domain for you
#Note: You must put a valid email address in order to vaidate the domain creation
export FirstName=
export LastName=
export ContactType="PERSON"
export City=
export State=
export CountryCode="US"
export Email=
export PhoneNumber="+1.9999999999"
export AddressLine1=
export ZipCode=

export ADMIN_CONTACT="FirstName=$FirstName,LastName=$LastName,ContactType=$ContactType,City=$City,State=$State,CountryCode=$CountryCode,Email=$Email,PhoneNumber=$PhoneNumber,AddressLine1=$AddressLine1,ZipCode=$ZipCode"
