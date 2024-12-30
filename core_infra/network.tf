resource "docker_network" "core" {
  name = "core-net"
}

resource "docker_network" "proxy" {
  name = "proxy-net"
}