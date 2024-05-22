#list of availability zone names in us-east-1 region are fetched from AWS
data "aws_availability_zones" "available" {
  state = "available"
}

#default vpc available in aws us-east-1 region is fetched
data "aws_vpc" "default_vpc" {
  default = true
} 

#main route table of default vpc is fetched 
data "aws_route_table" "main_default_vpc" {
  vpc_id = data.aws_vpc.default_vpc.id
  filter {
    name = "association.main"
    values = ["true"]
  }
}