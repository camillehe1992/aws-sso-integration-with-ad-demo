environment = "dev"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.0.0/24",
  "10.0.1.0/24",
]

private_subnet_cidrs = [
  "10.0.10.0/24",
  "10.0.11.0/24",
]

# Enable NAT Gateway with single NAT Gateway
enable_nat_gateway = false
single_nat_gateway = true
