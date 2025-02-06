variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-085ad6ae776d8f09c" # Amazon Linux 2 AMI (us-east-1)
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}