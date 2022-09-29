
variable "region" {
  
}

####### VPC ############
variable cidr {
}

variable vpc_name {
}


################ Subnets ###############
variable subnets {
}

########### Route Table##############
variable route_table_name {
}

###### SSM ################
variable "endpoints_subnet_cidr" {
  
}
variable "endpoints_subnet_az" {
  
}

############## IAM Role ###########
variable "role" {
  
}

variable "assume_role_policy" {
  
}

variable "policies" {
  
}

############# Security Groups ###################
variable "security_groups" {
  
}


##################### AUtoScaling Group ####################


variable "asg_name" {
  
}

variable "ami" {
  
}

variable "instance_type" {
  
}

variable "min_size" {
  
}

variable "max_size" {
  
}



variable "lc_security_groups" {
  
}
variable "vpc_zone_identifier" {
  
}
variable "root_volume_size" {
  
}


variable "desired_capacity" {
  
}


variable "directory" {
  
}
variable "eth_url" {
  
}
variable "key_name" {
  
}
variable "apiusername" {
  
}


##################Database################

variable "allocated_storage" {
  
}

variable "engine" {
  
}
variable "engine_version" {
  
}
variable "instance_class" {
  
}
variable "name" {
  
}
/*variable "db_name" {
  
}*/
variable "username" {
  
}

variable "skip_final_snapshot" {
  
}
variable "allow_major_version_upgrade" {
  
}
variable "auto_minor_version_upgrade" {
  
}
variable "apply_immediately" {
  
}
variable "backup_window" {
  
}
variable "backup_retention_period" {
  
}
variable "multi_az" {
  
}
variable "vpc_security_group_ids" {
  
}

variable "storage_encrypted" {
  
}
variable "logs" {
  
}
variable "port" {
  
}
variable "subnet_group_name" {
  
}
variable "subnet_ids" {
  
}
