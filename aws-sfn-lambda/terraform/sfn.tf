
# Step Functions Callback
# https://docs.aws.amazon.com/ja_jp/step-functions/latest/dg/connect-to-resource.html

resource "aws_sfn_state_machine" "state_machine" {
  name       = var.name
  role_arn   = aws_iam_role.sfn.arn
  definition = templatefile("${path.module}/sfn_definition.json", {
    lambda_arn = aws_lambda_function.lambda.arn,
    sqs_url = aws_sqs_queue.queue.id
  })
}
