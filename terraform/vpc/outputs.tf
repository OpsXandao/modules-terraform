output "vpc_id" {
  description = "ID da VPC"
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs das Subnets públicas"
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs das Subnets privadas"
  value = aws_subnet.private[*].id
}

output "igw_id" {
  description = "ID do Internet Gateway"
  value = aws_internet_gateway.this.id
}

output "route_table_id" {
  description = "ID da tabela de rotas pública"
  value = aws_route_table.public.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.this[*].id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}
