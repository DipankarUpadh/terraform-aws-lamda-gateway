# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "ap-south-1"
}

variable "bucket_name"{
	type = string
	default = "t-poc-bucket"
}

variable "aws_access_key" {
  # set aws access key
  default = ""
}

variable "aws_secret_key" {
  # set aws secret key
  default = ""
}