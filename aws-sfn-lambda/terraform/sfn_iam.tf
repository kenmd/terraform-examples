
resource "aws_iam_role" "sfn" {
  name               = "${var.name}-sfn-role"
  assume_role_policy = data.aws_iam_policy_document.sfn.json
  path               = "/service-role/"
}

data "aws_iam_policy_document" "sfn" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

# (Note) in console, wizard wil create policy for one Lambda arn only
resource "aws_iam_role_policy_attachment" "sfn" {
  role       = aws_iam_role.sfn.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

resource "aws_iam_role_policy_attachment" "sfn_sqs" {
  role       = aws_iam_role.sfn.name
  policy_arn = aws_iam_policy.sqs.arn
}

resource "aws_iam_policy" "sqs" {
  name        = "${var.name}-sfn-sqs-policy"
  description = "Sfn SQS integration policy"
  policy      = data.aws_iam_policy_document.sqs.json
}

// https://docs.aws.amazon.com/ja_jp/step-functions/latest/dg/sqs-iam.html
data "aws_iam_policy_document" "sqs" {
  statement {
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.queue.arn]
  }
}
