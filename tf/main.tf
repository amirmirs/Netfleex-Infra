terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.55"
    }
  }

  required_version = ">= 1.7.0"

  backend "s3" {
    bucket = "amir-tf-bucket"
    key    = "tfstate.json"
    region = "eu-north-1"
  }
}

provider "aws" {
  region = var.region
}

resource "aws_security_group" "netflix_app_sg" {
  name        = "netflix-app-sg"  
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 8080  
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000  
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ebs_volume" "frontend_volume" {
  availability_zone = "${var.region}${var.az}"    
  size              = 5  

  tags = {
    Name = "frontend-volume"
  }
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/sdh"  
  volume_id   = aws_ebs_volume.frontend_volume.id
  instance_id = aws_instance.netflix_app.id  
}

# S3 Bucket for Frontend Assets
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = var.bucket_name 

  tags = {
    Name        = "frontend-bucket-netflix-infra-aa"
    Environment = var.env
  }
}