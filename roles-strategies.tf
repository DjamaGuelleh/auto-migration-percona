resource "aws_iam_role" "s3_rds" {
  name_prefix = "rds-s3-integration-role-"

  assume_role_policy = <<EOF
{
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Principal": {
            "Service": "rds.amazonaws.com"
          },
         "Action": "sts:AssumeRole"
       }
     ]
   }
EOF
}

resource "aws_iam_role_policy" "s3_rds" {
  name_prefix = "rds-s3-integration-policy-"
  role        = aws_iam_role.s3_rds.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}