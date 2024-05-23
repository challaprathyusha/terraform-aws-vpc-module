# custom aws vpc module

![alt text](vpc_module_diagram_2_lyst1715839481379.jpeg)

This module is developed for joindevops.com. In this module you can find resource blocks for below mentioned services in aws.This module can create resources in first two AZ's for HA.

* VPC
* IGW
* IGW attachment to VPC
* 2 public subnets
* 2 private subnets
* 2 database subnets
* Database subnet group
* Elastic ip address
* NAT gateway
* public route table
* private route table
* database route table
* adding routes to all route tables
* route table and subnet associations
* peering if required
* routes for peering in requestor and acceptor vpc

## Inputs
* project_name(required):Type is string. User should provide the value as per their project name.
* environment(optional):Type is string. Default value is empty.
* common_tags(required):Type is map. User should provide the tags related to their project.
* vpc_cidr(optional):Type is string. Default value is 10.0.0.0/16.
* enable_dns_hostname(optional):Type is bool. Default value is true.
* vpc_tags(optional):Type is map. Default value is empty.
* igw_tags(optional):Type is map. Default value is empty.
* public_subnet_tags(optional):Type is map. Default value is empty.
* public_subnet_cidrs(required):Type is list. User must provide 2 valid subnet CIDR.
* private_subnet_tags(optional):Type is map. Default value is empty.
* private_subnet_cidrs(required):Type is list. User must provide 2 valid subnet CIDR.
* database_subnet_tags(optional):Type is map. Default value is empty.
* database_subnet_cidrs(required):Type is list. User must provide 2 valid subnet CIDR.
* db_subnet_group_tags(optional):Type is map. Default value is empty.
* nat_gateway_tags(optional):Type is map. Default value is empty.
* public_routetable_tags(optional):Type is map. Default value is empty.
* private_routetable_tags(optional):Type is map. Default value is empty.
* database_routetable_tags(optional):Type is map. Default value is empty.
* is_peering_required(optional):Type is bool. Default value is false.
* vpc_peering_tags(optional):Type is map. Default value is empty.
* acceptor_vpc_id(optional):Type is string. Default value is empty.

## Outputs
* az_names:List of availability zone names are fetched from aws using data sources
* vpc_id:VPC ID is created
* igw_id:Internet gateway ID is created
* public_subnet_ids:A list of 2 public subnet IDS created
* private_subnet_ids:A list of 2 private subnet IDS created
* database_subnet_ids:A list of 2 database subnet IDS created
* db_subnet_group_id:A database subnet group ID is created
* eip_allocation_id:An Elastic IP allocation ID is created
* nat_gateway_id:NAT gateway ID is created
* public_route_table_id:A public route table ID is created
* private_route_table_id:A private route table ID is created
* database_route_table_id:A database route table ID is created
* vpc_peering_connection_id:VPC peering connection ID is created



