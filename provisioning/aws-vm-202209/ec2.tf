resource "aws_eip" "vm-1" {
  tags = {
    Name = "vm-1"
  }
}

# You can list Ubuntu images by the following command.
# aws ec2 describe-images\
#  --filters='Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*'\
#  --owner=099720109477\
#  --query='sort_by(Images, &CreationDate)[-1].{Name: Name, ImageId: ImageId, CreationDate: CreationDate, Owner:OwnerId}'
# See also:
#   - https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-images.html
#   - https://ubuntu.com/server/docs/cloud-images/amazon-ec2
#   - https://ubuntu.com/tutorials/search-and-launch-ubuntu-22-04-in-aws-using-cli#2-search-for-the-right-ami
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"
    ]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = [
    "099720109477" # Canonical
  ]
}

resource "aws_key_pair" "from-local" {
  key_name   = "${var.project_unique_id}-from-local"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "vm-1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.nano"
  key_name      = aws_key_pair.from-local.id
  subnet_id     = aws_subnet.vms.id
  vpc_security_group_ids = [
    aws_security_group.allow-from-allowed-list.id
  ]
  depends_on = [
    aws_internet_gateway.main
  ]
  tags = {
    Name = "vm-1"
  }
}

resource "aws_eip_association" "vm-1-eip" {
  allocation_id = aws_eip.vm-1.id
  instance_id   = aws_instance.vm-1.id
}
