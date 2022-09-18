resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_unique_id}-main"
  }
}

resource "aws_subnet" "vms" {
  # Error: creating EC2 Instance: Unsupported: Your requested instance type (t3.nano) is not supported in your requested Availability Zone (us-east-1e).
  availability_zone = "${var.aws_default_region}a"
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = "${var.project_unique_id}-vms"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "main" {
  route_table_id         = aws_route_table.main.id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.vms.id
  route_table_id = aws_route_table.main.id
}
