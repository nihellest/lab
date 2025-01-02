variable "cert_config" {
  type = object({
    ca_name = string
    ca_issuer_name  = string
    int_name = string
    int_issuer_name = string
    allowed_domains = list(string)
  })
}