#!/bin/bash

for i in $(seq 1 4); do
RESPONSE=$(curl -s https://api.github.com/orgs/koinworks/repos?access_token=d0aa9e9733d4c9e14dabeb166dcf04c05a19ee86&page=$i&type=all)
for row in $(echo "${RESPONSE}" | jq -r '.[].name'); do
    git clone git@github.com:koinworks/$row.git
    cd $row
    git remote add upstream https://gitlab-engineering.koinworks.com/koinworks/$row.git
    git push origin upstream 
    cd ..
done
done