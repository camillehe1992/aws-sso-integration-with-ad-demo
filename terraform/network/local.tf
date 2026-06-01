data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name_prefix = "${var.name}-${var.environment}"
  azs         = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  az_map      = { for az in local.azs : az => az }

  public_subnets = {
    for idx, cidr in var.public_subnet_cidrs :
    idx => {
      cidr = cidr
      az   = local.azs[idx % var.az_count]
    }
  }

  private_subnets = {
    for idx, cidr in var.private_subnet_cidrs :
    idx => {
      cidr = cidr
      az   = local.azs[idx % var.az_count]
    }
  }
}
