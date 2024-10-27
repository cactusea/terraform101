resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "terraform-subnet-public"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.10.0/24"

  tags = {
    Name = "terraform-subnet-private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terraform-igw"
  }
}

resource "aws_eip" "nat" {
  # vpc = true
  domain = "vpc"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id

  # public subnet
  subnet_id = aws_subnet.public_subnet.id

  tags = {
    Name = "terraform-NAT-GW"
  }
}