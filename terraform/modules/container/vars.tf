variable "name" {
  type = string
}

variable "image" {
  type = string
}

variable "command" {
  type = list(string)
  default = []
}

variable "restart" {
  type = string
  default = "always"
}

variable "network_mode" {
  type    = string
  default = "bridge"
}

variable "ports" {
  type = list(string)
  default = []
}

variable "user" {
  type = string
  default = ""
}

variable "networks" {
  type = list(string)
}

variable "configs" {
  type = map(object({
    content = string
    path    = string
  }))
  default = {}
}

variable "dirs" {
  type = map(string)
  default = {}
}

variable "logs" {
  type = object({
    driver = string
    opts   = map(string)
  })
  default = {
    driver = "local"
    opts = {}
  }
}

variable "host_dir" {
  type = string
}

variable "ssh_config" {
  type = object({
    host = string
    user = string
    key  = string
  })
}

variable "env" {
  type = list(string)
  default = []
}
