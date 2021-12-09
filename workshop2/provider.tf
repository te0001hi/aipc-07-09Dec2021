terraform {
    required_version = ">1.0.0"
    
    required_providers {
        digitalocean = {
          source = "digitalocean/digitalocean"
          version = "2.16.0"
        }
        docker = {
            source  = "kreuzwerker/docker"
            version = "2.15.0"
        }

        local = {
            source = "hashicorp/local"
            version = "2.1.0"
        }
  }
}

provider "digitalocean" {
    token = var.DO_token
}

provider "docker" {
    host = "unix:///var/run/docker.sock"
}