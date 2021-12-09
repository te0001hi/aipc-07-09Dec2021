data digitalocean_ssh_key mykey {
    name = "mykeyy"
}

data digitalocean_image code-server {
    name = "code-server"
}

// Server - Nginx
resource digitalocean_droplet setup-droplet {
    name = "code-server-droplet"
    image = data.digitalocean_image.code-server.id
    size = var.DO_size
    region = var.DO_region
    ssh_keys = [ data.digitalocean_ssh_key.mykey.fingerprint ]
}

resource local_file inventory {
    filename = "inventory.yaml"
    file_permission = 0644
    content = templatefile("inventory.yaml.tpl", {
        host_name = digitalocean_droplet.setup-droplet.name
        host_ip = digitalocean_droplet.setup-droplet.ipv4_address
        private_key = var.private_key
        public_key = var.public_key
        cs_password = var.cs_password
    })
}

output ip_addr {
    value = digitalocean_droplet.setup-droplet.ipv4_address
}