
resource "aws_iam_role" "lambda" {
  name               = "${var.name}-lambda-role"
  description        = "Allows Lambda functions to call AWS services on your behalf."
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.lambda.json
}

data "aws_iam_policy_document" "lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

# policy for Lambda to access RDS
# https://docs.aws.amazon.com/lambda/latest/dg/vpc-rds.html
resource "aws_iam_role_policy_attachment" "lambda_vpc_access_execution" {
  role = aws_iam_role.lambda.name
  # for a Lambda function to execute while accessing a resource within a VPC
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
