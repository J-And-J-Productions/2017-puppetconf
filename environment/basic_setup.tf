// We'll use the AWS provider
provider "aws" {
  region = "us-east-1"
  profile = "mine"
}

// Crete a VPC to build our network
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "2017-PUPPETCONF"
  }
}

// Create a subnet to put servers into
resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags {
    Name = "2017-PUPPETCONF"
  }
}

// Create a secondary subnet just as an example for a test
resource "aws_subnet" "secondary" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1c"

  tags {
    Name = "2017-PUPPETCONF"
  }
}

// Create an internet gateway so we can send traffic out of our vpc
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "2017-PUPPETCONF"
  }
}

// Create a route table so we can route traffic out the internet gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "2017-PUPPETCONF"
  }
}

// Create a default route to send traffic out the internet gateway
// It will be set up to automatically route local traffic locally
resource "aws_route" "public_default_route" {
  route_table_id = "${aws_route_table.public_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.gw.id}"
}

// Associate our main subnet to the public route table
resource "aws_route_table_association" "main" {
  subnet_id = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

// Associate our secondary subnet to the public route table
resource "aws_route_table_association" "secondary" {
  subnet_id = "${aws_subnet.secondary.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

// Create a template to use as a user_data script on our web server
data "template_file" "bootstrap" {
  template = <<EOF
#!/bin/bash
curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
sudo dpkg -i puppetlabs-release-pc1-xenial.deb
sudo apt update
sudo apt install unzip puppet-agent --assume-yes
wget https://github.com/J-And-J-Productions/2017-puppetconf/archive/master.zip
unzip master.zip
tar czvf master.tar.gz 2017-puppetconf-master/
sudo /opt/puppetlabs/puppet/bin/puppet module install master.tar.gz
sudo /opt/puppetlabs/puppet/bin/puppet apply -v -e "include awsapache"

EOF
}

// Create an ec2 instance to be used as our web server
resource "aws_instance" "web" {
  ami                         = "ami-840910ee"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = "${aws_subnet.main.id}"
  key_name                    = "personal_aws_ssh_key"
  vpc_security_group_ids      = ["${aws_security_group.main.id}"]
  depends_on                  = ["aws_internet_gateway.gw"]
  user_data                   = "${data.template_file.bootstrap.rendered}"

tags {
    Name = "2017-PUPPETCONF"
  }
}

// Create a security group to allow incoming ssh and web traffic to our ec2 instance
// And outgoing traffic on all ports
resource "aws_security_group" "main" {
  name        = "main"
  description = "Allow stuff"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "2017-PUPPETCONF"
  }
}