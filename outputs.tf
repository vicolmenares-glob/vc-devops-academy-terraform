#Output variable#

output "ec2_instance_public_ip" {
  value = module.ec2_instances.public_ip

}

output "vpc_ip" {
  value = module.vc-vpc-tf.vpc_id
}

output "public-subnet" {
  value = module.vc-vpc-tf.public_subnets
}

output "private-subnet" {
  value = module.vc-vpc-tf.private_subnets
}

output "RDS_Endpoint" {
  value = module.vc-mysql-rds.this_db_instance_endpoint
}