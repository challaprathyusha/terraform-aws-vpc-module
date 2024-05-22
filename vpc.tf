#resource block for VPC
resource "aws_vpc" "main" {
    cidr_block       = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
        Name = local.resource_name
    }
  )
}

#resource block for IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags =  merge(
    var.common_tags,
    var.igw_tags,
    {
      Name = local.resource_name
    }
  )
}

#resource block for public subnets
#two public subnets in two AZs us-east-1a and us-east-1b
resource "aws_subnet" "public" {

  count = length(var.public_subnet_cidrs)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone  =  local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
      Name = "${local.resource_name}-public-${local.az_names[count.index]}"
    }
  )
}

#resource block for private subnets
#two private subnets in two AZs us-east-1a and us-east-1b
resource "aws_subnet" "private" {

  count = length(var.private_subnet_cidrs)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone  =  local.az_names[count.index]

  tags = merge(
    var.common_tags,
    var.private_subnet_tags,
    {
      Name = "${local.resource_name}-private-${local.az_names[count.index]}"
    }
  )
}

##resource block for database subnets
#two database subnets in two AZs us-east-1a and us-east-1b
resource "aws_subnet" "database" {

  count = length(var.database_subnet_cidrs)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]

tags = merge(
    var.common_tags,
    var.database_subnet_tags,
    {
      Name = "${local.resource_name}-database-${local.az_names[count.index]}"
    }
  )
}

#DB subnet group for database subnets
resource "aws_db_subnet_group" "default" {
  name       = local.resource_name
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    var.common_tags,
    var.db_subnet_group_tags,
    {
      Name = "${local.resource_name}"
    }
  )
}

#resource block for elastic ip
resource "aws_eip" "elastic_ip" {
  domain   = "vpc"
}

#resource block for nat gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.elastic_ip.allocation_id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    var.nat_gateway_tags,
    {
      Name = local.resource_name 
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw] #this is explicit dependency
}

#resource block for public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.public_routetable_tags,
    {
      Name = "${local.resource_name}-public"
    }
  )
}

#resource block for private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.private_routetable_tags,
    {
      Name = "${local.resource_name}-private"
    }
  )
}

#resource block for database route table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.database_routetable_tags,
    {
      Name = "${local.resource_name}-database"
    }
  )
}

#resource block to add routes in public route table
resource "aws_route" "public_routetable_igw" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

#resource block to add routes in private route table
resource "aws_route" "private_routetable_nat" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.nat_gw.id
}

#resource block to add routes in database route table
resource "aws_route" "database_routetable_nat" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.nat_gw.id
}

#resource block for public subnets association to public route table
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#resource block for private subnets association to private route tables
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

#resource block for database subnets association to database route tables
resource "aws_route_table_association" "database" {
  count = length(aws_subnet.database)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}