variable "vpc_id" {
  type = string
}

variable "my_ip" {
  type        = string
  description = "Provide your IP eg <Your own IP>/32"
}

variable "public_key" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "server_name" {
  type    = string
  default = "Apache Example Server"
}


# Input Variables

