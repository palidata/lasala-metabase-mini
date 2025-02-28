variable "region" {
  description = "Região AWS para deploy"
  type        = string
  default     = "sa-east-1"
}

variable "vpc_cidr" {
  description = "CIDR para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Zonas de disponibilidade para a VPC"
  type        = list(string)
  default     = ["sa-east-1a", "sa-east-1b"]
}

variable "public_subnets" {
  description = "Lista de CIDRs para as sub-redes públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Lista de CIDRs para as sub-redes privadas"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "db_username" {
  description = "Usuário para o banco de dados RDS"
  type        = string
  default     = "metabaseadmin"
}

variable "db_password" {
  description = "Senha para o banco de dados RDS"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "metabase_db"
}

variable "db_instance_class" {
  description = "Classe da instância do RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Armazenamento alocado para o RDS (em GB)"
  type        = number
  default     = 20
}

variable "instance_type" {
  description = "Tipo de instância EC2 para rodar o Metabase"
  type        = string
  default     = "t2.small"
}
