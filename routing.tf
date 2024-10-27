resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # inner rule
  route {
    cidr_block = "0.0.0.0/0" # public access
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name  = "terraform-rt-public"
  }
}

# association -> 어느 서브넷과 연결할지 지정
resource "aws_route_table_association" "route_table_association_public" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "terraform-rt-private"
  }
}
resource "aws_route_table_association" "route_table_association_private" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}

# route rule
resource "aws_route" "private_nat" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
}