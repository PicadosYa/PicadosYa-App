# Regla para iniciar instancias
resource "aws_cloudwatch_event_rule" "start_rule" {
  name                = "start-ec2-instances"
  schedule_expression = var.start_cron_expression
}

# Regla para detener instancias
resource "aws_cloudwatch_event_rule" "stop_rule" {
  name                = "stop-ec2-instances"
  schedule_expression = var.stop_cron_expression
}

# Permitir que CloudWatch invoque la Lambda
resource "aws_lambda_permission" "allow_start_rule" {
  statement_id  = "AllowStartExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_scheduler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_rule.arn
}

resource "aws_lambda_permission" "allow_stop_rule" {
  statement_id  = "AllowStopExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_scheduler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_rule.arn
}

# Target para la regla de inicio
resource "aws_cloudwatch_event_target" "start_target" {
  rule      = aws_cloudwatch_event_rule.start_rule.name
  target_id = "start_ec2_instances"
  arn       = aws_lambda_function.ec2_scheduler.arn

  input = jsonencode({
    action = "start"
  })
}

# Target para la regla de parada
resource "aws_cloudwatch_event_target" "stop_target" {
  rule      = aws_cloudwatch_event_rule.stop_rule.name
  target_id = "stop_ec2_instances"
  arn       = aws_lambda_function.ec2_scheduler.arn

  input = jsonencode({
    action = "stop"
  })
}
