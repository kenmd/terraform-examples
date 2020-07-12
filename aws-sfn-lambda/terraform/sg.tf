
resource "aws_security_group" "jump" {
  name   = "${var.name}-jump-sg"
  vpc_id = aws_vpc.main.id
}

# resource "aws_security_group_rule" "jump_in" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.jump.id
# }

resource "aws_security_group_rule" "jump_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jump.id
}


resource "aws_security_group" "mysql" {
  name   = "${var.name}-mysql-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "mysql_in_jump" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.jump.id
  security_group_id        = aws_security_group.mysql.id
}

resource "aws_security_group_rule" "mysql_in_lambda" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lambda.id
  security_group_id        = aws_security_group.mysql.id
}

resource "aws_security_group_rule" "mysql_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mysql.id
}


resource "aws_security_group" "lambda" {
  name   = "${var.name}-lambda-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.name
  }
}

resource "aws_security_group_rule" "lambda_in" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.lambda.id # as per default sg
  security_group_id        = aws_security_group.lambda.id
}

resource "aws_security_group_rule" "lambda_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lambda.id
}
