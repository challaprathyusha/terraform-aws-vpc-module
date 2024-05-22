#resource block for vpc peering
resource "aws_vpc_peering_connection" "peering" {
    count = var.is_peering_required ? 1 : 0

    vpc_id        = aws_vpc.main.id #requestor 
#   peer_owner_id = var.peer_owner_id
    peer_vpc_id   = var.acceptor_vpc_id == "" ? data.aws_vpc.default_vpc.id : var.acceptor_vpc_id #acceptor 
#   both VPCs need to be in the same AWS account and region
#   If both VPCs are not in the same AWS account and region do not enable the auto_accept attribute
    auto_accept   = var.acceptor_vpc_id == "" ? true : false

    tags = merge(
        var.common_tags,
        var.vpc_peering_tags,
        {
        Name = local.resource_name
        }
    )
}

#adding routes to the peering connection in public route table
resource "aws_route" "public_peering" {
    count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
    route_table_id            = aws_route_table.public.id
    destination_cidr_block    = data.aws_vpc.default_vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
}
#doubt if acceptor_vpc_id is not empty means if acceptor vpc is provided in user inputs, then how to write resource block
# to add routes 


#adding routes to the peering connection in private route table
resource "aws_route" "private_peering" {
    count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
    route_table_id            = aws_route_table.private.id
    destination_cidr_block    = data.aws_vpc.default_vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
}

#adding routes to the peering connection in database route table
resource "aws_route" "database_peering" {
    count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
    route_table_id            = aws_route_table.database.id
    destination_cidr_block    = data.aws_vpc.default_vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
}

#adding routes to the peering connection in default vpc main route table
resource "aws_route" "default_vpc_peering" {
    count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
    route_table_id            = data.aws_route_table.main_default_vpc.id
    destination_cidr_block    = var.vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
}