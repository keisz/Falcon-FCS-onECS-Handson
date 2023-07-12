resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.ecsdemo-vpc.id
  tags = {
    Name = "${var.app_environment}-igw"
    env  = var.app_environment
  }
}


resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.ecsdemo-vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.app_environment}-public-subnet-${count.index + 1}"
    env  = var.app_environment
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ecsdemo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-igw.id
  }

  tags = {
    Name = "${var.app_environment}-rtb-public"
    env  = var.app_environment
  }

}


resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
