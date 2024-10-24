variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ec2_ami_linux" {
  type    = string
  default = "ami-0e86e20dae9224db8"
}

variable "ec2_keyname" {
  type    = string
  default = "keypair"
}

variable "ec2_tag_name" {
  type = string
}

variable "ec2_tag_ambiente" {
  type    = string
  default = "Produccion"
}

variable "security_group_name" {
  type    = string
  default = "sec-group-picadosya"
}

# Esto es UTC, nosotros somo UTC -3
variable "start_cron_expression" {
  type    = string
  default = "cron(0 11 ? * 3,5 *)" #"cron(0 12 * * ? 1-5)" 
}

variable "stop_cron_expression" {
  type    = string
  default = "cron(30 2 ? * 4,6 *)" #"cron(0 20 * * ? 1-5)" 
}