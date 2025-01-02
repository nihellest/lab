ui            = true
cluster_addr  = "https://127.0.0.1:8201"
api_addr      = "https://0.0.0.0:8200"
disable_mlock = true

storage "consul" {
  address = "consul:8500"
  path    = "vault/"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = true
  # tls_cert_file = "/tls/cert.pem"
  # tls_key_file  = "/tls/private-key.pem"
}