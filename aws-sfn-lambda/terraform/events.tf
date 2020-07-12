# Sfn -> CloudWatch Event -> SNS
# https://dev.classmethod.jp/cloud/aws/step-functions-cloudwatch-event/

# Sfn -> CloudWatch Event
resource "aws_cloudwatch_event_rule" "event_rule" {
  name          = "${var.name}-notification"
  event_pattern = templatefile("${path.module}/event_pattern.json", { sfn_arn = aws_sfn_state_machine.state_machine.id })
}

# CloudWatch Event -> SNS
resource "aws_cloudwatch_event_target" "event_target" {
  rule = aws_cloudwatch_event_rule.event_rule.name
  arn  = aws_sns_topic.topic.arn
}
