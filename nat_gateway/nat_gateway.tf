
resource "aws_eip" "public_ip" {
  
}

resource "aws_nat_gateway" "nat_gw" {

  allocation_id = aws_eip.public_ip.id
  subnet_id     = var.subnet_id
}