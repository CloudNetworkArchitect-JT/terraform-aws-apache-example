Terraform Module to provision an EC2 Instance that is running Apache. Not intended for production use.

```hcl
terraform {

}

provider "aws" {
  region = "us-east-1"
}

module "apache" {
  source = ".//terraform-aws-apache-example"
  vpc_id = "vpc-000000000000000"
  my_ip = "MY_OWN_IP_ADDRESS"
  public_key = "ssh-rsa AAAAB8.."
  instance_type = "t3.micro"
  server_name = "Apache Example Server"
}

output "public_ip" {
  value = module.apache.public_ip
}
```
