output "availability_zones" {
  description = "Availability Zones selected for this VPC."
  value       = local.azs
}

output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs (in the same order as var.public_subnet_cidrs)."
  value = [
    for i in range(length(var.public_subnet_cidrs)) : aws_subnet.public[tostring(i)].id
  ]
}

output "private_subnet_ids" {
  description = "Private subnet IDs (in the same order as var.private_subnet_cidrs)."
  value = [
    for i in range(length(var.private_subnet_cidrs)) : aws_subnet.private[tostring(i)].id
  ]
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs. When enable_nat_gateway=false this is empty; when single_nat_gateway=true all AZs map to the same NAT Gateway ID."
  value = var.enable_nat_gateway ? (
    var.single_nat_gateway ? { for az in local.azs : az => aws_nat_gateway.single[0].id } : { for az in local.azs : az => aws_nat_gateway.this[az].id }
  ) : {}
}
