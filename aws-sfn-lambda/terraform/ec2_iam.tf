
# https://aws.amazon.com/blogs/aws/new-port-forwarding-using-aws-system-manager-sessions-manager/
# https://toolr.io/2019/08/20/stop-exposing-port-22-to-the-world-its-time-to-rework-your-remote-access-methods/

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.name}-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.name}-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_policy_doc.json
}

data "aws_iam_policy_document" "ec2_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_role_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
