#!/bin/bash

#
# Install terraform
#

export release=AmazonLinux
sudo yum install -q -y yum-utils
sudo yum-config-manager -q -y --add-repo https://rpm.releases.hashicorp.com/$release/hashicorp.repo
sudo yum -q -y install terraform  

echo 'plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"' >~/.terraform.rc
