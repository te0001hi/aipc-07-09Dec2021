data digitalocean_ssh_key mykeyy {
	name = "mykeyy"
}

// step by step walkthrough
data "docker_image" "dov-image" {
    name = var.app_image
}

resource docker_container dov-container {
    count = var.app_count
    name = "dov-${count.index}"
    image = data.docker_image.dov-image.id
    ports {
        internal = 3000
    }
    env = ["INSTANCE_NAME=dov-${count.index}"]
}

resource local_file nginx-conf {
    filename = "nginx.conf"
    //read only
    file_permission = 0644
    content = templatefile("nginx.conf.tpl", {
        docker_host = var.docker_host
        ports = flatten(docker_container.dov-container[*].ports[*].external)
    })
}

resource "digitalocean_droplet" "myserver" {
    name   = "myserver"
    image  = var.doImage
    region = var.doRegion
    size   = var.doSize
    ssh_keys = [ data.digitalocean_ssh_key.mykeyy.fingerprint ]
    
    connection {
        type = "ssh"
        user = "root"
        private_key = file("mykeyy")
        host = self.ipv4_address
    }

    provisioner "remote-exec" {
        inline = [
            "apt update -y",
            "apt upgrade -y",
            "apt install nginx -y",
            "systemctl enable nginx",
            "systemctl start nginx"
        ]
    }

    provisioner "file" {
        source = local_file.nginx-conf.filename
        destination = "/etc/nginx/nginx.conf"
    }

    provisioner "remote-exec" {
        inline = [
            "nginx -s reload"
        ]
    }
}

resource local_file "at_ipv4" {
    filename = "@${digitalocean_droplet.myserver.ipv4_address}"
    content = "${data.digitalocean_ssh_key.mykeyy.fingerprint}\n"
    file_permission = "0644"
}

# Local file try out does not work
resource "local_file" "droplet_info" {
    filename = "info.txt"
    content = templatefile("info.txt.tpl", {
        ipv4        = digitalocean_droplet.myserver.ipv4_address
        fingerprint = data.digitalocean_ssh_key.mykeyy.fingerprint
    })

    file_permission = "0644"
}

resource local_file inventory-yaml {
    filename = "inventory.yaml"
    file_permission = 0644
    content = templatefile("inventory.yaml.tpl", {
        host_name = digitalocean_droplet.myserver.name
        host_ip = digitalocean_droplet.myserver.ipv4_address

    })
}

output "ipv4" {  
    value = digitalocean_droplet.myserver.ipv4_address  
    description = "The public IP address of your Droplet application."
}

output app-ports {
    value = flatten(docker_container.dov-container[*].ports[*].external)
}

output my-key-fingerprint{
	value = data.digitalocean_ssh_key.mykeyy.fingerprint
}