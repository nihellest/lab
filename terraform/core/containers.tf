resource "docker_network" "core" {
  name = var.default_network
}

module "loki" {
  source     = "../modules/container"
  name       = "loki"
  image      = var.images.loki
  user       = var.default_user
  networks   = [var.default_network]
  ssh_config = var.ssh_config
  host_dir   = var.host_dir
  
  command = ["-config.file=/etc/loki/loki.yaml"]

  ports = ["3100"]

  configs = {
    "loki.yaml" = {
      content = file("../configs/loki.yaml")
      path    = "/etc/loki/loki.yaml"
    }
  }

  dirs = { loki_data = "/loki" }

  depends_on = [
    docker_network.core,
  ]
}

module "consul" {
  source     = "../modules/container"
  name       = "consul"
  image      = var.images.consul
  networks   = [var.default_network]
  ssh_config = var.ssh_config
  host_dir   = var.host_dir
  logs       = var.logs
  
  command = ["consul","agent","-config-file=/etc/consul/consul.hcl"]

  ports = ["8300"]

  configs = {
    "consul.hcl" = {
      content = file("../configs/consul.hcl")
      path = "/etc/consul/consul.hcl"
    }
  }

  dirs = { consul_data = "/consul/data" }

  depends_on = [
    docker_network.core,
    module.loki
  ]
}

module "vault" {
  source     = "../modules/container"
  name       = "vault"
  image      = var.images.vault
  networks   = [var.default_network]
  ssh_config = var.ssh_config
  host_dir   = var.host_dir
  logs       = var.logs

  command = ["vault","server","-config=/etc/vault/vault.hcl"]
  
  ports = ["8200"]
  
  configs = {
    "vault.hcl" = {
      content = file("../configs/vault.hcl")
      path = "/etc/vault/vault.hcl"
    }
  }

  depends_on = [
    docker_network.core,
    module.loki,
    module.consul,
  ]
}

module "postgres" {
  source     = "../modules/container"
  name       = "postgres"
  image      = var.images.postgres
  user       = var.default_user
  networks   = [var.default_network]
  ssh_config = var.ssh_config
  host_dir   = var.host_dir
  logs       = var.logs
  command    = ["postgres"]
  
  env = [
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "PGDATA=/var/lib/postgresql/data/pgdata",
  ]

  ports = ["5432"]

  dirs = { pg_data = "/var/lib/postgresql/data" }

  depends_on = [
    docker_network.core,
    module.loki,
  ]
}
