resource "vault_pki_secret_backend_cert" "certs" {
  for_each    = var.web_services
  issuer_ref  = var.cert_params.issuer_ref
  backend     = var.cert_params.backend
  name        = var.cert_params.name
  common_name = "${each.key}.${var.ssh_config.host}"
  ttl         = var.cert_ttl
  revoke      = true
}

module "nginx" {
  source     = "../modules/container"
  name       = "nginx"
  image      = var.images.nginx
  networks   = [var.default_network]
  ssh_config = var.ssh_config
  host_dir   = var.host_dir
  logs       = var.logs
  command    = ["nginx", "-g", "daemon off;"]
  ports      = ["80","443"]

  configs = merge(
    # Конфиги nginx
    {
      for k,v in var.web_services:
      "${k}.conf" => {
        content = templatefile("../configs/nginx.tftpl", merge(v,{ svc = k, domain = var.ssh_config.host }))
        path    = "/etc/nginx/conf.d/${k}.conf"
      }
    },
    # Сертификаты (для работы SSL)
    {
      for cert in vault_pki_secret_backend_cert.certs:
      "${cert.common_name}.pem" => {
        content = "${cert.certificate}\n${cert.ca_chain}"
        path    = "/ssl/${cert.common_name}.pem"
      }
    },
    # Приватные ключи сертификатов
    {
      for cert in vault_pki_secret_backend_cert.certs:
      "${cert.common_name}.key" => {
        content = "${cert.private_key}"
        path    = "/ssl/${cert.common_name}.key"
      }
    }
  )

  depends_on = [
    vault_pki_secret_backend_cert.certs,
    module.grafana,
  ]
}
