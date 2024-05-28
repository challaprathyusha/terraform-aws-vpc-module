output "az_names" {
    value = data.aws_availability_zones.available.names
}

# output "vpc_id" {
#     value = aws_vpc.main.id
# }

output "igw_id" {
    value = aws_internet_gateway.gw.id
}

#if the value in outputs block is a list, as a best practice give output name as plural
output "public_subnet_ids" {
    value = aws_subnet.public[*].id
}

#if the value in outputs block is a list, as a best practice give output name as plural
output "private_subnet_ids" {
    value = aws_subnet.private[*].id
}

#if the value in outputs block is a list, as a best practice give output name as plural
output "database_subnet_ids" {
    value = aws_subnet.database[*].id
}
 
output "db_subnet_group_id" {
    value = aws_db_subnet_group.default.id
  
}

output "db_subnet_group_name" {
    value = aws_db_subnet_group.default.name
  
}

output "eip_allocation_id" {
    value = aws_eip.elastic_ip.allocation_id
  
}

output "nat_gateway_id" {
    value = aws_nat_gateway.nat_gw.id
  
}

output "public_route_table_id" {
    value = aws_route_table.public.id
  
}
output "private_route_table_id" {
    value = aws_route_table.private.id
  
}
output "database_route_table_id" {
    value = aws_route_table.database.id
  
}

output "vpc_peering_connection_id" {
    value = aws_vpc_peering_connection.peering[*].id
  
}