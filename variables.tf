variable "vpc_id" {
  type        = string
  description = "You'll need to have a VPC ready to go. Provide the VPC ID here"
}

variable "my_ip" {
  type        = string
  description = "Provide your IPv4 address here. This is the intended format,<Your OWN IP>/32"
}

variable "public_key" {
  type        = string
  description = "Create a SSH Keypair and the paste in the public key here"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "Enter your EC2 Instance Type. It defaults to t3.micro"
}

variable "server_name" {
  type        = string
  default     = "Apache Example Server"
  description = "Provide a server name. It defaults to Apache Example Server."
}

# Input Variables

