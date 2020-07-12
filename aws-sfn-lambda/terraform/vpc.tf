
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}


##### public subnet

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_public_a
  availability_zone = var.zone["a"]

  tags = {
    Name = "${var.name}-public-a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_public_a
  availability_zone = var.zone["c"]

  tags = {
    Name = "${var.name}-public-c"
  }
}


##### private subnet

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_private_a
  availability_zone = var.zone["a"]

  tags = {
    Name = "${var.name}-private-a"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_private_c
  availability_zone = var.zone["c"]

  tags = {
    Name = "${var.name}-private-c"
  }
}


##### protected subnet

resource "aws_subnet" "protected_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_protected_a
  availability_zone = var.zone["a"]

  tags = {
    Name = "${var.name}-protected-a"
  }
}

resource "aws_subnet" "protected_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_protected_c
  availability_zone = var.zone["c"]

  tags = {
    Name = "${var.name}-protected-c"
  }
}


##### internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.name
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public_rtb.id
}


##### nat gateway

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id
  depends_on    = [aws_internet_gateway.gw]
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-private"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_rtb.id
}
