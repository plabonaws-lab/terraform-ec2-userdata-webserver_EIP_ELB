provider "aws" {
  access_key = var.accesskey
  secret_key = var.secretkey
  region     = var.region
}

#Creating aws ec2 instance

resource "aws_instance" "Terra_EC2_Instance" {
  ami                    = var.ami
  instance_type          = var.instancetype
  availability_zone      = "ap-southeast-1a"
  vpc_security_group_ids = ["${aws_security_group.hello-terra-ssh-http.id}"]
  key_name               = "terraformsecond"
  user_data              = <<-EOF
			#! /bin/bash
			sudo yum install httpd -y
			sudo systemctl start httpd
			sudo systemctl enable httpd
			echo "<h1>Sample Webserver Creating Using Terraform<br> Plabon Mazumder</h1>" >> /var/www/html/index.html
	EOF		
  tags = {
    Name = "Web-Server"
  }
}


#Creating Security Group, allow ssh and http

resource "aws_security_group" "hello-terra-ssh-http" {
  name = "hello-terra-ssh-http"

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
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#security group ends here


#Assign EIP to our Instance

resource "aws_eip" "Terra_EC2_Instance_EIP" {
  instance = aws_instance.Terra_EC2_Instance.id
  tags = {
    Name = "Terra_EC2_Instance_EIP"
  }
}

#EIP Code Ends Here

#Create EBS volume and attach with our instance

#Volume Creation Stage 

resource "aws_ebs_volume" "data-vol" {
  availability_zone = "ap-southeast-1a"
  size              = 1
  tags = {
    Name = "data-volume"
  }

}

#Volume Attachment with Instance Stage

resource "aws_volume_attachment" "my_ebs_vol" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.data-vol.id
  instance_id = aws_instance.Terra_EC2_Instance.id
}

#EBS Code Ends Here