  variable "aws_region" {
    type    = string
    default = "us-east-1"
  }

  variable "name" {
    description = "Nome da VPC"
    type        = string
  }

  variable "cidr_block" {
    description = "Bloco CIDR da VPC"
    type        = string
  }

  variable "enable_dns_support" {
    description = "Habilitar suporte a DNS"
    type        = bool
    default     = true
  }

  variable "enable_dns_hostnames" {
    description = "Habilitar hostnames DNS"
    type        = bool
    default     = true
  }

  variable "public_subnets" {
    description = "Blocos CIDR das subnets públicas"
    type        = list(string)
  }


  variable "private_subnets" {
    description = "Blocos CIDR das subnets privadas"
    type        = list(string)
  }


  variable "azs" {
    description = "Lista de zonas de disponibilidade"
    type        = list(string)
  }

  variable "nat_gateway" {
    description = "Criar NAT Gateway para subnets privadas"
    type        = bool
    default     = true
  }

