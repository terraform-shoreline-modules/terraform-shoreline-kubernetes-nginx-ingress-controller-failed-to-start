terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "failure_to_start_nginx_ingress_controller_on_kubernetes" {
  source    = "./modules/failure_to_start_nginx_ingress_controller_on_kubernetes"

  providers = {
    shoreline = shoreline
  }
}