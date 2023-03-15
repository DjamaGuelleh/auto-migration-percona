provider "aws" {
    region = var.AWS_REGION
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY
}


resource "aws_security_group" "instance_sg" {
    name = "terraform-s3-rds"

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_s3_bucket" "s3" {
  bucket = "s3-bucket-djama"
  acl    = "private"

  tags = {
    Name        = "bucket for backup file "
    Environment = terraform.workspace
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.s3.id
  key    = "backup_key"
  source = "${path.module}/backup.sql.tar.gz"

  etag = filemd5("${path.module}/backup.sql.tar.gz")
}

  


resource "aws_db_instance" "rds_instance" {
    vpc_security_group_ids = [aws_security_group.instance_sg.id]
    allocated_storage = 20
    identifier = "rds-terraform"
    storage_type = "gp2"
    engine = "mysql"
    engine_version = "8.0.32"
    instance_class = "db.t3.micro"
    allow_major_version_upgrade = false
    auto_minor_version_upgrade = false
    multi_az                   = false
    name = var.DB_name
    username = var.username
    password = var.password
    publicly_accessible    = true
    skip_final_snapshot    = true


  tags = {
    Name = "RDS-instance-S3"
  }

lifecycle {
    ignore_changes = [engine_version]
  }

  s3_import {
    source_engine         = "mysql"
    source_engine_version = "8.0.32"
    bucket_name           = aws_s3_bucket.s3.id
    ingestion_role        = aws_iam_role.s3_rds.arn
    
  }
}


output "public_ip" {
    value = aws_db_instance.rds_instance.endpoint
}