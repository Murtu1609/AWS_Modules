
resource "aws_route" "r" {

  route_table_id              = var.route_table_id
  destination_cidr_block = var.dest_cidr
  nat_gateway_id      = var.nat_gateway_id
  gateway_id = var.internet_gateway_id
}