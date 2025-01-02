datacenter       = "lab-consul"
data_dir         = "/consul/data"
log_level        = "INFO"
node_name        = "lab-consul-1"
server           = true
domain           = "local."
client_addr      = "0.0.0.0"
advertise_addr   = "192.168.31.12"
bootstrap_expect = 1

ui_config {
  enabled = true
}