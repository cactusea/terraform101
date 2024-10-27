resource "aws_iam_user" "cactusea" {
  name = "catusea"
}

resource "aws_iam_user_policy" "super-admin-policy" {
  name = "super-admin"
  user   = aws_iam_user.cactusea.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_group" "iam-group" {
  name = "iam-group"
}

resource "aws_iam_group_membership" "iam-member" {
  name = aws_iam_group.iam-group.name
  users = var.iam_user_list
  group = aws_iam_group.iam-group.name
}

resource "aws_iam_role" "hello" {
  name = "hello-iam-role"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "hello_s3" {
  name = "hello-s3-download"
  role   = aws_iam_role.hello.id
  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "AllowAppArtifactsReadAccess",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "*"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "hello" {
  name = "hello-profile"
  role = aws_iam_role.hello.name
}
