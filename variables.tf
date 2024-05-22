###project variables###
#project variables are declared such that this module should be used for all the projects 
variable "project_name" {
    type = string
}

variable "environment" {
    type = string
    default = "dev"
}

variable "common_tags" {
    type = map  
}

##VPC variables##
variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type = bool
    default = true
}

variable "vpc_tags" {
    type = map
    default = {}
}

###IGW###
variable "igw_tags" {
    type = map
    default = {}
}

##public subnets##
variable "public_subnet_tags" {
    type = map
    default = {}
}

variable "public_subnet_cidrs" {
    type = list
    validation {
      condition = length(var.public_subnet_cidrs) == 2
      error_message = "please create only 2 public subnets each with valid cidr range "
    }
}

##private subnets##
variable "private_subnet_tags" {
    type = map
    default = {}
}

variable "private_subnet_cidrs" {
    type = list
    validation {
      condition = length(var.private_subnet_cidrs) == 2
      error_message = "please create only 2 private subnets each with valid cidr range "
    }
}

##database subnets##
variable "database_subnet_tags" {
    type = map
    default = {}
}

variable "database_subnet_cidrs" {
    type = list
    validation {
      condition = length(var.database_subnet_cidrs) == 2
      error_message = "please create only 2 database subnets each with valid cidr range "
    }
}

variable "db_subnet_group_tags" {
    type = map
    default = {}
}

##NAT gateway tags##
variable "nat_gateway_tags" {
    type = map
    default = {}
}

##public route table##
variable "public_routetable_tags" {
    type = map
    default = {}
}

##private route table##
variable "private_routetable_tags" {
    type = map
    default = {}
}

##database route table##
variable "database_routetable_tags" {
    type = map
    default = {}
}

##vpc-peering##
variable "is_peering_required" {
    type = bool
    default = false
}

variable "vpc_peering_tags" {
    type = map
    default = {}
}

variable "acceptor_vpc_id" {
    type = string
    default = ""
}