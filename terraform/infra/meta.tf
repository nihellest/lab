terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    ssh = {
      source = "loafoe/ssh"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "4.5.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.25.0"
    }
  }
}
