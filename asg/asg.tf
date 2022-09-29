
resource "aws_launch_configuration" "launch_conf" {
  name_prefix = var.asg_name
  image_id      = var.ami
  instance_type = var.instance_type
  iam_instance_profile = var.instance_profile
  security_groups = var.lc_security_groups
  user_data = var.user_data
  key_name= var.key_name
  
  root_block_device {
    volume_size = var.root_volume_size
    delete_on_termination = true
  }
  lifecycle {
    create_before_destroy = true
  }
  
}

resource "aws_autoscaling_group" "asg" {
  name                 = var.asg_name
  launch_configuration = aws_launch_configuration.launch_conf.name
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity = var.desired_capacity
vpc_zone_identifier = var.vpc_zone_identifier
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "${var.asg_name}-${formatdate("DD MMM YYYY hh:mm ZZZ",timestamp())}"
    propagate_at_launch = true
  }
}