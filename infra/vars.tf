variable "docker_connection_string" {
  type = string
}

variable "vault_address" {
  type = string
}

variable "vault_root_token" {
  type      = string
  sensitive = true
}