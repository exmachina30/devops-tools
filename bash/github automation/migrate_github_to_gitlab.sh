#!/bin/bash

for i in $(seq 1 4); do
RESPONSE=$(curl -s https://api.github.com/orgs/koinworks/repos?access_token=<YOUR_GITHUB_TOKEN>&page=$i&type=all)
for row in $(echo "${RESPONSE}" | jq -r '.[].name'); do
    git clone git@github.com:koinworks/$row.git
    cd $row
    git remote add upstream https://gitlab-engineering.koinworks.com/koinworks/$row.git
    for b in `git branch -r | grep -v -- '->'`; do git branch --track ${b##origin/} $b; done
    git push upstream --all
    cd ..
done
done