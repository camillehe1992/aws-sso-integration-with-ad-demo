locals {
  nat_gateway_per_az_enabled  = var.enable_nat_gateway && !var.single_nat_gateway
  nat_gateway_single_enabled  = var.enable_nat_gateway && var.single_nat_gateway
  nat_gateway_private_rt_keys = var.enable_nat_gateway ? local.az_map : {}
}

resource "aws_eip" "nat" {
  for_each = local.nat_gateway_per_az_enabled ? local.az_map : {}

  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-nat-eip-${each.key}"
  }
}

resource "aws_nat_gateway" "this" {
  for_each = local.nat_gateway_per_az_enabled ? local.az_map : {}

  allocation_id     = aws_eip.nat[each.key].id
  connectivity_type = var.nat_gateway_connectivity_type

  subnet_id = element(
    [for s in aws_subnet.public : s.id if s.availability_zone == each.key],
    0
  )

  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = "${local.name_prefix}-nat-${each.key}"
  }
}

resource "aws_eip" "nat_single" {
  count = local.nat_gateway_single_enabled ? 1 : 0

  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-nat-eip"
  }
}

resource "aws_nat_gateway" "single" {
  count = local.nat_gateway_single_enabled ? 1 : 0

  allocation_id     = aws_eip.nat_single[0].id
  connectivity_type = var.nat_gateway_connectivity_type
  subnet_id         = aws_subnet.public[tostring(0)].id

  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = "${local.name_prefix}-nat"
  }
}

resource "aws_route" "private_nat_access_per_az" {
  for_each = local.nat_gateway_per_az_enabled ? local.az_map : {}

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = var.internet_route_destination_cidr
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
}

resource "aws_route" "private_nat_access_single" {
  for_each = local.nat_gateway_single_enabled ? local.az_map : {}

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = var.internet_route_destination_cidr
  nat_gateway_id         = aws_nat_gateway.single[0].id
}
