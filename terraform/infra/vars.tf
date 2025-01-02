variable "web_services" {
  type = map(object({
    port  = number
    proto = string
  }))
}

variable "cert_ttl" {
  type = number
}

variable "cert_params" {
  type = object({
    issuer_ref  = string
    backend     = string
    name        = string
  })
}

variable "databases" {
  type = set(string)
}

variable "db_passwords" {
  type      = map(string)
  sensitive = true
}