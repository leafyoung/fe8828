---
title: "FE8828 Programming Web Applications in Finance"
subtitle: "Week 1 <br> What's Internet? What's Web? <br> Launch into the Cloud <br> Catch-up with R"
author: "Dr. Yang Ye <br> <sub> <Email:yy@runchee.com> </sub>"
date: "Nov 02, 2017"
# runtime: shiny
---



# Introduction to this course
## Topics: Week 1-3
- Week 1:
    #. What's Internet? What's Web?
    #. Launch into the Cloud: AWS
    #. R catch-up: R Markdown and Shiny layout
- Week 2:
    #. Data manipulation and visualization: part 1/2
    #. Shiny: part 1/2
- Week 3:
    #. Data manipulation and visualization: part 2/2
    #. Shiny: part 2/2

# Introduction to this course
## Topics: Week 4-6
- Week 4:
    #. Finance application basics
    #. Finance application cases
- Week 5:
    #. Bitcoin and Blockchain
- Week 6:
    #. Further topics of Blockchain
    #. Presentation of Assignment: Web applicaiton.

# Introduction to this course
## Assingments
- Week 1: A static website. A front page, a about page and a description page in the cloud. (due on Week 2)
- Week 2: A dynamic website that can do CRUD. (due on Week 3)
- Week 3: A data-driven website that does data analytics.  (due on Week 4)
- Week 4: A finance-data application website. (due on Week 6)
- Week 5: Reading on Blockchain. (due on Week 7) Working on web assignment. (due on Week 6)
- Week 6: Reading of Blockchain. (due on Week 7)

# Introduction to this course
## Objective
1. Know the way of Internet: the network, the cloud and the application. 
2. Build real-world data-driven reports and dashboard, data visualization.
3. Latest Internet technology in cryptocurrency and payment system like Bitcoin and Blockchain.

Spectrum.
Data ->  Model -> Application

<center>![](imgs/keep-calm-code-on.jpg "Keep calm and code on"){width=45%}</center>


# Lecture 01: What's Internet? What's Web?
## Content
- Network


# Network
<center>![](imgs/Internet_map_1024.jpg "Internet"){width=75%}</center>

# Introduction
A network is to connet the dots.
<center>![](imgs/dot-to-dot-connect-the-dots.jpg "Connect the dots"){width=75%}</center>

Internet is a super network of the world.
<center>![](imgs/network_connect_dots.jpg "Connect the dots"){width=75%}</center>

# What happens to a computer network?
We need to talk to each other.

Layout: Star v.s. inter-connected.

* In a fully inter-connected network, 

1. Information turns to Packet
<center>![](imgs/tcp_header.gif "Network packet"){width=75%}</center>

2. Protocol designs the packet
TCP/IP Protocol - Internet protocol suite
<center>![](imgs/tcp-ip.png "TCP/IP"){width=75%}</center>

Why the Internet succeeded?
What does TCP/IP gives?

The Defense Advanced Research Projects Agency (DARPA), the research branch of the U.S. Department of Defense, created the TCP/IP model in the 1970s for use in ARPANET, a wide area network that preceded the internet.

Four layer approach:
<center>![](imgs/640px-UDP_encapsulation.svg.png "TCP/IP"){width=75%}</center>

3. Infrastructure is to route the packets to the destination.
<center>![](imgs/wireshark-packets.jpg "Wireshark capture of the network"){width=75%}</center>

Locally efficient but not very smart. Tries to be very smart.
leaves space for improvement. Every equipment manufacturer can improve.
Scalable.

# Layered structure:
Low level address

What happens after the cable is plugged in?
<center>![](imgs/cables-plug.jpg "Plug into the network"){width=75%}</center>

* Every network device has a hardware address
* 
When a computer connects to the network, the DHCP client, generally a component of the operating system sends out a DHCP request and recieves an offer from a DHCP server. The offer generally contains:

An IP Address
A subnet mask for that IP address

A gateway that should be used for off-network requests (like those going via the internet)
One or more DNS server addresses so the computer knows where to send DNS requests.
Connecting to a Router

When you plug your computer into a router or associate your wireless adapter with an access point, the computer will usually receive a DHCP response directly from the router, which may itself have requested an IP from the ISP for the interface the modem uses. it will then route traffic from the computer via it's interface connected to the modem where appropriate.

# Image of network plug/wireless network/fibre/underwater fiber.

# DHCP/DNS/Gateway
Home networking guide.

# HTTP(S) protocols

# HTML and WWW

_www._ used be a popular prefix to the website. E.g. www.yahoo.com. Together with _ftp._, _gopher._. It means the domain is serving different services. www for Web, ftp for FTP, gopher for Gopher (you don't what it is).
However, that era is gone. Now it is abbreviated, google.com, facebook.com, uber.com. Not www.....

XML grew out of the document markup world. 

# URL

# To recap
Browser down to HTML/CSS/JavaScript => HTTP => TCP => IP => Network physical.

# Web application
- Why?
- Needless to say. this is not 1995 anymore.

- Easy to develop, no need to compile like C++
- Easy to use, to deployment
- Cross-platform.
- Mobile phone. native app v.s. html.



3.	Development Tools

4.	Amazon Web Services:
4.1.	How to setup S3 for storage, EC2 for virtual machine, Route 53 for DNS.
Reading: TBC
Assignment:
+ Setup a website with AWS.
+ Write a markdown document and publish it website.
+ Use JavaScript to manipulate web page parts

Use programming language to process and present data	Know how to program R and JavaScript for data-driven interactive applications

+ Logic thinking of data processing technical.
+ Clarity in data visualization
+ Dealing the complexity of handling user-interaction.


# Lecture 02: AWS

AWS ways of signing up
* Sign-up with an AWS acccount
* Sign-up AWS Educate acccount
* Apply credit from AWS Educate
* Claim credit from AWS

1. With their own AWS account
Students will need to either create a new AWS account or use one that they've already created. Their AWS account needs to be fully activated by completing phone verification steps and adding a valid credit card. They will need to select the AWS Account option and enter their 12 digit AWS Account ID number when they apply to AWS Educate.
Upon approval, they will be sent a Welcome email with a credit code and important information about their AWS Educate benefits. They can redeem the credit code from the Welcome email to their AWS account. Once the credit has been redeemed to their AWS account, it will automatically be applied to any charges incurred by eligible services they launch as part of your course instructions, until the credit balance has been exhausted or expires. Students will receive a renewal code every 12 months that they are eligible for the program; they will not need to reapply.

2. AWS Educate Starter Account:
A valid credit card is not required for this option. The Starter Account is created for the student and managed by a 3rd party, qwikLABS. The credit is included on the Starter account, and the account will shut down automatically once the credit balance has been exhausted.
Upon approval, students will be sent a Welcome email with a link to set up their password and a second link to bookmark for future logins. Once logged in, they will need to follow the steps in the Starter Account Overview [attached to this case] to access their Starter account and use AWS resources.

Disclaimer:
1. I am not working for Amazon and I don't get paid by this.
2. I am not owning Amazon shares directly and indirectly.
3. I don't plan to long AMZN during the course of this course.
4. I will do a demo for Google Cloud.

Use FBI....
Warning:
You may be charged for using AWS EC2.
Free Tier applies to t1.micro.

# Lecture 03: R Markdown and Shiny layout
## Introduction
<center>![](imgs/Markdown-mark.svg.png "Markdown")</center>

Document is the basis for internet, which we usually call them web _page_.
We write words, put pictures in a document.
Also, we write application in a document.
- *Markdown* is a format that is easy to read and can be converted to other formats, HTML, PDF, Word, Slides.
- R Studio extends it further to create R notebook, interactive document and web application, which is *R Markdown*.
- Shiny is a web programming framework in R. We use it extensively in this course. We begin with the layout part.

# Markdown
HTML is a markup language. It means it "adds" something to the text to decorate it. 

    markup
    /'m<U+0251><U+02D0>k<U+028C>p/
    noun
    1. the amount added to the cost price of goods to cover overheads and profit.
    "a mark-up of 50 per cent"
    2. the process or result of correcting text in preparation for printing.

Markdown is a language is that it adds minimal to the text to decorate it, created by John Gruber in collaboration with Aaron Swartz in 2004.

  A Markdown-formatted document should be publishable as-is, as plain text, without looking like it's been marked up with tags or formatting instructions. - John Gruber
   
# Markdown
Reference in R Studio
- R Markdown Cheat Sheet: Help > Cheatsheets > R Markdown Cheat Sheet,
- R Markdown Reference Guide: Help > Cheatsheets > R Markdown Reference Guide.

Create it via File > New File > R Markdown.
- Document
- Presentation
- Shiny

# Markdown example

    
    ````
    ---
    title: "MFE FE8828 Assignment 1"
    date: 2017-11-03
    output: html_document
    runtime: shiny
    ---
      
    ```{r setup, include = FALSE}
    ```
    
    ```{r, echo = FALSE}
    wellPanel("Inputs",
              numericInput("fav_num", "What's your favorite number?", 3))
    ```
    ````













