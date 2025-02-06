# Terraform-Static-Web-Deployment-on-EC2-Frontend-behind-Nginx

"Deploying a Static Web Frontend Behind Nginx"

# Technical Architecture

![image_alt](https://github.com/Tatenda-Prince/Terraform-Static-Web-Deployment-on-EC2-Frontend-behind-Nginx/blob/40d89ed56a7b577b1b495edf1a6461e871fe000e/img/Screenshot%202025-02-06%20152050.png)


## Introduction

Nginx (pronounced "Engine-X") is a popular open-source web server that also acts as a reverse proxy, load balancer, and HTTP cache. It's known for its high performance, stability, and low resource usage. Nginx is commonly used to serve static content (like HTML, images, and CSS), but it can also be configured to handle dynamic content, work as a reverse proxy for backend applications, and distribute traffic to multiple servers (load balancing).

## Prerequisites

1.AWS account and CLI configure 

2.AWS EC2

3.Web Browser( I used Microsoft Edge)

4.Install Terraform: Download and install Terraform from terraform.io.

5.Visual Code Studio 


## Use Case

Up The Chels Corp, an e-commerce company, needs to handle a surge in traffic during the holiday season. The company wants to ensure that their website remains available and responsive to customers even during high traffic periods and use Nginx to cache and deliver images, videos, and static files from servers closer to the user’s location.


## Step 1: Configure AWS CLI: Set up your AWS credentials using the AWS CLI.

1.1.Enter `aws configure` and paste your aws access and secret keys


1.2.Directory Structure

```langauage
terraform-project/
├── main.tf
├── variables.tf
├── outputs.tf
├── scripts/
│   └── user-data.sh
└── static/
    └── index.html
```

## Step 2: Lets configure the main.tf file 

```language
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = file("scripts/user-data.sh")

  tags = {
    Name = "WebServer"
  }
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_eip" "web_eip" {
  instance = aws_instance.web_server.id
}

output "public_ip" {
  value = aws_eip.web_eip.public_ip
}

```

## code explanation

This Terraform code provisions an AWS EC2 instance with a security group and an Elastic IP (EIP). The EC2 instance, labeled as `web_server`, uses an AMI and instance type defined in variables `(ami_id and instance_type)`, with a user data script `(user-data.sh)`. The instance is associated with a security group `(web_sg)` that allows inbound traffic on `HTTP (port 80)` and `SSH (port 22)`, and all outbound traffic. An Elastic IP `(web_eip)` is allocated and associated with the EC2 instance. The public IP of the Elastic IP is outputted as `public_ip`.


## Step 2: Lets configure the variable.tf file 

```language
variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-085ad6ae776d8f09c" # Amazon Linux 2 AMI (us-east-1)
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}

```

## code explanation


This Terraform code defines three variables used for configuring resources. The `aws_region` variable specifies the AWS region for resource deployment, with a default value of `us-east-1`. The `ami_id`variable defines the AMI ID for the EC2 instance, with a default value of a specific Amazon Linux 2 AMI in the us-east-1 region. The instance_type variable sets the EC2 instance type to `t2.micro` by default, which is a low-cost option suitable for small workloads. These variables are used to parameterize the resource configuration in the earlier Terraform code.

## Step 3 : Lets configure the outputs.tf file 

```language
output "application_url" {
  value = "http://${aws_eip.web_eip.public_ip}"
}

```

## code explanation

This Terraform code defines an output variable named `application_url`, which constructs a URL by combining the `http://` protocol with the public IP address of the Elastic IP` (aws_eip.web_eip.public_ip)`. This value represents the URL where the application hosted on the EC2 instance can be accessed. The output allows the user to easily retrieve and reference the application’s public URL after the Terraform deployment.


## Step 4 : Lets configure the scripts/user-data.sh

This script will install NGINX and deploy the static frontend application.

```language
#!/bin/bash

# Update the system
yum update -y

# Install NGINX
yum install -y nginx

# Start and enable NGINX
systemctl start nginx
systemctl enable nginx

# Deploy static frontend
mkdir -p /usr/share/nginx/html
echo "<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My Website</title>
</head>
<body>
    <h1>Hello,Welcome To Up The Chels Corp!</h1>
    <p>This is a static website hosted on NGINX.</p>
</body>
</html>" > /usr/share/nginx/html/index.html

# Restart NGINX to apply changes
systemctl restart nginx

```

## code explanation

The script installs and configures NGINX on a server, deploys a basic static HTML webpage to be served by NGINX, and ensures that the web server is running and will restart automatically if the system reboots.


## Step 5 : Run Terraform workflow to initialize, validate, plan then apply

5.1.In your visual code studio , to initialize the necessary providers, execute the following command in your visual code studio terminal —

`terraform init`

Upon completion of the initialization process, a successful prompt will be displayed, as shown below.


![image_alt](https://github.com/Tatenda-Prince/Terraform-Static-Web-Deployment-on-EC2-Frontend-behind-Nginx/blob/3dee18dda00eb6a217c77a027890771f262b5e70/img/Screenshot%202025-02-06%20155833.png)


5.2.Next, let’s ensure that our code does not contain any syntax errors by running the following command —

`terraform validate`

The command should generate a success message, confirming that it is valid, as demonstrated below.


![image_alt](https://github.com/Tatenda-Prince/Terraform-Static-Web-Deployment-on-EC2-Frontend-behind-Nginx/blob/93664b7035b2de31883bd2f99eae1aad2bb18b0e/img/Screenshot%202025-02-06%20160117.png)


5.3.Let’s now execute the following command to generate a list of all the modifications that Terraform will apply. —


`terraform plan`


The list of changes that Terraform is anticipated to apply to the infrastructure resources should be displayed. The “+” sign indicates what will be added, while the “-” sign indicates what will be removed.

![image_alt](https://github.com/Tatenda-Prince/Terraform-Static-Web-Deployment-on-EC2-Frontend-behind-Nginx/blob/52e6a9c01cdaaba7d4b55db9c67b67686f5d0e82/img/Screenshot%202025-02-06%20160348.png)


Now, let’s deploy this infrastructure! Execute the following command to apply the changes and deploy the resources.


Note — Make sure to type “yes” to agree to the changes after running this command


`terraform apply`


Terraform will initiate the process of applying all the changes to the infrastructure. Kindly wait for a few seconds for the deployment process to complete.


![image_alt](https://github.com/Tatenda-Prince/Terraform-Static-Web-Deployment-on-EC2-Frontend-behind-Nginx/blob/0e7b7d0babe8ed09433874b03a42320235b63743/img/Screenshot%202025-02-06%20160631.png)


## Success!

The process should now conclude with a message indicating “Apply complete”, stating the total number of added, modified, and destroyed resources, accompanied by several resource outputs.

Please copy and save the application_url, which will be required to access the web page from the browser.

![image_alt](https://github.com/Tatenda-Prince/Terraform-Static-Web-Deployment-on-EC2-Frontend-behind-Nginx/blob/08212240ed685cebe88951f715351e5f2585a7bd/img/Screenshot%202025-02-06%20160640.png)


Now, let’s verify that our resources have been created from reviewing them in the Management Console.


## Step 6 : Verify creation of EC2 Instance 

In the AWS Management Console, head to the EC2 dashboard and verify that there is one EC2 running.

![image_alt](https://github.com/Tatenda-Prince/Terraform-Static-Web-Deployment-on-EC2-Frontend-behind-Nginx/blob/c451ece09650826e5aa5784b7f5ebe46c7ba6bbf/img/Screenshot%202025-02-06%20161103.png)


## Step 7 :Verify reachability to the Web server using its URL in browser

Open up your desired browser and paste the application_url  URL in your browser.


![image_alt]()


## Congratulations!

We’ve successfully completed "Deploying a Static Web Frontend Behind Nginx". We learned how to leverage Terraform to build a reliable and scalable cloud infrastructure that can handle high traffic loads and maintain uptime, even in the event of of high traffic.

## Clean up

## Destroy infrastructure

Run the follow command to remove/delete/tear down all the resources previously provisioned from Terraform —

`terraform destroy`

Wait for it to complete. At the end, you should receive a prompt stating Destroy complete along with how many resources were destroyed.


  































