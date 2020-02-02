
resource "aws_lambda_function" "example" {
  function_name = "HelloWorldFunction"

  # Python app
  handler          = "app.lambda_handler"
  runtime          = "python3.8"
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  # Java app
  # handler  = "my.service.StreamLambdaHandler::handleRequest"
  # runtime  = "java8"
  # filename = "../my-service/target/my-service-1.0-SNAPSHOT-lambda-package.zip"

  # increase for Java
  timeout     = 30  # default 3 sec
  memory_size = 512 # default 128 MB

  role = aws_iam_role.lambda_exec.arn
}

data "archive_file" "zip" {
  type       = "zip"
  source_dir = "../lambda/src/" # simple app
  # source_dir  = "../sam-app/.aws-sam/build/HelloWorldFunction/" # SAM app
  output_path = "${var.name}.zip"
}

resource "aws_cloudwatch_log_group" "lambda_log" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = 7
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}
