resource "aws_security_group" "allow-from-allowed-list" {
  name   = "${var.project_unique_id}-allow-from-allowed-list"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "allow-from-allowed-list-ingress" {
  security_group_id = aws_security_group.allow-from-allowed-list.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = var.allowed_ipaddr_list
}
