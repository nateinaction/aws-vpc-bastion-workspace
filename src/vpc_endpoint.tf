resource "aws_vpc_endpoint" "bastion_s3" {
  vpc_id            = aws_vpc.network.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.network.id]
  policy            = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "access-to-bastion-buckets-only",
      "Principal": "*",
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
