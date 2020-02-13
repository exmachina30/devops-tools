#!/bin/bash

read -p "Which service do you want to restart? (Insert service name, example koinp2p) : " podsname
read -p "In which namespace? (Insert core/product) : " namespace

kcs k8-config.staging

if [[ $podsname -ne "" ]]; then     
    kubectl delete pods -l app=$podsname-svc -n $namespace
else
    echo -e "Invalid value: ${valuepods}"
fi