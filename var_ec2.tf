variable "accesskey" {
  type    = string
  default = ""
}

variable "secretkey" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "ami" {
  type    = string
  default = "ami-082105f875acab993"
}

variable "instancetype" {
  type    = string
  default = "t2.micro"
}
