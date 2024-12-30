
locals {
  web_services = {
    consul = {
      proto = "http"
      port  = 8500
    }
    vault = {
      proto = "https"
      port  = 8200
    }
  }
}

module "service" {
  for_each = local.web_services
  source   = "./modules/web_service"

  service_name   = each.key
  service_proto  = each.value.proto
  service_port   = each.value.port
  nginx_template = file("./templates/nginx.tftpl")

  cert_params = data.terraform_remote_state.pki.outputs.params
  ssh_config  = data.terraform_remote_state.meta.outputs.ssh_config
}