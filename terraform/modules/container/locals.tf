locals {
  ports = { for port in var.ports :
    port => {
      internal = try(regexall("[0-9]+", port)[1],regexall("[0-9]+", port)[0])
      external = regex("[0-9]*", port)
      protocol = try(regex("(tcp|udp)", port)[0], "tcp")
    }
  }
}
