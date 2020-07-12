
resource "aws_sqs_queue" "queue" {
  name = "${var.name}-${var.env}"
}
