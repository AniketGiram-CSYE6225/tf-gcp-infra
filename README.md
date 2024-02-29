Enabled Google API

`Compute Engine API`

`Service Networking API`

# Commands

To create resource using this template you must have terraform installed 

To Initialize the Project

`terraform init`

To validate the template

`terraform validate`

To Plan the resources

`terraform plan`

To create the resources

`terraform apply`

You need varibale file `terraform.tfvars` to setup the resources

# Variables

```
project_name             = ""
region                   = ""
network_name             = ""
webapp_subnet            = ""
webapp_ip_range          = ""
db_subnet                = ""
db_ip_range              = ""
route_name               = ""
default_gateway_ip_range = ""
```
