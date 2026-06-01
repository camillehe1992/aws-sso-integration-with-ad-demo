environment = "prod"

vpc_cidr = "10.10.0.0/16"

public_subnet_cidrs = [
  "10.10.0.0/24",
  "10.10.1.0/24",
]

private_subnet_cidrs = [
  "10.10.10.0/24",
  "10.10.11.0/24",
]

# Enable NAT Gateway with Per AZ per NAT Gateway
enable_nat_gateway = true
single_nat_gateway = false
