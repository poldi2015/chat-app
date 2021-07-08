#!/bin/bash

#
# Install terraform
#

export release=AmazonLinux
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/$release/hashicorp.repo
yum -q -y install terraform  
