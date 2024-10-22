resource "aws_sns_topic" "instance_ip_change" {
  name = "instance-ip-change-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.instance_ip_change.arn
  protocol  = "email"
  endpoint  = "picadosya@gmail.com"
}

resource "aws_lambda_permission" "allow_sns_publish" {
  statement_id  = "AllowSNSPublish"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_scheduler.function_name
  principal     = "sns.amazonaws.com"
}