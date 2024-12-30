data "terraform_remote_state" "meta" {
  backend = "local"

  config = {
    path = "../meta/terraform.tfstate"
  }
}