variable "containers" {
  type = list(object({
      imageName = string
      containerName = string
      containerPort = number
      externalPort = number
      envVariables = list(string)
      keepImage = bool
  }))
  
  default = [
      {
        imageName = "stackupiss/dov-bear:v2"
        containerName = "dov-bear"
        containerPort = 3000
        externalPort = 8080
        envVariables = ["INSTANCE_NAME=dov","INSTANCE_HASH=abc123"]
        keepImage = true
      },
      {
        imageName = "stackupiss/fortune:v2"
        containerName = "fortune"
        containerPort = 3000
        externalPort = 8081
        envVariables = []
        keepImage = true
      }

    ]
}