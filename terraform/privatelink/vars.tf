variable "aws_vpc_id" {}

variable "aws_subnet_ids" {}

variable "service_listener_config" {

  type = list(object({
    service_port   = number
    protocol       = string
    destination_ip = string
  }))

}
