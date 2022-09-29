
resource "aws_security_group" "sg" {
  name        = var.sg_name
  description = var.description
  vpc_id      = var.vpc_id


  tags = {
    Name = var.sg_name
  }

  dynamic "ingress" {
for_each = {for object in var.inbound_rules : object.description => object}
    content{
    description      = ingress.value.description
    from_port        = ingress.value.from_port
    to_port          = ingress.value.to_port
    protocol         = ingress.value.protocol
    cidr_blocks      = ingress.value.cidr
    }
  }

  }

resource "aws_security_group_rule" "sgrule_inbound_default" {
   
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "all"
    source_security_group_id = aws_security_group.sg.id
    security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "sgrule_outbound_default" {
   
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "all"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.sg.id
}



  
