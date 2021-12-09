variable DO_region {
    type = string
    default = "sgp1"
}

variable DO_image {
    type = string
    default = "ubuntu-20-04-x64"
}

variable DO_size {
    type = string
    default = "s-1vcpu-1gb"
}

//builders
source digitalocean aipc-server {
    api_token = var.DO_token
    image = var.DO_image
    size = var.DO_size
    region = var.DO_region
    ssh_username = "root"
    snapshot_name = "aipc-server"
}

build {
    sources = [
        "source.digitalocean.aipc-server"
    ]
}