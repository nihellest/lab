locals {
  # Configs
  config_dir = "./config"
  configs    = fileset(local.config_dir, "*.*")

  # Versions
  nginx_version = "1.27.3"
}