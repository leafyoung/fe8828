Scope
●	Students can pick up new programming languages quickly, new programming paradigm (reactive, object-oriented) quickly, new functional libraries quickly.
●	Students can tackle problem solving in large and small scales, i.e., understanding the structure of web/browser and make use of it
●	Students can independently and confidently complete computing projects.


Lecture 1 and 2: Foundation
1.	What’s Web and what’s Internet?
1.1.	TCP/IP protocol: where IP address, network protocols, DNS
1.2.	HTTP(S) protocols
1.3.	URL

2.	Languages
2.1.	HTML/CSS
2.2.	JavaScript
2.3.	Markdown: the language for static and interactive documents.;
2.4.	R refresh

3.	Development Tools

4.	Amazon Web Services:
4.1.	How to setup S3 for storage, EC2 for virtual machine, Route 53 for DNS.
Reading: TBC


Assignment:
●	Setup a website with AWS.
●	Write a markdown document and publish it website.
●	Use JavaScript to manipulate web page parts

= Use cloud services to host data-driven web application
= Understanding how internet and network protocol works.	Assignment:
= Learn and use various AWS services cohesively: Route53, EC and S3 to build a website

https://aws.amazon.com/getting-started/tutorials/launch-a-virtual-machine/

Use programming language to process and present data	Know how to program R and JavaScript for data-driven interactive applications

•	Logic thinking of data processing technical.
•	Clarity in data visualization
•	Dealing the complexity of handling user-interaction.



## AWS

http://www.louisaslett.com/RStudio_AMI/
Singapore
ami-a13b59c2

rstudio
rstudio


# Create VPC

# Create Internet gateway

# Create Security Groups

Inbound v.s Outbound rules

Simply put, an inbound firewall protects the network against incoming traffic from the internet or other network segments, namely disallowed connection from outside.

# EBS (Elastic Block Storage)
Use Stop not Terminate for the instance

# Note for T2.micro

sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

Next, we need to make sure that the swap file is enabled even after rebooting the system

Edit the `fstab``file with root privileges in your text editor:

sudo nano /etc/fstab
At the bottom of the file, you need to add a line that will tell the operating system to automatically use the file you created:

/swapfile   none    swap    sw    0   0

# git hub
auto push