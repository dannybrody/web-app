# web-app
web-app for aws with infra and jenkins

To provision the infra all variables defined in infra/varaibles.sh must be filled out

The first step is to create a domain name in aws:
./infra/register-domain.sh

Then create all infra related to the project:
./infra/launch-infra.sh

