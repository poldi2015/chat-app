#!/bin/bash

#
# Install terraform
#

export release=AmazonLinux
sudo yum install -q -y yum-utils
sudo yum-config-manager -q -y --add-repo https://rpm.releases.hashicorp.com/$release/hashicorp.repo
sudo yum -q -y install terraform  
