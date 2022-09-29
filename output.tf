/*
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
    value = module.subnet
}

output "internet_gateway_id" {
  value = module.internet_gateway.internet_gateway_id
}

output "route_table_id" {
  value = module.route_table.route_table_id
}

output "nat_gateway_id" {
  value = module.nat_gateway.nat_gateway_id
}

output "role" {
  value = module.iam_role.role
}

output "instance_profile" {
  value = module.iam_role.instance_profile
}

output "policies" {
  value = module.iam_role.policies
}

output "asg" {
  value = module.auto_scaling_group.asg
}*/

output "db_endpoint" {
  value = module.database.db_endpoint
}
