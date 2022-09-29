
module vpc {
    source = "./vpc"

    cidr = var.cidr
    vpc_name = var.vpc_name

}

module subnet {
    source = "./subnet"
    for_each = {for object in var.subnets : object.subnet_name => object}
    

    vpc_id = module.vpc.vpc_id
    subnet_cidr = each.value.subnet_cidr
    az = each.value.az
    subnet_name = each.value.subnet_name
  }

  module internet_gateway{
    source = "./internet_gateway"

    vpc_id = module.vpc.vpc_id
}

module route_table{
source = "./route_table"

vpc_id = module.vpc.vpc_id
route_table_name = var.route_table_name
subnet_id = module.subnet["public"].subnet_id

}

module "nat_gateway" {
  source = "./nat_gateway"
  subnet_id = module.subnet["public"].subnet_id

  }

  module "inertnet_gateway_route" {
    source = "./route"

    route_table_id = module.route_table.route_table_id
    dest_cidr = "0.0.0.0/0"
    nat_gateway_id = null
    internet_gateway_id  = module.internet_gateway.internet_gateway_id

  }

    module "nat_gateway_route" {
    source = "./route"

    route_table_id = module.vpc.default_route_table_id
    dest_cidr = "0.0.0.0/0"
    nat_gateway_id = module.nat_gateway.nat_gateway_id
    internet_gateway_id  = null

  }

  module "ssm" {
    source = "./ssm"

    vpc_id = module.vpc.vpc_id
    cidr= var.cidr
    endpoints_subnet_cidr = var.endpoints_subnet_cidr
    endpoints_subnet_az = var.endpoints_subnet_az
    ssm_region = var.region
    
  }

  module "iam_role" {
    source = "./iam_role"
    role = var.role
    assume_role_policy = var.assume_role_policy
    policies = var.policies
  }

  module "security_group" {
    source = "./security_group"
    for_each = {for object in var.security_groups : object.sg_name => object}

    sg_name = each.value.sg_name
    description = each.value.description
    vpc_id = module.vpc.vpc_id
    inbound_rules = each.value.inbound_rules

  }

  module "auto_scaling_group" {
    source = "./asg"
depends_on = [
  module.internet_gateway,module.nat_gateway,module.inertnet_gateway_route,module.nat_gateway_route
]
    asg_name = var.asg_name
    ami = var.ami
    instance_type = var.instance_type
    min_size = var.min_size
    max_size = var.max_size
    desired_capacity = var.desired_capacity
    instance_profile = module.iam_role.instance_profile
    lc_security_groups =[ for sg in var.lc_security_groups : module.security_group[sg].sg_id]
    vpc_zone_identifier = [for subnet in var.vpc_zone_identifier : module.subnet[subnet].subnet_id]
    root_volume_size = var.root_volume_size
    key_name = var.key_name
    user_data = templatefile("${path.module}/userdata/userdata.tftpl",
    {
      directory = var.directory,
      eth_url = var.eth_url,
      dbusername = var.username
      dbpassword = random_password.db_password.result
      dbendpoint = module.database.db_endpoint
      dbname = module.database.db_name
      apiusername = var.apiusername
      apipassword =  random_password.api_password.result
      walletpassword =  random_password.wallet_password.result
    }
)
#user_data  =null
}

resource "random_id" "random" {
  byte_length           = 5
}

resource "random_password" "db_password" {
  length           = 16
  special          = false
}
resource "random_password" "api_password" {
  length           = 16
  special          = false
}
resource "random_password" "wallet_password" {
  length           = 16
  special          = false
}

locals {
  secret = {
    dbpassword =  random_password.db_password.result
    apipassword =  random_password.api_password.result
    walletpassword =  random_password.wallet_password.result
  }
}

resource "aws_secretsmanager_secret" "secret" {
  name = "chainlink-${random_id.random.hex}"
}
resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(local.secret)
}

module "database" {
  source="./database"
    allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.name
  #db_name= var.db_name
  username             = var.username
  password             = random_password.db_password.result
  skip_final_snapshot  = var.skip_final_snapshot
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately = var.apply_immediately
  subnet_group_name = var.subnet_group_name
  backup_window = var.backup_window
  backup_retention_period = var.backup_retention_period
  multi_az = var.multi_az
  vpc_security_group_ids = [ for sg in var.vpc_security_group_ids : module.security_group[sg].sg_id]
  subnet_ids = [for subnet in var.subnet_ids : module.subnet[subnet].subnet_id]
  storage_encrypted = var.storage_encrypted
  logs = var.logs
  port = var.port
  
}