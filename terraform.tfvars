
region = "us-east-1"

####### VPC ############
cidr = "10.10.0.0/16"
vpc_name = "chainlink"

################ Subnets ###############
subnets = [
    { subnet_name = "public", subnet_cidr = "10.10.1.0/24", az = "us-east-1a"},
    { subnet_name = "cl-1a", subnet_cidr = "10.10.2.0/24", az = "us-east-1a"},
    { subnet_name = "cl-1b", subnet_cidr = "10.10.3.0/24", az = "us-east-1b"},
    { subnet_name = "db-1a", subnet_cidr = "10.10.4.0/24", az = "us-east-1a"},
    { subnet_name = "db-1b", subnet_cidr = "10.10.5.0/24", az = "us-east-1b"},
]

########### Route Table##############
route_table_name = "public"

###### SSM ################
endpoints_subnet_cidr = "10.10.10.0/24"
endpoints_subnet_az = "us-east-1a"

############ IAM Role #################
role = "ec2"
assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
policies = [
    {name = "ssmaccess", policy = "AmazonSSMManagedInstanceCore"},
    {name = "cloudwatch", policy = "CloudWatchFullAccess"},
]

#################### Security Groups #########################
security_groups = [
  {
  sg_name = "node", description= " SG for nodes ", 
  inbound_rules =[
#{description="allow ssh",from_port=22,to_port=22,protocol="tcp",cidr=["10.10.10.0/24"]},
  ]
  },

  {
  sg_name = "DB", description= " SG for DB ", 
  inbound_rules =[
{description="allow DB access",from_port=5432,to_port=5432,protocol="tcp",cidr=["10.10.2.0/24","10.10.3.0/24"]},

  ]

  }
]


############# Auto Scaling Group ############################

    asg_name = "chainlink_nodes"
    ami = "ami-0cff7528ff583bf9a"
    instance_type = "t2.medium"
    #instance_type = "t2.micro"
    min_size = 1
    max_size = 2
    desired_capacity =1
    lc_security_groups =[ "node"]
    vpc_zone_identifier = ["cl-1a","cl-1b"]
    root_volume_size = 30
    key_name = "chainlink"
    #key_name=null

    directory = "chainlink-rinkeby"
    eth_url= "wss://rinkeby.infura.io/ws/v3/a0973843855047aab56e73afb316103d"
    apiusername = "murtuc83@yahoo.com"


############################Database###########################
  allocated_storage    = 100
  engine               = "postgres"
  engine_version       = "14.2"
  instance_class       = "db.t3.small"
  name                 = "chainlinkdb"
  #db_name= "postgres"
  username = "postgres"
 skip_final_snapshot  = true
  allow_major_version_upgrade = false
  auto_minor_version_upgrade = false
  apply_immediately = true
  subnet_group_name = "chainlink"
  backup_window = "06:00-07:00"
  backup_retention_period = 5
  multi_az = true
  vpc_security_group_ids = ["DB"]
  subnet_ids = ["db-1a","db-1b"]
  storage_encrypted = true
  logs = ["postgresql","upgrade"]
  port = 5432