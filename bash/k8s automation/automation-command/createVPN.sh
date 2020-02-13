#!/bin/bash

read -p 'Insert name of ovpn file : ' nameovpn

podsname=$(kubectl get pods --no-headers=true -o name -n openvpn | awk -F "/" '{print $2}')
serviceip=$(kubectl get service -n openvpn -o=custom-columns=EXTERNAL-IP:.status.loadBalancer.ingress | grep ip | cut -d ":" -f 2 | cut -d "]" -f 1)

kubectl exec -it $podsname -n openvpn -- bash -c "cd /etc/openvpn/setup && ./newClientCert.sh $nameovpn $serviceip"
kubectl cp $podsname:etc/openvpn/certs/pki/$nameovpn.ovpn $nameovpn.ovpn -n openvpn

