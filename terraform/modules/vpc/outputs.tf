output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "intra_subnets" {
  value = module.vpc.intra_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "intra_route_table_ids" {
  value = module.vpc.intra_route_table_ids
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}
