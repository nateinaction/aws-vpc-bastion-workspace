// Policies
resource "aws_iam_policy" "bastion_read_users_bucket" {
  name        = "bastion_read_users_bucket"
  path        = "/"
  description = "The ability to read user public ssh keys from S3"

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
        "${data.aws_s3_bucket.bastion_users_bucket.arn}/*",
        "${data.aws_s3_bucket.bastion_scripts_bucket.arn}",
        "${data.aws_s3_bucket.bastion_scripts_bucket.arn}/*"
      ]
    }
  ]
}
POLICY
}

// Roles
resource "aws_iam_role" "bastion" {
  name = "bastion"

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

resource "aws_iam_role_policy_attachment" "bastion_read_users_bucket" {
  role       = aws_iam_role.bastion.name
  policy_arn = aws_iam_policy.bastion_read_users_bucket.arn
}

resource "aws_iam_instance_profile" "bastion" {
  name = "bastion"
  role = aws_iam_role.bastion.name
}
