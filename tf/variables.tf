variable "env" {
   description = "Deployment environment"
   type        = string
}

variable "region" {
   description = "AWS region"
   type        = string
}

variable "ami_id" {
   description = "EC2 Ubuntu AMI"
   type        = string
}

variable "type" {
   description = "Type of instance"
   type        = string
}

variable "name_bucket" {
   description = "Name bucket"
   type        = string
}

variable "key_pair" {
   description = "Key pair to connect EC2"
   type        = string
}