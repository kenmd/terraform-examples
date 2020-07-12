
resource "aws_lambda_function" "lambda" {
  function_name    = var.function_name
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  role = aws_iam_role.lambda.arn

  handler = "app.lambda_handler"
  runtime = "python3.7"

  timeout     = 120 # default 3 sec (max 15 minutes)
  memory_size = 256 # default 128 MB (max 3008 MB)

  environment {
    variables = {
      DB_SERVER   = aws_rds_cluster.serverless_mysql.endpoint
      DB_USERNAME = var.db_username
      DB_PASSWORD = var.db_password
      DB_DATABASE = var.db_database
    }
  }

  vpc_config {
    subnet_ids = [
      aws_subnet.private_a.id,
      aws_subnet.private_c.id,
    ]
    security_group_ids = [
      aws_security_group.lambda.id
    ]
  }
}

data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "../sam-app/.aws-sam/build/HelloWorldFunction/"
  output_path = "${var.function_name}.zip"
}

resource "aws_cloudwatch_log_group" "exanple" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7
}
