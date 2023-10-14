terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "GalacticEmpireNT"

  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}
  cloud {
    organization = "GalacticEmpireNT"
    workspaces {
      name = "terra-house-1"
    }
  }

}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid 
  token = var.terratowns_access_token
}

module "home_arcanum_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.arcanum.public_path
  content_version = var.arcanum.content_version  
}

resource "terratowns_home" "home" {
  name = "How to cook Lecso"
  description = <<DESCRIPTION
Lecso is a traditional Hungarian pepper stew made from fresh vegetables.
In my little Terrahome I will teach you how to make it.
I hope you will enjoy!
DESCRIPTION
  domain_name = module.home_arcanum_hosting.domain_name
  town = "cooker-cove"
  content_version = var.arcanum.content_version
}

#module "home_payday_hosting" {
#  source = "./modules/terrahome_aws"
#  user_uuid = var.teacherseat_user_uuid
#  public_path = var.payday.public_path
#  content_version = var.payday.content_version
#}
#
#resource "terratowns_home" "home_payday" {
#  name = "Making your Payday Bar"
#  description = <<DESCRIPTION
#Since I really like Payday candy bars but they cost so much to import
#into Canada, I decided I would see how I could make my own Payday bars,
#and if they are most cost effective.
#DESCRIPTION
#  domain_name = module.home_payday_hosting.domain_name
#  town = "missingo"
#  content_version = var.payday.content_version
#}