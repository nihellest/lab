data "terraform_remote_state" "pki" {
  backend = "local"

  config = {
    path = "../pki/terraform.tfstate"
  }
}

data "terraform_remote_state" "meta" {
  backend = "local"

  config = {
    path = "../meta/terraform.tfstate"
  }
}