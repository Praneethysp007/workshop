
resource "aws_security_group" "db" {
  name        = var.aws_dbsg_configure.name
  description = var.aws_dbsg_configure.description
  vpc_id      = aws_vpc.vpc1.id

}
resource "aws_security_group_rule" "dbsgrules" {
  count             = length(var.aws_dbsg_configure.rules)
  type              = var.aws_dbsg_configure.rules[count.index].type
  from_port         = var.aws_dbsg_configure.rules[count.index].from_port
  to_port           = var.aws_dbsg_configure.rules[count.index].to_port
  protocol          = var.aws_dbsg_configure.rules[count.index].protocol
  cidr_blocks       = [var.aws_dbsg_configure.rules[count.index].cidr_blocks]
  security_group_id = aws_security_group.db.id

}
resource "aws_security_group" "app" {
  name        = var.aws_appsg_configure.name
  description = var.aws_appsg_configure.description
  vpc_id      = aws_vpc.vpc1.id

}
resource "aws_security_group_rule" "appsgrules" {
  count             = length(var.aws_appsg_configure.rules)
  type              = var.aws_appsg_configure.rules[count.index].type
  from_port         = var.aws_appsg_configure.rules[count.index].from_port
  to_port           = var.aws_appsg_configure.rules[count.index].to_port
  protocol          = var.aws_appsg_configure.rules[count.index].protocol
  cidr_blocks       = [var.aws_appsg_configure.rules[count.index].cidr_blocks]
  security_group_id = aws_security_group.app.id

}