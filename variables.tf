#Define Variables#

variable "vc-vpc" {
  description = "VPC Globant"
  type        = string
  default     = "glob-vpc"

}

variable "vpc-cidr" {
  description = "CIDR block for glob VPC"
  type        = string
  default     = "10.0.0.0/16"

}

variable "vpc-azs" {
  description = "Availability zones for glob VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vc-pv-sn" {
  description = "Private Subnet for glob VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vc-pb-sn" {
  description = "Public subnets for glob VPC"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "vc-tags" {
  description = "tags to all VPC module"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
    Company     = "globant"
  }
}

variable "key" {
  description = "Key for instance"
  default     = "victorkey"
}

variable "cidr-web-sg" {
  description = "CIDR block for web security group"
  type        = string
  default     = "0.0.0.0/0"
}

variable "rds-pass" {
  description = "pass of rds db"
  type        = string
  default     = "globantdbuniversity"
}

variable "cidr-rds-sg" {
  description = "CIDR block for rds security group"
  type        = string
  default     = "0.0.0.0/0"
}

variable "rds-sn" {
  description = "Subnets for RDS instance"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}