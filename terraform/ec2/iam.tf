# Crear rol IAM para Lambda
resource "aws_iam_role" "lambda_role" {
  name = "ec2-scheduler-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Adjuntar política al rol para EC2 y logs
resource "aws_iam_role_policy_attachment" "lambda_ec2_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_ec2_policy_custom" {
  name = "ec2-scheduler-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:DescribeInstances",
          "sns:Publish",
        ]
        Effect   = "Allow"
        Resource = "*" #aws_instance.instance_linux.arn
      }
    ]
  })
}