variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" { }

variable "name" { }
variable "cidr" { }
variable "public_subnets" { default = "" }
variable "private_subnets" { default = "" }
variable "azs" { }
variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default = false
}
variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default = false
}


variable "environment" { default = "" }
variable "owner" {default = ""}
variable "purpose" {default = ""}
variable "costcenter" {default = ""}
variable "source" {default = ""}
