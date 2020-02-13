#!/bin/bash

file1='deployment-example.yaml'
file2='service-example.yaml'
file3='configmap-example.yaml'
file4='ingress-example.yaml'
file5='hpa-example.yaml'

read -p "Type name of service that you want to deploy? (Insert service name, example koinp2p) : " podsname
read -p "In which namespace? (Insert core/product) : " namespace
read -p "Is this apps need domain? Type the domain if yes : " domain

# Replace deployment.yaml by input from user
sed -i '' "s/default-svc/$podsname-svc/g" $file1 && sed -i '' "s/default-config/$podsname-config/g" $file1 \
&& sed -i '' "s/default-namespace/$namespace/g" $file1 && sed -i '' "s/asgard-default/asgard-$podsname/g" $file1

# Replace service.yaml by input from user
sed -i '' "s/default-svc/$podsname-svc/g" $file2

# Replace ingress.yaml by input from user
sed -i '' "s/default-ingress/$podsname-ingress/g" $file4 && sed -i '' "s/default-domain/$domain/g" $file4 \
&& sed -i '' "s/default-svc/$podsname-svc/g" $file4

# Replace hpa.yaml by input from user
sed -i '' "s/default-hpa/$podsname-hpa/g" $file5 \
&& sed -i '' "s/default-svc/$podsname-svc/g" $file5

# Apply all files
if [[ $podsname -ne "" ]]; then 
    kcs k8-config.staging
    kubectl apply -f $file2 -f $file1 -f $file5
else 
    echo -e "Invalid value: ${podsname}"
fi