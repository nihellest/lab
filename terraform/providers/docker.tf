provider "docker" {
  host = format("ssh://%s@%s:22", var.ssh_config.user, var.ssh_config.host)
}

variable "ssh_config" {
  type = object({
    host = string
    user = string
    key  = string
  })
}

variable "default_network" {
  type = string
}

variable "default_user" {
  type = string
}

variable "host_dir" {
  type = string
}

variable "images" {
  type = map(string)
}

variable "logs" {
  type = object({
    driver = string
    opts   = map(string)
  })
}
