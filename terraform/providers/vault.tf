provider "vault" {
  address         = var.vault_address
  token           = var.vault_root_token
  skip_tls_verify = true
}

variable "vault_address" {
  type = string
}

variable "vault_root_token" {
  type      = string
  sensitive = true
}
