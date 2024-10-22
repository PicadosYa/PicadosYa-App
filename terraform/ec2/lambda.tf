data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_function"
  output_path = "${path.module}/lambda.zip"       
}

resource "aws_lambda_function" "ec2_scheduler" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "ec2_scheduler"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"    # Actualizado para Node.js
  runtime          = "nodejs20.x"       # Cambiado a Node.js
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      INSTANCE_IDS = aws_instance.instance_linux.id
      SNS_TOPIC_ARN = aws_sns_topic.instance_ip_change.arn
    }
  }

  depends_on = [data.archive_file.lambda_zip] 
}