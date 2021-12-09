variable DO_token {
    type = string
    sensitive = true
}
variable doImage {
    type = string
    default = "ubuntu-20-04-x64"
}

variable doSize{
    type = string
    default = "s-1vcpu-1gb"
}

variable doRegion {
    type = string
    default = "sgp1"
}

variable app_count {
    type = number
    default = 1
}

variable private_key {
    type = string
}

variable app_image {
    type = string
    default = "stackupiss/dov-bear:v2"
}

variable docker_host {
    type = string
}
    