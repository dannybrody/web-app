# AWS Scalable HA multi AZ Web Application and Jenkins with Persistent Encrypted Storage

This project covers provisioning all infra for AWS for a highly available web application with continuous integration via jekins with persistent storage.  This includes domain name creation with SSL certifcate which will allow jenkins traffic to be encrypted along with having a persistent encrypted EFS drive for fault tolerance.  The web application is written in GO using the beego framework.  Sessions are cached with Redis via elasticache while data related to the users is stored on a highly available AUrora database.


## Getting Started

These instructions will get you a copy of the project up and running on AWS. See deployment.

### Prerequisites

You must have the following:
AWS IAM user credentials with the proper permissions to provision all the services.
JQ and the aws cli tool installed
Completely filled out infra/variables.sh file with all of your values.

```
Please look at the provided variables template and modify all values with your own.
```

### Installing

* [AWSCLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
* [JQ](https://stedolan.github.io/jq/download/)

## Deployment

If you need to register a domain do so first

```
./infra/register-domain.sh
```
Once complete, you will receive an email from amazon to validate that you want to register the domain.  Accept the email and in about 15 to 30 minutes you should see your domain listed in route53.

Once you see the domain active in AWS proceed to launch the infra
```
./infra/launch-infra.sh
```
During this process you will receive another email from amazon about verifying your SSL certficate.  You must open and click 'I agree'. 

Next you can start setting up Jenkins
```
https://jenkins.yourdomain.com
```

From here you can use the code base in the app folder and create your own repo and configure jenkins access to allow continous deployment on commits to the master branch.