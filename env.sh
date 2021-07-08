#!/bin/bash

export AWS_ACCOUNT=$(aws sts get-caller-identity|jq -r .Account)

alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan -var account=${AWS_ACCOUNT} -input=false -out tfplan"
alias tfa="terraform apply -auto-approve -input=false tfplan"
