#!/bin/bash

read -p "Which pods do you want to logs? (Insert pods name, example koinp2p): " podsname
read -p "In which namespace? (Insert core/product) : " namespace
read -p "Only error logs (press 1) or all logs (press 2) : " typeerror

kcs k8-config.staging

if [[ $typeerror -eq 1 ]] && [[ $podsname -ne "" ]]; then 
    kubectl logs -l app=$podsname-svc -n $namespace | grep ERR
else [[ $typeerror -eq 2 ]] && [[ $podsname -ne "" ]];
    kubectl logs -l app=$podsname-svc -n $namespace 
fi




