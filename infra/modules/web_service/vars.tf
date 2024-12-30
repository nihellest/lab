# General

variable "domain" {
  type    = string
  default = "lab.local"
}

variable "ssh_config" {
  type = object({
    remote_host     = string
    remote_user     = string
    remote_data_dir = string
    ssh_private_key = string
  })
}

# Service

variable "service_name" {
  type = string
}

variable "service_proto" {
  type = string
}

variable "service_port" {
  type = number
}

variable "nginx_template" {
  type = string
}

# Certificate

variable "cert_params" {
  type = object({
    issuer_ref  = string
    backend     = string
    name        = string
  })
}

variable "cert_ttl" {
  type    = number
  default = 157680000
}

