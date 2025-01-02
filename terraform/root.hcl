locals {
  ssh_config = {
    host = "lab.local"
    user = "dk"
    key  = file("/home/dk/.ssh/id_rsa")
  }
  passwords = yamldecode(file("sensitive/passwords.yaml"))
}

inputs = {

  # SSH

  default_network = "core-net"
  default_user    = 1000
  ssh_config      = local.ssh_config
  host_dir        = "/mnt/storage"

  # Logs

  logs = {
    driver = "loki"
    opts = {
      loki-url        = "http://localhost:3100/loki/api/v1/push"
      loki-retries    = 5
      loki-batch-size = 100
    }
  }

  # Services

  images = {
    consul        = "hashicorp/consul:1.20.1"
    vault         = "hashicorp/vault:1.18.3"
    loki          = "grafana/loki:3.3.2-amd64"
    postgres      = "postgres:17.2-alpine"
    nginx         = "nginx:1.27.3-alpine"
    homeassistant = "ghcr.io/home-assistant/home-assistant:2024.12.5"
    grafana       = "grafana/grafana:11.4.0"
  }
  web_services = {
    consul = {
      proto = "http"
      port  = 8500
    }
    vault = {
      proto = "https"
      port  = 8200
    }
    grafana = {
      proto = "http"
      port  = 3000
    }
  }

  # Databases

  databases = [
    "grafana"
  ]

  postgres_host     = local.ssh_config.host
  postgres_password = local.passwords.postgres.super
  db_passwords      = local.passwords.postgres.db

  # PKI

  vault_address = "http://${local.ssh_config.host}:8200"

  cert_config = {
    ca_name         = "LAB CA"
    ca_issuer_name  = "LAB"
    int_name        = "LAB Int"
    int_issuer_name = "LAB"
    allowed_domains = ["lab.local"]
  }

  cert_ttl = 157680000
}