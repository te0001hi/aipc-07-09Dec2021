data digitalocean_ssh_key mykey {
    name = "mykeyy"
}

//Server - Nginx
resource digitalocean_droplet setup-droplet {
    name = "setup-droplet"
    image = var.DO_image
    size = var.DO_size
    region = var.DO_region
    ssh_keys = [ data.digitalocean_ssh_key.mykey.fingerprint ]
}

resource local_file inventory {
    filename = "../inventory.yaml"
    file_permission = 0644
    content = templatefile("inventory.yaml.tpl", {
        host_name = digitalocean_droplet.setup-droplet.name
        host_ip = digitalocean_droplet.setup-droplet.ipv4_address
        private_key = var.private_key
        public_key = var.public_key
    })
}

output ip_addr {
    value = digitalocean_droplet.setup-droplet.ipv4_address
}