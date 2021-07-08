#!/bin/bash

alias tf="terraform"
alias tfp="terraform plan -input=false -out tfplan"
alias tfa="terraform apply -auto-approve -input=false tfplan"
