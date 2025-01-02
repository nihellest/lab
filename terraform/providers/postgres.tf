provider "postgresql" {
  host            = var.postgres_host
  port            = 5432
  username        = "postgres"
  password        = var.postgres_password
  sslmode         = "disable"
  connect_timeout = 15
}

variable "postgres_host" {
  type = string
}

variable "postgres_password" {
  type      = string
  sensitive = true
}
