variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "password" {}
variable "username" {}
variable "DB_name" {}

variable "AWS_REGION" {
    default = "us-east-1"
}

variable "AWS_AMIS" {
    type = map(string)
    default = {
        "us-east-1" = "ami-0557a15b87f6559cf"
        "us-east-2" = "ami-00eeedc4036573771"
    }
}