resource "aws_vpc" "vpc1" {
  cidr_block = var.cidrblock

  tags = {
    Name = "newvpc1"
  }
}
resource "aws_subnet" "subnets" {
  vpc_id            = aws_vpc.vpc1.id
  count             = length(var.tags)
  cidr_block        = cidrsubnet(var.cidrblock, 8, count.index)
  availability_zone = var.subnetaz[count.index]
  tags = {
    Name = var.tags[count.index]

  }
}
resource "aws_internet_gateway" "websg_itgw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "ntirgtw"
  }

  depends_on = [aws_vpc.vpc1]
}
data "aws_route_table" "default" {
  vpc_id = aws_vpc.vpc1.id

  depends_on = [aws_vpc.vpc1]

}
resource "aws_route" "theroute" {
  route_table_id         = data.aws_route_table.default.id
  destination_cidr_block = local.anywhere
  gateway_id             = aws_internet_gateway.websg_itgw.id

  depends_on = [aws_internet_gateway.websg_itgw, aws_vpc.vpc1]

}

