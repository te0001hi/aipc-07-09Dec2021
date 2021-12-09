resource "docker_image" "container-image" {
    /*name = "stackupiss/dov-bear:v2:${var.tag_version}"
	keep_locally = var.keep_image*/
	count = length(var.containers)
	name = var.containers[count.index].imageName
	keep_locally = var.containers[count.index].keepImage
}

resource "docker_container" "container-app" {
	count = length(var.containers)
	name = var.containers[count.index].containerName
	image = docker_image.container-image[count.index].latest
	ports {
		internal = var.containers[count.index].containerPort
		external = var.containers[count.index].externalPort
	}
	env = var.containers[count.index].envVariables
}

output ports {
	value = docker_container.container-app[1].ports
}

/*resource "docker_container" "dov-app" {
	//resource docker_container dov-app{
	name = var.name

	//docker run -d -p
	image = docker_image.dov-bear.latest
	ports {
		internal = 3000
		external = 8080
	}
	//exclude this first
	env = ["INSTANCE_NAME=dov-app","INSTANCE_HASH=abc123"]
}*/