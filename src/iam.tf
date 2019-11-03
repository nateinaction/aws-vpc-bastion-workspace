data "aws_s3_bucket" "bastion_users_bucket" {
  bucket = var.bastion_users_bucket
}

// Policies
resource "aws_iam_policy" "read_bastion_buckets" {
  name        = "read_bastion_buckets"
  path        = "/"
  description = "The ability to read user public ssh keys and scripts from S3"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${data.aws_s3_bucket.bastion_users_bucket.arn}",
        "${data.aws_s3_bucket.bastion_users_bucket.arn}/*"
      ]
    }
  ]
}
POLICY
}

// Roles
resource "aws_iam_role" "read_bastion_buckets" {
  name = "read_bastion_buckets"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY

  tags = {
    Name = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "read_bastion_buckets" {
  role       = aws_iam_role.read_bastion_buckets.name
  policy_arn = aws_iam_policy.read_bastion_buckets.arn
}

resource "aws_iam_instance_profile" "read_bastion_buckets" {
  name = "read_bastion_buckets"
  role = aws_iam_role.read_bastion_buckets.name
}
