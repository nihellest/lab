resource "vault_pki_secret_backend_cert" "certs" {
  issuer_ref  = var.cert_params.issuer_ref
  backend     = var.cert_params.backend
  name        = var.cert_params.name
  common_name = "${var.service_name}.${var.domain}"
  ttl         = var.cert_ttl
  revoke      = true
}

resource "ssh_resource" "ssl" {
  host        = var.ssh_config.remote_host
  user        = var.ssh_config.remote_user
  private_key = var.ssh_config.ssh_private_key

  file {
    content     = vault_pki_secret_backend_cert.certs.private_key
    destination = "${var.ssh_config.remote_data_dir}/ssl/${var.service_name}.key"
    permissions = "0700"
  }
  file {
    content = format(
      "%s\n%s", 
      vault_pki_secret_backend_cert.certs.certificate,
      vault_pki_secret_backend_cert.certs.ca_chain
    )
    destination = "${var.ssh_config.remote_data_dir}/ssl/${var.service_name}.pem"
    permissions = "0770"
  }
}

resource "ssh_resource" "conf" {
  host        = var.ssh_config.remote_host
  user        = var.ssh_config.remote_user
  private_key = var.ssh_config.ssh_private_key

  file {
    content     = templatefile(
      "./templates/nginx.tftpl",
      { 
        domain = var.domain
        svc    = var.service_name
        proto  = var.service_proto
        port   = var.service_port
      }
    )
    destination = "${var.ssh_config.remote_data_dir}/web/${var.service_name}.conf"
    permissions = "0700"
  }
}