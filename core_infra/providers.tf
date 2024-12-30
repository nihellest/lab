terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    ssh = {
      source = "loafoe/ssh"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }
}

provider "docker" {
  host = "ssh://dk@lab.local:22"
}



