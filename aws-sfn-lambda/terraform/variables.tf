
variable "name" {
  default = "hello-sfn"
}

variable "env" {
  default = "dev"
}

variable "function_name" {
  default = "HelloWorldFunction"
}


##### VPC

variable "region" {
  default = "ap-northeast-1"
}

variable "zone" {
  type = map(string)
  default = {
    "a" = "ap-northeast-1a"
    "c" = "ap-northeast-1c"
  }
}

variable "vpc_cidr" {
  default = "172.30.0.0/16"
}

variable "subnet_cidr_public_a" {
  default = "172.30.0.0/24"
}

variable "subnet_cidr_public_c" {
  default = "172.30.1.0/24"
}

variable "subnet_cidr_private_a" {
  default = "172.30.2.0/24"
}

variable "subnet_cidr_private_c" {
  default = "172.30.3.0/24"
}

variable "subnet_cidr_protected_a" {
  default = "172.30.4.0/24"
}

variable "subnet_cidr_protected_c" {
  default = "172.30.5.0/24"
}


##### RDS

variable "db_database" {
  default = "db_example"
}

variable "db_username" {
  default = "docker"
}

variable "db_password" {
  default = "docker"
}
