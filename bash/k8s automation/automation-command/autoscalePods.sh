#!/bin/bash

read -p "Which pods do you want to expand/revert? (Insert pods name, example koinp2p) : " podsname
read -p "How many do you want to expand/revert capacity of server/pods? (Insert number of pods, example 3) : "  valuepods
read -p "In which namespace? (Insert core/product) : " namespace

kcs k8-config.staging

if [[ $valuepods -ne "" ]]; then 
    echo -e "Scaling ${podsname} to ${valuepods} pods..."
    kubectl scale deploy --replicas=$valuepods $podsname-svc -n $namespace
else 
    echo -e "Invalid value: ${valuepods}"
fi
