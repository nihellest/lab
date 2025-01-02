# Пример вызова модуля контейнера
#
# module "<sample>" {
#   source     = "../modules/container"
#   name       = "<sample>"
#   image      = var.images.<sample>
#   user       = var.default_user
#   networks   = [var.default_network]
#   ssh_config = var.ssh_config
#   host_dir   = var.host_dir
#   logs       = var.logs
#  
#   command = []
#
#   ports = ["23456:12345/udp"]
#
#   configs = {
#     "config.yaml" = {
#       content = templatefile("../configs/config.yaml", {foo = "foo", bar = "bar"})
#       path    = "/etc/sample/config.yaml"
#     }
#   }
#
#   dirs = { data = "/opt/data" }
#
#   depends_on = [
#     postgresql_database.db,
#   ]
# }

module "grafana" {
  source     = "../modules/container"
  name       = "grafana"
  image      = var.images.grafana
  user       = var.default_user
  networks   = [var.default_network]
  ssh_config = var.ssh_config
  host_dir   = var.host_dir
  logs       = var.logs

  configs = {
    "grafana.ini" = {
      content = templatefile("../configs/grafana.ini.tftpl", { pg_pass = var.db_passwords["grafana"] })
      path    = "/etc/grafana/grafana.ini"
    }
    "ds.yaml" = {
      content = file("../configs/grafana-loki-datasource.yaml")
      path    = "/etc/grafana/provisioning/datasources/ds.yaml"
    }
  }

  depends_on = [
    postgresql_database.db
  ]
}
