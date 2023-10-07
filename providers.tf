terraform {
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "GalacticEmpireNT"

  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}
  #cloud {
  #  organization = "GalacticEmpireNT"
  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

provider "aws" {
}
provider "random" {
  # Configuration options
}