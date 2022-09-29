
resource "aws_route_table" "rt" {

  vpc_id = var.vpc_id
 
   tags = {
    Name = var.route_table_name
  }

}

resource "aws_route_table_association" "a" {

  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.rt.id
}