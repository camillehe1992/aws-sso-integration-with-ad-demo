variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
}

variable "name" {
  description = "Base name used for resource naming (e.g., app or project name)."
  type        = string
  default     = "sso"
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)."
  type        = string
  default     = "dev"
}

variable "default_tags" {
  description = "User-supplied tags merged with mandatory tags in main.tf."
  type        = map(string)
  default     = {}
}

variable "az_count" {
  description = "Number of Availability Zones to use (Console 'VPC and more' typically uses 2)."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2
    error_message = "az_count must be at least 2."
  }
}

variable "vpc_cidr" {
  description = "VPC IPv4 CIDR block."
  type        = string
}

variable "enable_dns_support" {
  description = "Whether to enable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether to enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

variable "instance_tenancy" {
  description = "A VPC tenancy option. Valid values: default, dedicated."
  type        = string
  default     = "default"

  validation {
    condition     = contains(["default", "dedicated"], var.instance_tenancy)
    error_message = "instance_tenancy must be one of: default, dedicated."
  }
}

variable "public_subnet_cidrs" {
  description = "List of IPv4 CIDR blocks for public subnets. Provide at least one per AZ (recommended: exactly az_count entries)."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) >= var.az_count
    error_message = "public_subnet_cidrs must contain at least az_count CIDRs (one per AZ)."
  }
}

variable "private_subnet_cidrs" {
  description = "List of IPv4 CIDR blocks for private subnets. Provide at least one per AZ (recommended: exactly az_count entries)."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) >= var.az_count
    error_message = "private_subnet_cidrs must contain at least az_count CIDRs (one per AZ)."
  }
}

variable "public_subnet_map_public_ip_on_launch" {
  description = "Whether to auto-assign public IPs for instances launched in public subnets."
  type        = bool
  default     = true
}

variable "private_subnet_map_public_ip_on_launch" {
  description = "Whether to auto-assign public IPs for instances launched in private subnets."
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway resources and private default routes to NAT."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "When enable_nat_gateway is true, create a single NAT Gateway (instead of one per AZ) and route all private route tables to it."
  type        = bool
  default     = false
}

variable "nat_gateway_connectivity_type" {
  description = "NAT Gateway connectivity type. Valid values: public (most common), private."
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private"], var.nat_gateway_connectivity_type)
    error_message = "nat_gateway_connectivity_type must be one of: public, private."
  }
}

variable "internet_route_destination_cidr" {
  description = "Destination CIDR used for default internet routes in public and private route tables."
  type        = string
  default     = "0.0.0.0/0"
}
